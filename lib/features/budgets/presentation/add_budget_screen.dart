import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/extensions.dart';
import '../../../data/models/budget_model.dart';
import '../../../data/repositories/budget_repository.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../providers/budget_provider.dart';
import '../../../shared/widgets/app_icon.dart';

class AddBudgetScreen extends ConsumerStatefulWidget {
  final int? editId;
  const AddBudgetScreen({super.key, this.editId});

  @override
  ConsumerState<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends ConsumerState<AddBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  String _category = AppStrings.expenseCategories.first;
  bool _isLoading = false;
  BudgetModel? _editModel;

  @override
  void initState() {
    super.initState();
    if (widget.editId != null) _loadForEdit();
  }

  Future<void> _loadForEdit() async {
    final m =
        await ref.read(budgetRepositoryProvider).getById(widget.editId!);
    if (m != null && mounted) {
      setState(() {
        _editModel = m;
        _category = m.category;
        _amountCtrl.text = m.allocatedAmount.toStringAsFixed(0);
      });
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        title: Text(
            _editModel != null ? 'Edit Budget' : 'Create Budget'),
        leading: IconButton(
            icon: const AppIcon(AppIcons.back), onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Category',
                  style: TextStyle(
                      fontSize: AppSizes.fontSm,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppStrings.expenseCategories.map((cat) {
                  final sel = cat == _category;
                  return GestureDetector(
                    onTap: () => setState(() => _category = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.warning : context.cardColor,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusFull),
                        border: Border.all(
                            color: sel
                                ? AppColors.warning
                                : AppColors.separator),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppIcon(AppIcons.categoryIcon(cat),
                              size: 13,
                              color: sel
                                  ? Colors.white
                                  : AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(cat,
                              style: TextStyle(
                                  fontSize: AppSizes.fontXs,
                                  fontWeight: FontWeight.w500,
                                  color: sel
                                      ? Colors.white
                                      : context.primaryText)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSizes.lg),
              TTTextField(
                label: 'Monthly Budget Amount (৳)',
                hint: '10000',
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => v!.isEmpty ? 'Enter amount' : null,
              ),
              const SizedBox(height: AppSizes.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning),
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading
                      ? const CupertinoActivityIndicator(color: Colors.white)
                      : Text(
                          _editModel != null ? 'Update Budget' : 'Set Budget'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final now = DateTime.now();
    final model = _editModel ?? BudgetModel();
    model
      ..category = _category
      ..allocatedAmount = double.tryParse(_amountCtrl.text) ?? 0
      ..spentAmount = _editModel?.spentAmount ?? 0
      ..month = now.month
      ..year = now.year
      ..createdAt = _editModel?.createdAt ?? DateTime.now();
    final notifier = ref.read(budgetNotifierProvider.notifier);
    if (_editModel != null) {
      await notifier.save(model);
    } else {
      await notifier.add(model);
    }
    if (mounted) {
      context.showSnack(
          _editModel != null ? 'Budget updated' : 'Budget created');
      context.pop();
    }
    setState(() => _isLoading = false);
  }
}
