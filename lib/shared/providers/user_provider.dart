import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kUserNameKey = 'user_name';

final userNameProvider =
    StateNotifierProvider<UserNameNotifier, String>((ref) {
  return UserNameNotifier();
});

class UserNameNotifier extends StateNotifier<String> {
  UserNameNotifier() : super('') {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_kUserNameKey) ?? '';
  }

  Future<void> setName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    state = name.trim();
    await prefs.setString(_kUserNameKey, name.trim());
  }
}
