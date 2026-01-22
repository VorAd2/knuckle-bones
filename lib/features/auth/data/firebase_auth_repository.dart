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
  Stream<UserEntity?> get authStateChanges {
    return _auth.authStateChanges().map(_mapUser);
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception('Erro ao logar: $e');
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;
      await credential.user!.updateDisplayName(name);

      await _firestore.collection('users').doc(uid).set({
        'id': uid,
        'email': email,
        'name': name,
        'wins': 0,
        'gamesPlayed': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await credential.user!.reload();
    } catch (e) {
      throw Exception('Erro ao cadastrar: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
