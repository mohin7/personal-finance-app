import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../data/models/fdr_model.dart';
import '../../../data/repositories/fdr_repository.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../providers/fdr_provider.dart';

class AddFdrScreen extends ConsumerStatefulWidget {
  final int? editId;
  const AddFdrScreen({super.key, this.editId});

  @override
  ConsumerState<AddFdrScreen> createState() => _AddFdrScreenState();
}

class _AddFdrScreenState extends ConsumerState<AddFdrScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bankNameCtrl = TextEditingController();
  final _fdrNameCtrl = TextEditingController();
  final _principalCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _maturityDate = DateTime.now().add(const Duration(days: 365));
  bool _isLoading = false;
  FdrModel? _editModel;

  @override
  void initState() {
    super.initState();
    if (widget.editId != null) _loadForEdit();
  }

  Future<void> _loadForEdit() async {
    final m = await ref.read(fdrRepositoryProvider).getById(widget.editId!);
    if (m != null && mounted) {
      setState(() {
        _editModel = m;
        _bankNameCtrl.text = m.bankName;
        _fdrNameCtrl.text = m.fdrName;
        _principalCtrl.text = m.principalAmount.toStringAsFixed(0);
        _rateCtrl.text = m.interestRate.toStringAsFixed(2);
        _startDate = m.startDate;
        _maturityDate = m.maturityDate;
      });
    }
  }

  @override
  void dispose() {
    _bankNameCtrl.dispose();
    _fdrNameCtrl.dispose();
    _principalCtrl.dispose();
    _rateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        title: Text(_editModel != null ? 'Edit FDR' : 'Add FDR'),
        leading: IconButton(
            icon: const Icon(AppIcons.back), onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TTTextField(
                  label: 'Bank Name',
                  controller: _bankNameCtrl,
                  validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: AppSizes.md),
              TTTextField(
                  label: 'FDR Name / Reference',
                  controller: _fdrNameCtrl,
                  validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: AppSizes.md),
              Row(children: [
                Expanded(
                    child: TTTextField(
                  label: 'Principal Amount (৳)',
                  hint: '100000',
                  controller: _principalCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                )),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                    child: TTTextField(
                  label: 'Interest Rate (%)',
                  hint: '11.5',
                  controller: _rateCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                )),
              ]),
              const SizedBox(height: AppSizes.md),
              Row(children: [
                Expanded(
                    child: TTTextField(
                  label: 'Start Date',
                  controller: TextEditingController(
                      text: _startDate.displayDate),
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
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading
                      ? const CupertinoActivityIndicator(color: Colors.white)
                      : Text(_editModel != null ? 'Update FDR' : 'Add FDR'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickDate(bool isStart) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: context.cardColor,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: isStart ? _startDate : _maturityDate,
          onDateTimeChanged: (d) =>
              setState(() => isStart ? _startDate = d : _maturityDate = d),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final model = _editModel ?? FdrModel();
    model
      ..bankName = _bankNameCtrl.text
      ..fdrName = _fdrNameCtrl.text
      ..principalAmount = double.tryParse(_principalCtrl.text) ?? 0
      ..interestRate = double.tryParse(_rateCtrl.text) ?? 0
      ..startDate = _startDate
      ..maturityDate = _maturityDate
      ..isActive = _maturityDate.isAfter(DateTime.now())
      ..createdAt = _editModel?.createdAt ?? DateTime.now();
    final notifier = ref.read(fdrNotifierProvider.notifier);
    if (_editModel != null) {
      await notifier.save(model);
    } else {
      await notifier.add(model);
    }
    if (mounted) {
      context.showSnack(_editModel != null ? 'FDR updated' : 'FDR added');
      context.pop();
    }
    setState(() => _isLoading = false);
  }
}
