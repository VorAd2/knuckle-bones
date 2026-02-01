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

  void updateStats({required bool isWinner}) {
    if (value == null) return;
    value = value!.copyWith(
      gamesPlayed: value!.gamesPlayed + 1,
      wins: isWinner ? value!.wins + 1 : value!.wins,
    );
  }
}
