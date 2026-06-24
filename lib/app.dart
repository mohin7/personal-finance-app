import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/lock/presentation/lock_screen.dart';
import 'shared/providers/biometric_provider.dart';
import 'shared/providers/theme_provider.dart';

class TakaTrackApp extends ConsumerWidget {
  const TakaTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final biometricEnabled = ref.watch(biometricEnabledProvider);
    final isUnlocked = ref.watch(isUnlockedProvider);

    return MaterialApp.router(
      title: 'ExpenseTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) {
        if (biometricEnabled && !isUnlocked) {
          return const LockScreen();
        }
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
