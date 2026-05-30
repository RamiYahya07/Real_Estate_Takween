import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:takween/core/widgets/custom_text_form_field.dart';

class DetailedFeasibilityBottomSheet extends StatefulWidget {
  final bool isRunning;
  final Future<void> Function({
    required double marketPricePerSqmUsd,
    required double sellingExpensePercent,
    required double discountRatePercent,
    double? monthlyRentPerSqmUsd,
    required double annualMaintenancePercent,
    required double vacancyRatePercent,
  }) onSubmit;

  const DetailedFeasibilityBottomSheet({
    super.key,
    required this.isRunning,
    required this.onSubmit,
  });

  @override
  State<DetailedFeasibilityBottomSheet> createState() =>
      _DetailedFeasibilityBottomSheetState();
}

class _DetailedFeasibilityBottomSheetState
    extends State<DetailedFeasibilityBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _marketPrice = TextEditingController();
  final _sellingExpense = TextEditingController(text: '3');
  final _discountRate = TextEditingController(text: '10');
  final _monthlyRent = TextEditingController();
  final _annualMaintenance = TextEditingController(text: '2');
  final _vacancyRate = TextEditingController(text: '5');

  @override
  void dispose() {
    _marketPrice.dispose();
    _sellingExpense.dispose();
    _discountRate.dispose();
    _monthlyRent.dispose();
    _annualMaintenance.dispose();
    _vacancyRate.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await widget.onSubmit(
      marketPricePerSqmUsd: double.parse(_marketPrice.text.trim()),
      sellingExpensePercent: double.parse(_sellingExpense.text.trim()),
      discountRatePercent: double.parse(_discountRate.text.trim()),
      monthlyRentPerSqmUsd: _monthlyRent.text.trim().isEmpty
          ? null
          : double.tryParse(_monthlyRent.text.trim()),
      annualMaintenancePercent: double.parse(_annualMaintenance.text.trim()),
      vacancyRatePercent: double.parse(_vacancyRate.text.trim()),
    );
    if (mounted) Navigator.pop(context);
  }

  String? _requiredPositive(String? value, {bool allowZero = false}) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final n = double.tryParse(value.trim());
    if (n == null) return 'Invalid';
    if (!allowZero && n <= 0) return 'Must be > 0';
    if (allowZero && n < 0) return 'Cannot be negative';
    return null;
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
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
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
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.chartPie,
                      color: AppColors.accent,
                      size: 18.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detailed Feasibility',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'ROI, NPV, IRR and optional rental analysis.',
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
              SizedBox(height: 16.h),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTextFormField(
                        label: 'Market price per m² (USD)',
                        hintText: 'e.g. 1500',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        controller: _marketPrice,
                        validator: _requiredPositive,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              label: 'Selling expense %',
                              hintText: '3',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              controller: _sellingExpense,
                              validator: (v) =>
                                  _requiredPositive(v, allowZero: true),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomTextFormField(
                              label: 'Discount rate %',
                              hintText: '10',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              controller: _discountRate,
                              validator: _requiredPositive,
                            ),
                          ),
                        ],
                      ),
                      CustomTextFormField(
                        label: 'Monthly rent per m² (USD, optional)',
                        hintText: 'leave empty to skip rental analysis',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        controller: _monthlyRent,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return null;
                          }
                          final n = double.tryParse(value.trim());
                          if (n == null || n < 0) return 'Invalid';
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              label: 'Annual maintenance %',
                              hintText: '2',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              controller: _annualMaintenance,
                              validator: (v) =>
                                  _requiredPositive(v, allowZero: true),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomTextFormField(
                              label: 'Vacancy rate %',
                              hintText: '5',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              controller: _vacancyRate,
                              validator: (v) =>
                                  _requiredPositive(v, allowZero: true),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              widget.isRunning
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  : CustomButton(
                      title: 'Run Detailed Feasibility',
                      icon: Icons.calculate_outlined,
                      color: AppColors.accent,
                      onTap: _submit,
                    ),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: widget.isRunning
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
