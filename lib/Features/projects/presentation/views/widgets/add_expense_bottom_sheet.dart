import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:takween/core/widgets/custom_dropdown_form_field.dart';
import 'package:takween/core/widgets/custom_text_form_field.dart';

class AddExpenseBottomSheet extends StatefulWidget {
  final bool isAdding;
  final Future<void> Function({
    required String category,
    required String description,
    required double amountUsd,
    required DateTime paidAt,
  })
  onSubmit;

  const AddExpenseBottomSheet({
    super.key,
    required this.isAdding,
    required this.onSubmit,
  });

  @override
  State<AddExpenseBottomSheet> createState() => _AddExpenseBottomSheetState();
}

class _AddExpenseBottomSheetState extends State<AddExpenseBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  static const _categories = [
    'MATERIALS',
    'LABOR',
    'EQUIPMENT',
    'FINISHING',
    'PERMITS',
    'OTHER',
  ];

  String _category = 'MATERIALS';
  DateTime _paidAt = DateTime.now();

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _paidAt,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _paidAt = picked);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await widget.onSubmit(
      category: _category,
      description: _descriptionController.text.trim(),
      amountUsd: double.parse(_amountController.text.trim()),
      paidAt: _paidAt,
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20.h,
        left: 20.w,
        right: 20.w,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.textQuaternaryLight,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.receipt,
                      color: AppColors.primary,
                      size: 18.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Log Expense',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Record construction expenses for cash-flow tracking.',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textTertiaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              CustomDropdownFormField<String>(
                label: 'Category',
                hintText: 'Select category',
                value: _category,
                items: _categories
                    .map(
                      (c) => DropdownMenuItem<String>(
                        value: c,
                        child: Text(c.replaceAll('_', ' ')),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _category = value);
                },
              ),
              CustomTextFormField(
                label: 'Description',
                hintText: 'e.g. Cement 50 tons',
                controller: _descriptionController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                label: 'Amount (USD)',
                hintText: 'e.g. 6000',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                controller: _amountController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  final n = double.tryParse(value.trim());
                  if (n == null || n <= 0) return 'Must be greater than 0';
                  return null;
                },
              ),
              _DatePickerRow(date: _paidAt, onTap: _pickDate),
              SizedBox(height: 12.h),
              widget.isAdding
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  : CustomButton(
                      title: 'Log Expense',
                      icon: Icons.add,
                      color: AppColors.primary,
                      onTap: _submit,
                    ),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: widget.isAdding
                    ? null
                    : () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textTertiaryLight),
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _DatePickerRow extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;

  const _DatePickerRow({required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Paid on',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18.sp,
                  color: AppColors.textTertiaryLight,
                ),
                SizedBox(width: 10.w),
                Text(
                  date.toLocal().formattedDate,
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}
