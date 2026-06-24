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
import '../../../data/models/investment_model.dart';
import '../../../data/repositories/investment_repository.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../providers/investment_provider.dart';
import '../../../shared/widgets/app_icon.dart';

class AddInvestmentScreen extends ConsumerStatefulWidget {
  final int? editId;
  const AddInvestmentScreen({super.key, this.editId});

  @override
  ConsumerState<AddInvestmentScreen> createState() =>
      _AddInvestmentScreenState();
}

class _AddInvestmentScreenState
    extends ConsumerState<AddInvestmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _investedCtrl = TextEditingController();
  final _currentCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String _type = AppStrings.investmentTypes.first;
  DateTime _purchaseDate = DateTime.now();
  bool _isLoading = false;
  InvestmentModel? _editModel;

  @override
  void initState() {
    super.initState();
    if (widget.editId != null) _loadForEdit();
  }

  Future<void> _loadForEdit() async {
    final model = await ref
        .read(investmentRepositoryProvider)
        .getById(widget.editId!);
    if (model != null && mounted) {
      setState(() {
        _editModel = model;
        _nameCtrl.text = model.name;
        _investedCtrl.text = model.investedAmount.toStringAsFixed(2);
        _currentCtrl.text = model.currentValue.toStringAsFixed(2);
        _notesCtrl.text = model.notes ?? '';
        _type = model.type;
        _purchaseDate = model.purchaseDate;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _investedCtrl.dispose();
    _currentCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editId != null;
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Investment' : 'Add Investment'),
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
              TTTextField(
                label: 'Investment Name',
                hint: 'e.g. BEXIMCO Stock, Gold Bar',
                controller: _nameCtrl,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: AppSizes.md),

              // Type chips
              const Text('Type',
                  style: TextStyle(
                      fontSize: AppSizes.fontSm,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppStrings.investmentTypes.map((t) {
                  final sel = t == _type;
                  return GestureDetector(
                    onTap: () => setState(() => _type = t),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.warning : context.cardColor,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusFull),
                        border: Border.all(
                          color: sel
                              ? AppColors.warning
                              : AppColors.separator,
                        ),
                      ),
                      child: Text(t,
                          style: TextStyle(
                            fontSize: AppSizes.fontSm,
                            fontWeight: FontWeight.w500,
                            color:
                                sel ? Colors.white : context.primaryText,
                          )),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSizes.lg),

              Row(
                children: [
                  Expanded(
                    child: TTTextField(
                      label: 'Invested Amount (৳)',
                      hint: '0.00',
                      controller: _investedCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'))
                      ],
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: TTTextField(
                      label: 'Current Value (৳)',
                      hint: '0.00',
                      controller: _currentCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'))
                      ],
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),

              TTTextField(
                label: 'Purchase Date',
                controller: TextEditingController(
                    text: _purchaseDate.displayDate),
                readOnly: true,
                prefix: const AppIcon(AppIcons.calendar, size: 18),
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (_) => Container(
                      height: 300,
                      color: context.cardColor,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: _purchaseDate,
                        maximumDate: DateTime.now(),
                        onDateTimeChanged: (d) =>
                            setState(() => _purchaseDate = d),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSizes.md),

              TTTextField(
                label: 'Notes (optional)',
                controller: _notesCtrl,
                maxLines: 2,
              ),
              const SizedBox(height: AppSizes.xl),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning),
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading
                      ? const CupertinoActivityIndicator(
                          color: Colors.white)
                      : Text(isEdit ? 'Update Investment' : 'Add Investment'),
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

    final model = _editModel ?? InvestmentModel();
    model
      ..name = _nameCtrl.text
      ..type = _type
      ..investedAmount = _investedCtrl.text.toAmount
      ..currentValue = _currentCtrl.text.toAmount
      ..purchaseDate = _purchaseDate
      ..notes = _notesCtrl.text.isEmpty ? null : _notesCtrl.text
      ..createdAt = _editModel?.createdAt ?? DateTime.now();

    final notifier = ref.read(investmentNotifierProvider.notifier);
    if (_editModel != null) {
      await notifier.save(model);
    } else {
      await notifier.add(model);
    }

    if (mounted) {
      context.showSnack(_editModel != null
          ? 'Investment updated'
          : 'Investment added');
      context.pop();
    }
    setState(() => _isLoading = false);
  }
}
