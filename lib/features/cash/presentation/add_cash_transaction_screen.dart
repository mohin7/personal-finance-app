import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../data/models/cash_account_model.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../providers/cash_provider.dart';
import '../../../shared/widgets/app_icon.dart';

class AddCashTransactionScreen extends ConsumerStatefulWidget {
  const AddCashTransactionScreen({super.key});

  @override
  ConsumerState<AddCashTransactionScreen> createState() =>
      _AddCashTransactionScreenState();
}

class _AddCashTransactionScreenState
    extends ConsumerState<AddCashTransactionScreen> {
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _type = 'deposit';
  CashAccountModel? _selectedAccount;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(cashAccountsStreamProvider);
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        title: const Text('Cash Transaction'),
        leading: IconButton(
            icon: const AppIcon(AppIcons.back), onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type toggle
            CupertinoSegmentedControl<String>(
              children: const {
                'deposit': Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('Deposit')),
                'withdrawal': Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('Withdraw')),
              },
              groupValue: _type,
              onValueChanged: (v) => setState(() => _type = v),
            ),
            const SizedBox(height: AppSizes.lg),

            TTAmountField(controller: _amountCtrl),
            const SizedBox(height: AppSizes.lg),

            // Account picker
            const Text('Account',
                style: TextStyle(
                    fontSize: AppSizes.fontSm,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            accountsAsync.when(
              data: (accounts) => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: accounts.map((a) {
                  final sel = a.id == _selectedAccount?.id;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedAccount = a),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            sel ? AppColors.success : context.cardColor,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusFull),
                        border: Border.all(
                            color: sel
                                ? AppColors.success
                                : AppColors.separator),
                      ),
                      child: Text(a.name,
                          style: TextStyle(
                              color:
                                  sel ? Colors.white : context.primaryText,
                              fontWeight: FontWeight.w500,
                              fontSize: AppSizes.fontSm)),
                    ),
                  );
                }).toList(),
              ),
              loading: () => const CupertinoActivityIndicator(),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: AppSizes.md),

            TTTextField(
              label: 'Description (optional)',
              controller: _descCtrl,
            ),
            const SizedBox(height: AppSizes.xl),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: _type == 'deposit'
                        ? AppColors.success
                        : AppColors.error),
                onPressed: _isLoading ? null : _save,
                child: _isLoading
                    ? const CupertinoActivityIndicator(color: Colors.white)
                    : Text(_type == 'deposit'
                        ? 'Add Deposit'
                        : 'Record Withdrawal'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_amountCtrl.text.isEmpty || _selectedAccount == null) {
      context.showSnack('Please select account and enter amount', isError: true);
      return;
    }
    setState(() => _isLoading = true);
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    final notifier = ref.read(cashNotifierProvider.notifier);
    if (_type == 'deposit') {
      await notifier.deposit(
          _selectedAccount!.id, amount, _descCtrl.text.isEmpty ? null : _descCtrl.text);
    } else {
      await notifier.withdraw(
          _selectedAccount!.id, amount, _descCtrl.text.isEmpty ? null : _descCtrl.text);
    }
    if (mounted) {
      context.showSnack('Transaction recorded');
      context.pop();
    }
    setState(() => _isLoading = false);
  }
}
