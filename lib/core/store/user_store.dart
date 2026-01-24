import 'package:flutter/foundation.dart';
import 'package:knuckle_bones/core/domain/user_entity.dart';

class UserStore extends ValueNotifier<UserEntity?> {
  UserStore() : super(null);

  bool get hasUser => value != null;

  void setUser(UserEntity user) {
    value = user;
  }

  void clearUser() {
    value = null;
  }
}
