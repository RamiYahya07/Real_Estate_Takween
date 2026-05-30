import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:takween/core/widgets/custom_text_form_field.dart';

class PreliminaryFeasibilityBottomSheet extends StatefulWidget {
  final bool isLoading;
  final Future<void> Function(double marketPricePerSqmUsd) onSubmit;

  const PreliminaryFeasibilityBottomSheet({
    super.key,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  State<PreliminaryFeasibilityBottomSheet> createState() =>
      _PreliminaryFeasibilityBottomSheetState();
}

class _PreliminaryFeasibilityBottomSheetState
    extends State<PreliminaryFeasibilityBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final text = _priceController.text.trim();

    final value = double.tryParse(text);

    if (value == null) return;

    await widget.onSubmit(value);

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
                    FontAwesomeIcons.calculator,
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
                        'Quick Feasibility',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Estimate buildable area & gross revenue based on a market price.',
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
            CustomTextFormField(
              label: 'Market price per m² (USD)',
              hintText: 'e.g. 1500',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              controller: _priceController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Required';
                }
                final n = double.tryParse(value.trim());
                if (n == null || n <= 0) {
                  return 'Must be greater than 0';
                }
                return null;
              },
            ),
            SizedBox(height: 4.h),
            widget.isLoading
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : CustomButton(
                    title: 'Calculate',
                    icon: Icons.calculate_outlined,
                    color: AppColors.primary,
                    onTap: _submit,
                  ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: widget.isLoading ? null : () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textTertiaryLight),
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
