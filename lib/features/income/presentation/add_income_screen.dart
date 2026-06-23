import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/extensions.dart';
import '../../../data/models/income_model.dart';
import '../../../data/repositories/income_repository.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../providers/income_provider.dart';

class AddIncomeScreen extends ConsumerStatefulWidget {
  final int? editId;
  const AddIncomeScreen({super.key, this.editId});

  @override
  ConsumerState<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends ConsumerState<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String _source = AppStrings.incomeSources.first;
  DateTime _date = DateTime.now();
  bool _isLoading = false;
  IncomeModel? _editModel;

  @override
  void initState() {
    super.initState();
    if (widget.editId != null) _loadForEdit();
  }

  Future<void> _loadForEdit() async {
    final model =
        await ref.read(incomeRepositoryProvider).getById(widget.editId!);
    if (model != null && mounted) {
      setState(() {
        _editModel = model;
        _amountCtrl.text = model.amount.toStringAsFixed(2);
        _notesCtrl.text = model.notes ?? '';
        _source = model.source;
        _date = model.date;
      });
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editId != null;
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Income' : 'Add Income'),
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
              TTAmountField(
                controller: _amountCtrl,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter amount' : null,
              ),
              const SizedBox(height: AppSizes.lg),

              const Text('Income Source',
                  style: TextStyle(
                      fontSize: AppSizes.fontSm,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppStrings.incomeSources.map((s) {
                  final sel = s == _source;
                  return GestureDetector(
                    onTap: () => setState(() => _source = s),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            sel ? AppColors.success : context.cardColor,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusFull),
                        border: Border.all(
                          color: sel
                              ? AppColors.success
                              : AppColors.separator,
                        ),
                      ),
                      child: Text(s,
                          style: TextStyle(
                            fontSize: AppSizes.fontSm,
                            fontWeight: FontWeight.w500,
                            color: sel ? Colors.white : context.primaryText,
                          )),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSizes.lg),

              TTTextField(
                label: 'Date',
                controller: TextEditingController(text: _date.displayDate),
                readOnly: true,
                prefix: const Icon(AppIcons.calendar, size: 18),
                onTap: () {
                  showCupertinoModalPopup(
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

              TTTextField(
                label: 'Notes (optional)',
                hint: 'Any notes?',
                controller: _notesCtrl,
                maxLines: 2,
              ),
              const SizedBox(height: AppSizes.xl),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success),
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading
                      ? const CupertinoActivityIndicator(
                          color: Colors.white)
                      : Text(isEdit ? 'Update Income' : 'Add Income'),
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

    final model = _editModel ?? IncomeModel();
    model
      ..amount = _amountCtrl.text.toAmount
      ..source = _source
      ..date = _date
      ..notes = _notesCtrl.text.isEmpty ? null : _notesCtrl.text
      ..createdAt = _editModel?.createdAt ?? DateTime.now();

    final notifier = ref.read(incomeNotifierProvider.notifier);
    if (_editModel != null) {
      await notifier.save(model);
    } else {
      await notifier.add(model);
    }

    if (mounted) {
      context.showSnack(
          _editModel != null ? 'Income updated' : 'Income added');
      context.pop();
    }
    setState(() => _isLoading = false);
  }
}
