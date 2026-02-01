import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:knuckle_bones/core/domain/user_entity.dart';

class UserRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<UserEntity> getUserDetails(UserEntity authUser) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(authUser.id)
          .get();
      final data = snapshot.data();
      return UserEntity(
        id: authUser.id,
        email: authUser.email,
        name: data?['name'] ?? authUser.name,
        avatarFile: null,
        gamesPlayed: data?['gamesPlayed'] ?? 0,
        wins: data?['wins'] ?? 0,
      );
    } catch (e) {
      return authUser;
    }
  }

  Future<void> updateUser({
    required String newName,
    required File? avatar,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Nenhum usuário logado para atualizar.');
    }

    final querySnapshot = await _firestore
        .collection('users')
        .where('name', isEqualTo: newName)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id;
      if (docId != user.uid) {
        throw Exception('O nome "$newName" já está em uso.');
      }
    }

    try {
      await user.updateDisplayName(newName);
      await _firestore.collection('users').doc(user.uid).update({
        'name': newName,
      });
      await user.reload();
    } catch (e) {
      throw Exception('Erro ao atualizar dados: $e');
    }
  }

  Future<void> incrementUserStats({
    required String userId,
    required bool isWinner,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'gamesPlayed': FieldValue.increment(1),
        'wins': isWinner ? FieldValue.increment(1) : FieldValue.increment(0),
      });
    } catch (e) {
      debugPrint('Falha ao atualizar stats no servidor: $e');
    }
  }
}
