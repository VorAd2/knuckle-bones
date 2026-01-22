import 'package:knuckle_bones/core/domain/user_entity.dart';

abstract class IAuthRepository {
  Stream<UserEntity?> get authStateChanges;

  Future<void> signIn({required String email, required String password});

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  });

  Future<void> signOut();
}
