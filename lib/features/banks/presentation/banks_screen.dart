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
import '../../../data/models/bank_account_model.dart';
import '../../../shared/widgets/amount_display.dart';
import '../../../shared/widgets/delete_dialog.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/tt_card.dart';
import '../providers/bank_provider.dart';

class BanksScreen extends ConsumerWidget {
  const BanksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banksAsync = ref.watch(bankStreamProvider);

    return Scaffold(
      backgroundColor: context.bgColor,
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Bank Accounts'),
            backgroundColor: context.bgColor,
            border: Border.all(color: Colors.transparent),
          ),
          banksAsync.when(
            data: (banks) {
              if (banks.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyState(
                    icon: AppIcons.bank,
                    title: 'No bank accounts',
                    subtitle: 'Add your bank accounts to track balances',
                    actionLabel: 'Add Account',
                    onAction: () => context.push(AppRoutes.addBank),
                  ),
                );
              }
              final total =
                  banks.fold<double>(0, (s, b) => s + b.balance);
              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _TotalBankCard(total: total),
                    const SizedBox(height: AppSizes.md),
                    ...banks.asMap().entries.map(
                          (e) => Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSizes.sm),
                            child: _BankCard(bank: e.value)
                                .animate()
                                .fadeIn(
                                    delay: Duration(
                                        milliseconds: e.key * 60),
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
        backgroundColor: AppColors.info,
        onPressed: () => context.push(AppRoutes.addBank),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TotalBankCard extends StatelessWidget {
  final double total;
  const _TotalBankCard({required this.total});

  @override
  Widget build(BuildContext context) {
    return TTGradientCard(
      gradient: const LinearGradient(
        colors: [Color(0xFF007AFF), Color(0xFF0051D5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Bank Balance',
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

class _BankCard extends ConsumerWidget {
  final BankAccountModel bank;
  const _BankCard({required this.bank});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TTCard(
      onTap: () => context.push('/banks/edit/${bank.id}'),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(AppIcons.bank, color: AppColors.info, size: 22),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bank.bankName,
                    style: const TextStyle(
                        fontSize: AppSizes.fontMd,
                        fontWeight: FontWeight.w600)),
                Text(bank.accountName,
                    style: const TextStyle(
                        fontSize: AppSizes.fontSm,
                        color: AppColors.textSecondary)),
              ],
            ),
          ),
          AmountDisplay(amount: bank.balance, fontSize: 16),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(AppIcons.delete,
                color: AppColors.textSecondary, size: 18),
            onPressed: () async {
              if (await showDeleteDialog(context)) {
                await ref
                    .read(bankNotifierProvider.notifier)
                    .delete(bank.id);
                if (context.mounted) context.showSnack('Account deleted');
              }
            },
          ),
        ],
      ),
    );
  }
}
