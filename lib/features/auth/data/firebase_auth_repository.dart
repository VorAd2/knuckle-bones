import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:knuckle_bones/core/domain/user_entity.dart';
import 'package:knuckle_bones/features/auth/domain/i_auth_repository.dart';

class FirebaseAuthRepository implements IAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserEntity? _mapUser(User? firebaseUser) {
    if (firebaseUser == null) return null;
    return UserEntity(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? 'Player',
    );
  }

  @override
  Stream<UserEntity?> get userChanges {
    return _auth.userChanges().map(_mapUser);
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception('Erro ao logar: $e');
    }
  }

  Future<void> _checkIfNameIsTaken(String name) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('name', isEqualTo: name)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      throw Exception('O nome "$name" já está em uso. Escolha outro.');
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    await _checkIfNameIsTaken(name);

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;
      await _firestore.collection('users').doc(uid).set({
        'id': uid,
        'email': email,
        'name': name,
        'wins': 0,
        'gamesPlayed': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await credential.user!.updateDisplayName(name);
      await credential.user!.reload();
    } catch (e) {
      throw Exception('Erro no cadastro: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
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
}
