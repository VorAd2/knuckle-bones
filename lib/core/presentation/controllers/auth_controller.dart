import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/domain/user_entity.dart';
import 'package:knuckle_bones/core/domain/i_auth_repository.dart';

class AuthController extends ChangeNotifier {
  final IAuthRepository _repository;
  bool _isLoading = false;
  String? _errorMessage;

  AuthController(this._repository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> signIn(String email, String password) async {
    return _performAuthAction(
      () => _repository.signIn(email: email, password: password),
    );
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    return _performAuthAction(
      () => _repository.signUp(email: email, password: password, name: name),
    );
  }

  Future<void> signOut() => _repository.signOut();

  Future<bool> _performAuthAction(Future<void> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await action();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception:', '').trim();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
