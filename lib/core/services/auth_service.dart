import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class AuthService extends ChangeNotifier {
  bool _isAdmin = false;
  String _adminPassword = AppConstants.defaultAdminPassword;

  bool get isAdmin => _isAdmin;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isAdmin = prefs.getBool('is_admin_mode') ?? false;
    _adminPassword = prefs.getString('admin_password') ?? AppConstants.defaultAdminPassword;
    notifyListeners();
  }

  Future<bool> loginAsAdmin(String inputPassword) async {
    if (inputPassword == _adminPassword) {
      _isAdmin = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_admin_mode', true);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logoutAdmin() async {
    _isAdmin = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_admin_mode', false);
    notifyListeners();
  }

  Future<bool> changeAdminPassword(String oldPass, String newPass) async {
    if (oldPass == _adminPassword && newPass.trim().isNotEmpty) {
      _adminPassword = newPass;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('admin_password', newPass);
      notifyListeners();
      return true;
    }
    return false;
  }
}
