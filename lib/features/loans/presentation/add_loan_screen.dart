import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../data/models/loan_model.dart';
import '../../../data/repositories/loan_repository.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../providers/loan_provider.dart';

class AddLoanScreen extends ConsumerStatefulWidget {
  final String type; // 'lent' | 'borrowed'
  final int? editId;
  const AddLoanScreen({super.key, required this.type, this.editId});

  @override
  ConsumerState<AddLoanScreen> createState() => _AddLoanScreenState();
}

class _AddLoanScreenState extends ConsumerState<AddLoanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  late String _type;
  DateTime _date = DateTime.now();
  bool _isLoading = false;
  LoanModel? _editModel;

  @override
  void initState() {
    super.initState();
    _type = widget.type;
    if (widget.editId != null) _loadEdit();
  }

  Future<void> _loadEdit() async {
    final model =
        await ref.read(loanRepositoryProvider).getById(widget.editId!);
    if (model != null && mounted) {
      setState(() {
        _editModel = model;
        _type = model.type;
        _nameCtrl.text = model.personName;
        _amountCtrl.text = model.amount.toStringAsFixed(0);
        _noteCtrl.text = model.note ?? '';
        _date = model.date;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final model = _editModel ?? LoanModel();
    model
      ..type = _type
      ..personName = _nameCtrl.text.trim()
      ..amount = double.tryParse(_amountCtrl.text.replaceAll(',', '')) ?? 0
      ..date = _date
      ..note = _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim()
      ..createdAt = _editModel != null ? model.createdAt : DateTime.now();

    final notifier = ref.read(loanNotifierProvider.notifier);
    if (_editModel != null) {
      await notifier.save(model);
    } else {
      await notifier.add(model);
    }

    if (mounted) {
      context.showSnack(_editModel != null ? 'Updated' : 'Saved');
      context.pop();
    }
    setState(() => _isLoading = false);
  }

  void _pickDate() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: context.bgColor,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: _date,
          maximumDate: DateTime.now(),
          onDateTimeChanged: (d) => setState(() => _date = d),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLent = _type == 'lent';
    final color = isLent ? AppColors.warning : AppColors.error;
    final fmt = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        backgroundColor: context.bgColor,
        title: Text(_editModel != null
            ? 'Edit Record'
            : isLent
                ? 'I Lent Money'
                : 'I Borrowed Money'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSizes.screenPadding),
                children: [
            // Type selector
            if (_editModel == null)
              CupertinoSegmentedControl<String>(
                children: const {
                  'lent': Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('I Lent'),
                  ),
                  'borrowed': Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('I Borrowed'),
                  ),
                },
                groupValue: _type,
                onValueChanged: (v) => setState(() => _type = v),
              ),
            const SizedBox(height: AppSizes.md),

            // Person name
            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: isLent ? 'Lent to' : 'Borrowed from',
                hintText: 'Person name',
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: context.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter a name' : null,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: AppSizes.sm),

            // Amount
            TTAmountField(controller: _amountCtrl),
            const SizedBox(height: AppSizes.sm),

            // Date
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: AppSizes.sm),
                    Text(fmt.format(_date),
                        style: const TextStyle(fontSize: AppSizes.fontMd)),
                    const Spacer(),
                    const Icon(CupertinoIcons.chevron_right,
                        size: 14, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.sm),

            // Note
            TextFormField(
              controller: _noteCtrl,
              decoration: InputDecoration(
                labelText: 'Note (optional)',
                hintText: 'What is it for?',
                prefixIcon: const Icon(Icons.notes_outlined),
                filled: true,
                fillColor: context.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 2,
            ),
                ],
              ),
            ),
            // Save button pinned at bottom
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSizes.screenPadding, 12, AppSizes.screenPadding, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: color,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusMd),
                      ),
                    ),
                    child: _isLoading
                        ? const CupertinoActivityIndicator(
                            color: Colors.white)
                        : const Text('Save',
                            style: TextStyle(
                                fontSize: AppSizes.fontMd,
                                fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
