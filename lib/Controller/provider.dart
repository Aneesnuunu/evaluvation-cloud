// auth_provider.dart
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  // Your authentication related state and methods will go here
  // For example:
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
