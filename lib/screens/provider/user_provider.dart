import 'package:flutter/material.dart';
import 'package:free_note/models/user_model.dart';
import 'package:free_note/utils/shared_prefs.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool get isLoggedIn => _user != null;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
  }

  Future<bool> register(String name, String email, String password) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) return false;

    List<User> users = await UserStorage.loadUser();
    bool exists = users.any((u) => u.email == email);
    if (exists) return false;

    for (var u in users) {
      u.isLoggedIn = false;
    }

    User newUser = User(name: name, email: email, password: password, isLoggedIn: true);
    users.add(newUser);
    await UserStorage.saveUser(users);

    _user = newUser;
    notifyListeners();
    return true;
  }

  Future<bool> login(String email, String password) async {
    List<User> users = await UserStorage.loadUser();

    User? matchedUser;
    for (var u in users) {
      if (u.email == email && u.password == password) {
        matchedUser = u;
      }
      u.isLoggedIn = false;
    }

    if (matchedUser != null) {
      matchedUser.isLoggedIn = true;
      await UserStorage.saveUser(users);
      _user = matchedUser;
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<void> tryAutoLogin() async {
    List<User> users = await UserStorage.loadUser();
    User? loggedInUser;
    for (var u in users) {
      if (u.isLoggedIn) {
        loggedInUser = u;
        break;
      }
    }
    if (loggedInUser != null) {
      _user = loggedInUser;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    if (_user != null) {
      List<User> users = await UserStorage.loadUser();
      for (var u in users) {
        u.isLoggedIn = false;
      }
      await UserStorage.saveUser(users);

      _user = null;
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      notifyListeners();
    }
  }
}
