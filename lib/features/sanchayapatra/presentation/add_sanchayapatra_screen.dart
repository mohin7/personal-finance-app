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
import '../../../data/models/sanchayapatra_model.dart';
import '../../../data/repositories/sanchayapatra_repository.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../providers/sanchayapatra_provider.dart';

class AddSanchayapatraScreen extends ConsumerStatefulWidget {
  final int? editId;
  const AddSanchayapatraScreen({super.key, this.editId});

  @override
  ConsumerState<AddSanchayapatraScreen> createState() =>
      _AddSanchayapatraScreenState();
}

class _AddSanchayapatraScreenState
    extends ConsumerState<AddSanchayapatraScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  String _scheme = AppStrings.sanchayapatraSchemes.first;
  DateTime _purchaseDate = DateTime.now();
  DateTime _maturityDate =
      DateTime.now().add(const Duration(days: 365 * 5));
  bool _isLoading = false;
  SanchayapatraModel? _editModel;

  @override
  void initState() {
    super.initState();
    _rateCtrl.text =
        AppStrings.sanchayapatraRates[_scheme]!.toStringAsFixed(2);
    if (widget.editId != null) _loadForEdit();
  }

  Future<void> _loadForEdit() async {
    final m = await ref
        .read(sanchayapatraRepositoryProvider)
        .getById(widget.editId!);
    if (m != null && mounted) {
      setState(() {
        _editModel = m;
        _scheme = m.schemeName;
        _amountCtrl.text = m.purchaseAmount.toStringAsFixed(0);
        _rateCtrl.text = m.profitRate.toStringAsFixed(2);
        _purchaseDate = m.purchaseDate;
        _maturityDate = m.maturityDate;
      });
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _rateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        title: Text(
            _editModel != null ? 'Edit Sanchayapatra' : 'Add Sanchayapatra'),
        leading: IconButton(
            icon: const Icon(AppIcons.back), onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Scheme',
                  style: TextStyle(
                      fontSize: AppSizes.fontSm,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppStrings.sanchayapatraSchemes.map((s) {
                  final sel = s == _scheme;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _scheme = s;
                      _rateCtrl.text = (AppStrings.sanchayapatraRates[s] ??
                              11.28)
                          .toStringAsFixed(2);
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.accent : context.cardColor,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusFull),
                        border: Border.all(
                            color: sel
                                ? AppColors.accent
                                : AppColors.separator),
                      ),
                      child: Text(s,
                          style: TextStyle(
                              fontSize: AppSizes.fontXs,
                              fontWeight: FontWeight.w500,
                              color: sel ? Colors.white : context.primaryText)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSizes.lg),
              TTAmountField(
                controller: _amountCtrl,
                validator: (v) => v!.isEmpty ? 'Enter amount' : null,
              ),
              const SizedBox(height: AppSizes.md),
              TTTextField(
                label: 'Profit Rate (% p.a.)',
                controller: _rateCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'))
                ],
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSizes.md),
              Row(children: [
                Expanded(
                    child: TTTextField(
                  label: 'Purchase Date',
                  controller: TextEditingController(
                      text: _purchaseDate.displayDate),
                  readOnly: true,
                  prefix: const Icon(AppIcons.calendar, size: 18),
                  onTap: () => _pickDate(true),
                )),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                    child: TTTextField(
                  label: 'Maturity Date',
                  controller: TextEditingController(
                      text: _maturityDate.displayDate),
                  readOnly: true,
                  prefix: const Icon(AppIcons.calendar, size: 18),
                  onTap: () => _pickDate(false),
                )),
              ]),
              const SizedBox(height: AppSizes.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent),
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading
                      ? const CupertinoActivityIndicator(color: Colors.white)
                      : Text(_editModel != null
                          ? 'Update'
                          : 'Add Sanchayapatra'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickDate(bool isPurchase) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: context.cardColor,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: isPurchase ? _purchaseDate : _maturityDate,
          onDateTimeChanged: (d) => setState(
              () => isPurchase ? _purchaseDate = d : _maturityDate = d),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final model = _editModel ?? SanchayapatraModel();
    model
      ..schemeName = _scheme
      ..purchaseAmount = double.tryParse(_amountCtrl.text) ?? 0
      ..profitRate = double.tryParse(_rateCtrl.text) ?? 0
      ..purchaseDate = _purchaseDate
      ..maturityDate = _maturityDate
      ..isActive = _maturityDate.isAfter(DateTime.now())
      ..createdAt = _editModel?.createdAt ?? DateTime.now();
    final notifier = ref.read(sanchayapatraNotifierProvider.notifier);
    if (_editModel != null) {
      await notifier.save(model);
    } else {
      await notifier.add(model);
    }
    if (mounted) {
      context.showSnack(
          _editModel != null ? 'Updated' : 'Sanchayapatra added');
      context.pop();
    }
    setState(() => _isLoading = false);
  }
}
