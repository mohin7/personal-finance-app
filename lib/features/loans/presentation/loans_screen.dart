import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/router/app_router.dart';
import '../../../data/models/loan_model.dart';
import '../../../shared/widgets/delete_dialog.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/tt_card.dart';
import '../providers/loan_provider.dart';

class LoansScreen extends ConsumerStatefulWidget {
  const LoansScreen({super.key});

  @override
  ConsumerState<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends ConsumerState<LoansScreen> {
  int _tab = 0; // 0 = lent, 1 = borrowed

  @override
  Widget build(BuildContext context) {
    final lentAsync = ref.watch(lentStreamProvider);
    final borrowedAsync = ref.watch(borrowedStreamProvider);
    final current = _tab == 0 ? lentAsync : borrowedAsync;

    return Scaffold(
      backgroundColor: context.bgColor,
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Lend & Borrow'),
            backgroundColor: context.bgColor,
            border: Border.all(color: Colors.transparent),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPadding, vertical: 8),
              child: _SummaryRow(
                  lentAsync: lentAsync, borrowedAsync: borrowedAsync),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPadding, vertical: 8),
              child: CupertinoSegmentedControl<int>(
                children: const {
                  0: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('I Lent'),
                  ),
                  1: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('I Borrowed'),
                  ),
                },
                groupValue: _tab,
                onValueChanged: (v) => setState(() => _tab = v),
              ),
            ),
          ),
          current.when(
            data: (loans) {
              if (loans.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyState(
                    icon: AppIcons.loan,
                    title: _tab == 0 ? 'No lent records' : 'No borrow records',
                    subtitle: _tab == 0
                        ? 'Track money you gave to others'
                        : 'Track money you borrowed',
                    actionLabel: _tab == 0 ? 'Add Lent' : 'Add Borrowed',
                    onAction: () => context.push(
                        '${AppRoutes.addLoan}?type=${_tab == 0 ? 'lent' : 'borrowed'}'),
                  ),
                );
              }
              final pending = loans.where((l) => !l.isSettled).toList();
              final settled = loans.where((l) => l.isSettled).toList();
              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    if (pending.isNotEmpty) ...[
                      _ListLabel('Pending (${pending.length})'),
                      ...pending.asMap().entries.map((e) => _LoanCard(
                            loan: e.value,
                            tab: _tab,
                          )
                              .animate()
                              .fadeIn(
                                  delay: Duration(milliseconds: e.key * 50),
                                  duration: 250.ms)),
                    ],
                    if (settled.isNotEmpty) ...[
                      _ListLabel('Settled (${settled.length})'),
                      ...settled.map((l) => _LoanCard(loan: l, tab: _tab)),
                    ],
                    const SizedBox(height: 100),
                  ]),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
                child: Center(child: CupertinoActivityIndicator())),
            error: (e, _) =>
                SliverFillRemaining(child: Center(child: Text('Error: $e'))),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            _tab == 0 ? AppColors.warning : AppColors.error,
        onPressed: () => context.push(
            '${AppRoutes.addLoan}?type=${_tab == 0 ? 'lent' : 'borrowed'}'),
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final AsyncValue<List<LoanModel>> lentAsync;
  final AsyncValue<List<LoanModel>> borrowedAsync;
  const _SummaryRow({required this.lentAsync, required this.borrowedAsync});

  @override
  Widget build(BuildContext context) {
    final totalLent = lentAsync.valueOrNull
            ?.where((l) => !l.isSettled)
            .fold<double>(0, (s, l) => s + l.amount) ??
        0;
    final totalBorrowed = borrowedAsync.valueOrNull
            ?.where((l) => !l.isSettled)
            .fold<double>(0, (s, l) => s + l.amount) ??
        0;

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'To Receive',
            amount: totalLent,
            color: AppColors.warning,
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: _SummaryCard(
            label: 'To Pay Back',
            amount: totalBorrowed,
            color: AppColors.error,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  const _SummaryCard(
      {required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: AppSizes.fontXs,
                  color: color,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(amount.taka,
              style: TextStyle(
                  fontSize: AppSizes.fontLg,
                  fontWeight: FontWeight.w800,
                  color: color)),
        ],
      ),
    );
  }
}

class _ListLabel extends StatelessWidget {
  final String text;
  const _ListLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(text.toUpperCase(),
          style: const TextStyle(
              fontSize: AppSizes.fontXs,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary)),
    );
  }
}

class _LoanCard extends ConsumerWidget {
  final LoanModel loan;
  final int tab;
  const _LoanCard({required this.loan, required this.tab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = tab == 0 ? AppColors.warning : AppColors.error;
    final fmt = DateFormat('dd MMM yyyy');

    return TTCard(
      onTap: loan.isSettled
          ? null
          : () => context.push('/loans/edit/${loan.id}'),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: loan.isSettled
                  ? AppColors.success.withValues(alpha: 0.1)
                  : color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              loan.isSettled
                  ? CupertinoIcons.checkmark_circle
                  : CupertinoIcons.person_2,
              color: loan.isSettled ? AppColors.success : color,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(loan.personName,
                    style: const TextStyle(
                        fontSize: AppSizes.fontMd,
                        fontWeight: FontWeight.w700)),
                Text(
                  loan.isSettled
                      ? 'Settled on ${fmt.format(loan.settledDate!)}'
                      : fmt.format(loan.date),
                  style: const TextStyle(
                      fontSize: AppSizes.fontSm,
                      color: AppColors.textSecondary),
                ),
                if (loan.note != null && loan.note!.isNotEmpty)
                  Text(loan.note!,
                      style: const TextStyle(
                          fontSize: AppSizes.fontXs,
                          color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(loan.amount.taka,
                  style: TextStyle(
                      fontSize: AppSizes.fontMd,
                      fontWeight: FontWeight.w800,
                      color: loan.isSettled ? AppColors.success : color)),
              if (!loan.isSettled)
                GestureDetector(
                  onTap: () async {
                    final confirm = await showCupertinoDialog<bool>(
                      context: context,
                      builder: (_) => CupertinoAlertDialog(
                        title: const Text('Mark as Settled?'),
                        content: Text(
                            'Mark ৳${loan.amount.toStringAsFixed(0)} with ${loan.personName} as settled?'),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Settle'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await ref.read(loanNotifierProvider.notifier).settle(loan.id);
                    }
                  },
                  child: const Text('Settle',
                      style: TextStyle(
                          fontSize: AppSizes.fontXs,
                          color: AppColors.success,
                          fontWeight: FontWeight.w600)),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.trash,
                color: AppColors.textSecondary, size: 18),
            onPressed: () async {
              if (await showDeleteDialog(context)) {
                await ref.read(loanNotifierProvider.notifier).delete(loan.id);
              }
            },
          ),
        ],
      ),
    );
  }
}
