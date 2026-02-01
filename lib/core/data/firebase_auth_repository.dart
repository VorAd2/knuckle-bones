import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:knuckle_bones/core/domain/user_entity.dart';
import 'package:knuckle_bones/core/domain/i_auth_repository.dart';
import 'package:knuckle_bones/core/utils/auth_error_mapper.dart';

class FirebaseAuthRepository implements IAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserEntity? _mapUser(User? firebaseUser) {
    if (firebaseUser == null) return null;
    return UserEntity(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? 'Player',
      avatarFile: null,
    );
  }

  @override
  Stream<UserEntity?> get authChanges {
    return _auth.authStateChanges().map(_mapUser);
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception(AuthErrorMapper.getMessage(e));
    }
  }

  Future<void> _checkIfNameIsTaken(String name) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('name', isEqualTo: name)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      throw Exception('The name "$name" is already in use');
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
      throw Exception(AuthErrorMapper.getMessage(e));
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
