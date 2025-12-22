import 'package:knuckle_bones/core/domain/user_entity.dart';

class SessionController {
  late UserEntity _currentUser;
  UserEntity get currentUser => _currentUser;

  void loadMockUser() {
    _currentUser = UserEntity.mock();
  }

  void editUsername(String newUsername) {
    _currentUser.name = newUsername;
  }

  // void logout() { ... }
}
