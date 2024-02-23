import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userIdKey = 'userId';
  static const String _userRoleKey = 'userRole';
  static const String _teamIdKey = 'teamId';

  static Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  static Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
  }

  static Future<void> resetUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, -1);
  }

  static Future<void> saveUserRole(UserRole userRole) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userRoleKey, userRoleText(userRole));
  }

  static Future<UserRole?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return stringToUserRole(prefs.getString(_userRoleKey)!);
  }

  static Future<void> resetUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userRoleKey, "");
  }

  static Future<void> saveTeamId(int teamId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_teamIdKey, teamId);
  }

  static Future<void> resetTeamId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_teamIdKey, -1);
  }

  static Future<int?> getTeamId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_teamIdKey);
  }
}

Future<void> checkLoginStatus(WidgetRef ref) async {
  bool isLoggedIn = await AuthStorage.getLoginStatus();
  if (isLoggedIn) {
    int? userId = await AuthStorage.getUserId();
    UserRole? userRole = await AuthStorage.getUserRole();
    int? teamId = await AuthStorage.getTeamId();

    ref.read(userIdProvider.notifier).state = userId!;
    ref.read(userRoleProvider.notifier).state = userRole!;
    ref.read(teamIdProvider.notifier).state = teamId!;
  }
}
