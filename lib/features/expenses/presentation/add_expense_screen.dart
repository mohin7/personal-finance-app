import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/extensions.dart';
import '../../../data/models/expense_model.dart';
import '../../../data/repositories/expense_repository.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../providers/expense_provider.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  final int? editId;
  const AddExpenseScreen({super.key, this.editId});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  String _category = AppStrings.expenseCategories.first;
  String _paymentMethod = AppStrings.paymentMethods.first;
  DateTime _date = DateTime.now();
  bool _isLoading = false;
  ExpenseModel? _editModel;

  @override
  void initState() {
    super.initState();
    if (widget.editId != null) _loadForEdit();
  }

  Future<void> _loadForEdit() async {
    final model = await ref
        .read(expenseRepositoryProvider)
        .getById(widget.editId!);
    if (model != null && mounted) {
      setState(() {
        _editModel = model;
        _amountCtrl.text = model.amount.toStringAsFixed(2);
        _noteCtrl.text = model.note ?? '';
        _category = model.category;
        _paymentMethod = model.paymentMethod;
        _date = model.date;
      });
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editId != null;
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Expense' : 'Add Expense'),
        leading: IconButton(
          icon: const Icon(AppIcons.back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount
              TTAmountField(
                controller: _amountCtrl,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter amount' : null,
              ),
              const SizedBox(height: AppSizes.lg),

              // Category
              const Text(
                'Category',
                style: TextStyle(
                  fontSize: AppSizes.fontSm,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              _CategoryGrid(
                selected: _category,
                onSelect: (c) => setState(() => _category = c),
              ),
              const SizedBox(height: AppSizes.lg),

              // Date
              TTTextField(
                label: 'Date',
                controller: TextEditingController(
                    text: _date.displayDate),
                readOnly: true,
                prefix: const Icon(AppIcons.calendar, size: 18),
                onTap: () async {
                  await showCupertinoModalPopup<void>(
                    context: context,
                    builder: (_) => Container(
                      height: 300,
                      color: context.cardColor,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: _date,
                        maximumDate: DateTime.now(),
                        onDateTimeChanged: (d) =>
                            setState(() => _date = d),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSizes.md),

              // Payment Method
              TTTextField(
                label: 'Payment Method',
                controller: TextEditingController(text: _paymentMethod),
                readOnly: true,
                suffix: const Icon(Icons.arrow_drop_down),
                onTap: () => _pickPaymentMethod(context),
              ),
              const SizedBox(height: AppSizes.md),

              // Note
              TTTextField(
                label: 'Note (optional)',
                hint: 'What was this for?',
                controller: _noteCtrl,
                maxLines: 2,
              ),
              const SizedBox(height: AppSizes.xl),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading
                      ? const CupertinoActivityIndicator(color: Colors.white)
                      : Text(isEdit ? 'Update Expense' : 'Add Expense'),
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

    final model = _editModel ?? ExpenseModel();
    model
      ..amount = _amountCtrl.text.toAmount
      ..category = _category
      ..date = _date
      ..note = _noteCtrl.text.isEmpty ? null : _noteCtrl.text
      ..paymentMethod = _paymentMethod
      ..createdAt = model.createdAt.microsecondsSinceEpoch == 0
          ? DateTime.now()
          : model.createdAt;

    final notifier = ref.read(expenseNotifierProvider.notifier);
    if (_editModel != null) {
      await notifier.save(model);
    } else {
      await notifier.add(model);
    }

    if (mounted) {
      context.showSnack(
          _editModel != null ? 'Expense updated' : 'Expense added');
      context.pop();
    }
    setState(() => _isLoading = false);
  }

  void _pickPaymentMethod(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Payment Method'),
        actions: AppStrings.paymentMethods.map((m) {
          return CupertinoActionSheetAction(
            isDefaultAction: m == _paymentMethod,
            onPressed: () {
              setState(() => _paymentMethod = m);
              Navigator.pop(context);
            },
            child: Text(m),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final String selected;
  final void Function(String) onSelect;
  const _CategoryGrid({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppStrings.expenseCategories.map((cat) {
        final isSelected = cat == selected;
        return GestureDetector(
          onTap: () => onSelect(cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : context.cardColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.separator,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  AppIcons.categoryIcon(cat),
                  size: 14,
                  color: isSelected
                      ? Colors.white
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  cat,
                  style: TextStyle(
                    fontSize: AppSizes.fontSm,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : context.primaryText,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
