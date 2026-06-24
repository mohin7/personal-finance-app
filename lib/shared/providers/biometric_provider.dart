import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kBiometricKey = 'biometric_lock_enabled';

final biometricEnabledProvider =
    StateNotifierProvider<BiometricEnabledNotifier, bool>((ref) {
  return BiometricEnabledNotifier();
});

class BiometricEnabledNotifier extends StateNotifier<bool> {
  BiometricEnabledNotifier() : super(false) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_kBiometricKey) ?? false;
  }

  Future<void> toggle() async {
    final prefs = await SharedPreferences.getInstance();
    state = !state;
    await prefs.setBool(_kBiometricKey, state);
  }

  Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    state = value;
    await prefs.setBool(_kBiometricKey, value);
  }
}

// Tracks whether the user has authenticated this session
final isUnlockedProvider = StateProvider<bool>((ref) => false);
