import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:takween/core/widgets/custom_text_form_field.dart';

class CreateShareListingBottomSheet extends StatefulWidget {
  final bool isCreating;
  final int maxAvailableShares;
  final Future<void> Function({
    required int shareCount,
    required double pricePerShareUsd,
  }) onSubmit;

  const CreateShareListingBottomSheet({
    super.key,
    required this.isCreating,
    required this.maxAvailableShares,
    required this.onSubmit,
  });

  @override
  State<CreateShareListingBottomSheet> createState() =>
      _CreateShareListingBottomSheetState();
}

class _CreateShareListingBottomSheetState
    extends State<CreateShareListingBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _shareCountController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _shareCountController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await widget.onSubmit(
      shareCount: int.parse(_shareCountController.text.trim()),
      pricePerShareUsd: double.parse(_priceController.text.trim()),
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
                    FontAwesomeIcons.handHoldingDollar,
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
                        'List Shares for Sale',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Set the number of shares and a price per share.',
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
              label: 'Number of shares',
              hintText: 'e.g. 100',
              keyboardType: TextInputType.number,
              controller: _shareCountController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Required';
                }
                final n = int.tryParse(value.trim());
                if (n == null || n <= 0) {
                  return 'Must be greater than 0';
                }
                if (widget.maxAvailableShares > 0 &&
                    n > widget.maxAvailableShares) {
                  return 'You can list up to ${widget.maxAvailableShares}';
                }
                return null;
              },
            ),
            CustomTextFormField(
              label: 'Price per share (USD)',
              hintText: 'e.g. 500',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
            widget.isCreating
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : CustomButton(
                    title: 'List Shares',
                    icon: Icons.sell_outlined,
                    color: AppColors.accent,
                    onTap: _submit,
                  ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: widget.isCreating
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
    );
  }
}
