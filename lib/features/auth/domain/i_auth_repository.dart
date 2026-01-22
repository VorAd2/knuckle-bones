import 'dart:io';

import 'package:knuckle_bones/core/domain/user_entity.dart';

abstract class IAuthRepository {
  Stream<UserEntity?> get userChanges;

  Future<void> signIn({required String email, required String password});

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  });

  Future<void> signOut();

  Future<void> updateUser({required String newName, required File? avatar});
}
