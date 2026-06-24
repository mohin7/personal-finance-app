import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../data/models/dps_model.dart';
import '../../../data/repositories/dps_repository.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../providers/dps_provider.dart';
import '../../../shared/widgets/app_icon.dart';

class AddDpsScreen extends ConsumerStatefulWidget {
  final int? editId;
  const AddDpsScreen({super.key, this.editId});

  @override
  ConsumerState<AddDpsScreen> createState() => _AddDpsScreenState();
}

class _AddDpsScreenState extends ConsumerState<AddDpsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bankNameCtrl = TextEditingController();
  final _dpsNameCtrl = TextEditingController();
  final _monthlyCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _maturityDate =
      DateTime.now().add(const Duration(days: 365));
  bool _isLoading = false;
  DpsModel? _editModel;

  @override
  void initState() {
    super.initState();
    if (widget.editId != null) _loadForEdit();
  }

  Future<void> _loadForEdit() async {
    final m = await ref.read(dpsRepositoryProvider).getById(widget.editId!);
    if (m != null && mounted) {
      setState(() {
        _editModel = m;
        _bankNameCtrl.text = m.bankName;
        _dpsNameCtrl.text = m.dpsName;
        _monthlyCtrl.text = m.monthlyDeposit.toStringAsFixed(0);
        _rateCtrl.text = m.interestRate.toStringAsFixed(2);
        _startDate = m.startDate;
        _maturityDate = m.maturityDate;
      });
    }
  }

  @override
  void dispose() {
    _bankNameCtrl.dispose();
    _dpsNameCtrl.dispose();
    _monthlyCtrl.dispose();
    _rateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        title:
            Text(_editModel != null ? 'Edit DPS' : 'Add DPS'),
        leading: IconButton(
            icon: const AppIcon(AppIcons.back), onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TTTextField(
                label: 'Bank Name',
                hint: 'e.g. Sonali Bank',
                controller: _bankNameCtrl,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSizes.md),
              TTTextField(
                label: 'DPS Name / Account',
                hint: 'e.g. Monthly DPS 2024',
                controller: _dpsNameCtrl,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    child: TTTextField(
                      label: 'Monthly Deposit (৳)',
                      hint: '5000',
                      controller: _monthlyCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: TTTextField(
                      label: 'Interest Rate (%)',
                      hint: '11.5',
                      controller: _rateCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'))
                      ],
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    child: TTTextField(
                      label: 'Start Date',
                      controller: TextEditingController(
                          text: _startDate.displayDate),
                      readOnly: true,
                      prefix: const AppIcon(AppIcons.calendar, size: 18),
                      onTap: () => _pickDate(context, isStart: true),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: TTTextField(
                      label: 'Maturity Date',
                      controller: TextEditingController(
                          text: _maturityDate.displayDate),
                      readOnly: true,
                      prefix: const AppIcon(AppIcons.calendar, size: 18),
                      onTap: () => _pickDate(context, isStart: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading
                      ? const CupertinoActivityIndicator(color: Colors.white)
                      : Text(
                          _editModel != null ? 'Update DPS' : 'Add DPS'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickDate(BuildContext context, {required bool isStart}) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: context.cardColor,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: isStart ? _startDate : _maturityDate,
          onDateTimeChanged: (d) => setState(
              () => isStart ? _startDate = d : _maturityDate = d),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final model = _editModel ?? DpsModel();
    model
      ..bankName = _bankNameCtrl.text
      ..dpsName = _dpsNameCtrl.text
      ..monthlyDeposit = double.tryParse(_monthlyCtrl.text) ?? 0
      ..interestRate = double.tryParse(_rateCtrl.text) ?? 0
      ..startDate = _startDate
      ..maturityDate = _maturityDate
      ..isActive = _maturityDate.isAfter(DateTime.now())
      ..createdAt = _editModel?.createdAt ?? DateTime.now();
    final notifier = ref.read(dpsNotifierProvider.notifier);
    if (_editModel != null) {
      await notifier.save(model);
    } else {
      await notifier.add(model);
    }
    if (mounted) {
      context.showSnack(
          _editModel != null ? 'DPS updated' : 'DPS added');
      context.pop();
    }
    setState(() => _isLoading = false);
  }
}
