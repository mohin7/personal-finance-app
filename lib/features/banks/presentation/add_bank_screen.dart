import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../data/models/bank_account_model.dart';
import '../../../data/repositories/bank_repository.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../providers/bank_provider.dart';
import '../../../shared/widgets/app_icon.dart';

class AddBankScreen extends ConsumerStatefulWidget {
  final int? editId;
  const AddBankScreen({super.key, this.editId});

  @override
  ConsumerState<AddBankScreen> createState() => _AddBankScreenState();
}

class _AddBankScreenState extends ConsumerState<AddBankScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bankNameCtrl = TextEditingController();
  final _accountNameCtrl = TextEditingController();
  final _accountNumberCtrl = TextEditingController();
  final _balanceCtrl = TextEditingController();
  final _branchCtrl = TextEditingController();
  bool _isLoading = false;
  BankAccountModel? _editModel;

  @override
  void initState() {
    super.initState();
    if (widget.editId != null) _loadForEdit();
  }

  Future<void> _loadForEdit() async {
    final m = await ref.read(bankRepositoryProvider).getById(widget.editId!);
    if (m != null && mounted) {
      setState(() {
        _editModel = m;
        _bankNameCtrl.text = m.bankName;
        _accountNameCtrl.text = m.accountName;
        _accountNumberCtrl.text = m.accountNumber;
        _balanceCtrl.text = m.balance.toStringAsFixed(2);
        _branchCtrl.text = m.branchName ?? '';
      });
    }
  }

  @override
  void dispose() {
    _bankNameCtrl.dispose();
    _accountNameCtrl.dispose();
    _accountNumberCtrl.dispose();
    _balanceCtrl.dispose();
    _branchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editId != null;
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Bank Account' : 'Add Bank Account'),
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
                hint: 'e.g. Dutch-Bangla Bank',
                controller: _bankNameCtrl,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSizes.md),
              TTTextField(
                label: 'Account Name',
                hint: 'Account holder name',
                controller: _accountNameCtrl,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSizes.md),
              TTTextField(
                label: 'Account Number',
                controller: _accountNumberCtrl,
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSizes.md),
              TTTextField(
                label: 'Current Balance (৳)',
                hint: '0.00',
                controller: _balanceCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'))
                ],
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSizes.md),
              TTTextField(
                label: 'Branch Name (optional)',
                controller: _branchCtrl,
              ),
              const SizedBox(height: AppSizes.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.info),
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading
                      ? const CupertinoActivityIndicator(color: Colors.white)
                      : Text(isEdit ? 'Update Account' : 'Add Account'),
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
    final model = _editModel ?? BankAccountModel();
    model
      ..bankName = _bankNameCtrl.text
      ..accountName = _accountNameCtrl.text
      ..accountNumber = _accountNumberCtrl.text
      ..balance = double.tryParse(_balanceCtrl.text) ?? 0
      ..branchName = _branchCtrl.text.isEmpty ? null : _branchCtrl.text
      ..createdAt = _editModel?.createdAt ?? DateTime.now();
    final notifier = ref.read(bankNotifierProvider.notifier);
    if (_editModel != null) {
      await notifier.save(model);
    } else {
      await notifier.add(model);
    }
    if (mounted) {
      context.showSnack(_editModel != null ? 'Account updated' : 'Account added');
      context.pop();
    }
    setState(() => _isLoading = false);
  }
}
