import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/router/app_router.dart';
import '../../../data/models/cash_account_model.dart';
import '../../../shared/widgets/amount_display.dart';
import '../../../shared/widgets/delete_dialog.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/tt_card.dart';
import '../providers/cash_provider.dart';

class CashScreen extends ConsumerWidget {
  const CashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(cashAccountsStreamProvider);

    return Scaffold(
      backgroundColor: context.bgColor,
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Cash'),
            backgroundColor: context.bgColor,
            border: Border.all(color: Colors.transparent),
            trailing: IconButton(
              icon: const Icon(CupertinoIcons.add_circled),
              onPressed: () => _showAddAccount(context, ref),
            ),
          ),
          accountsAsync.when(
            data: (accounts) {
              if (accounts.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyState(
                    icon: AppIcons.cash,
                    title: 'No cash accounts',
                    subtitle: 'Add a cash wallet to track',
                    actionLabel: 'Add Account',
                    onAction: () => _showAddAccount(context, ref),
                  ),
                );
              }
              final total = accounts.fold<double>(0, (s, a) => s + a.balance);
              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _TotalCashCard(total: total),
                    const SizedBox(height: AppSizes.md),
                    ...accounts.asMap().entries.map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSizes.sm),
                            child: _CashAccountCard(account: e.value)
                                .animate()
                                .fadeIn(
                                    delay:
                                        Duration(milliseconds: e.key * 60),
                                    duration: 300.ms),
                          ),
                        ),
                    const SizedBox(height: 100),
                  ]),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
                child: Center(child: CupertinoActivityIndicator())),
            error: (e, _) => SliverFillRemaining(
                child: Center(child: Text('Error: $e'))),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.success,
        onPressed: () => context.push(AppRoutes.addCashTransaction),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddAccount(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final balanceCtrl = TextEditingController();
    String type = 'Cash in Hand';

    showCupertinoModalPopup(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState) => Container(
          height: 380,
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSizes.radiusXxl)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Cash Account',
                  style: TextStyle(
                      fontSize: AppSizes.fontLg,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSizes.md),
              CupertinoTextField(
                controller: nameCtrl,
                placeholder: 'Account name',
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              CupertinoTextField(
                controller: balanceCtrl,
                placeholder: 'Opening balance (৳)',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              CupertinoSegmentedControl<String>(
                children: const {
                  'Cash in Hand': Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Cash', style: TextStyle(fontSize: 12))),
                  'Personal Wallet': Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Wallet', style: TextStyle(fontSize: 12))),
                  'Emergency Fund': Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Emergency', style: TextStyle(fontSize: 12))),
                },
                groupValue: type,
                onValueChanged: (v) => setState(() => type = v),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  child: const Text('Add Account'),
                  onPressed: () async {
                    if (nameCtrl.text.isEmpty) return;
                    final account = CashAccountModel()
                      ..name = nameCtrl.text
                      ..type = type
                      ..balance =
                          double.tryParse(balanceCtrl.text) ?? 0
                      ..createdAt = DateTime.now();
                    await ref
                        .read(cashNotifierProvider.notifier)
                        .addAccount(account);
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TotalCashCard extends StatelessWidget {
  final double total;
  const _TotalCashCard({required this.total});

  @override
  Widget build(BuildContext context) {
    return TTGradientCard(
      gradient: const LinearGradient(
        colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Cash',
              style: TextStyle(
                  fontSize: AppSizes.fontSm,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          AmountDisplay(amount: total, fontSize: 34, color: Colors.white),
        ],
      ),
    );
  }
}

class _CashAccountCard extends ConsumerWidget {
  final CashAccountModel account;
  const _CashAccountCard({required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TTCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(AppIcons.cash,
                color: AppColors.success, size: 22),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(account.name,
                    style: const TextStyle(
                        fontSize: AppSizes.fontMd,
                        fontWeight: FontWeight.w600)),
                Text(account.type,
                    style: const TextStyle(
                        fontSize: AppSizes.fontSm,
                        color: AppColors.textSecondary)),
              ],
            ),
          ),
          AmountDisplay(
              amount: account.balance,
              fontSize: 16,
              color: AppColors.success),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(AppIcons.delete,
                color: AppColors.textSecondary, size: 18),
            onPressed: () async {
              if (await showDeleteDialog(context)) {
                await ref
                    .read(cashNotifierProvider.notifier)
                    .deleteAccount(account.id);
              }
            },
          ),
        ],
      ),
    );
  }
}
