import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../shared/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Scaffold(
      backgroundColor: context.bgColor,
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Settings'),
            backgroundColor: context.bgColor,
            border: Border.all(color: Colors.transparent),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SectionLabel('Appearance'),
                _SettingCard(
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.dark_mode_outlined,
                            color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Dark Mode',
                                style: TextStyle(
                                    fontSize: AppSizes.fontMd,
                                    fontWeight: FontWeight.w600)),
                            Text(
                                isDark ? 'Dark theme active' : 'Light theme active',
                                style: const TextStyle(
                                    fontSize: AppSizes.fontSm,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      CupertinoSwitch(
                        value: isDark,
                        activeTrackColor: AppColors.primary,
                        onChanged: (v) => ref
                            .read(themeModeProvider.notifier)
                            .toggle(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                _SectionLabel('Theme'),
                _ThemeModeSelector(current: themeMode, ref: ref),
                const SizedBox(height: AppSizes.md),
                _SectionLabel('Security'),
                _SettingCard(
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(AppIcons.biometric,
                            color: AppColors.info, size: 18),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Biometric Lock',
                                style: TextStyle(
                                    fontSize: AppSizes.fontMd,
                                    fontWeight: FontWeight.w600)),
                            Text('Unlock with fingerprint or face',
                                style: TextStyle(
                                    fontSize: AppSizes.fontSm,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      CupertinoSwitch(
                        value: false,
                        activeTrackColor: AppColors.info,
                        onChanged: (_) {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                _SectionLabel('About'),
                _SettingCard(
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color:
                              AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.info_outline,
                            color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('TakaTrack',
                                style: TextStyle(
                                    fontSize: AppSizes.fontMd,
                                    fontWeight: FontWeight.w600)),
                            Text('Version 1.0.0 — Personal Finance for Bangladesh',
                                style: TextStyle(
                                    fontSize: AppSizes.fontSm,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                _SettingCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete_forever_outlined,
                          color: AppColors.error, size: 18),
                    ),
                    title: const Text('Clear All Data',
                        style: TextStyle(
                            fontSize: AppSizes.fontMd,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error)),
                    subtitle: const Text('This action cannot be undone',
                        style: TextStyle(
                            fontSize: AppSizes.fontSm,
                            color: AppColors.textSecondary)),
                    onTap: () => _confirmClear(context),
                  ),
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
            'All your financial records will be permanently deleted. This cannot be undone.'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('Clear'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: AppSizes.fontXs,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final Widget child;
  const _SettingCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: child,
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  final ThemeMode current;
  final WidgetRef ref;
  const _ThemeModeSelector({required this.current, required this.ref});

  @override
  Widget build(BuildContext context) {
    return _SettingCard(
      child: CupertinoSegmentedControl<ThemeMode>(
        children: const {
          ThemeMode.light: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text('Light', style: TextStyle(fontSize: 13))),
          ThemeMode.system: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text('System', style: TextStyle(fontSize: 13))),
          ThemeMode.dark: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text('Dark', style: TextStyle(fontSize: 13))),
        },
        groupValue: current,
        onValueChanged: (v) =>
            ref.read(themeModeProvider.notifier).setTheme(v),
      ),
    );
  }
}
