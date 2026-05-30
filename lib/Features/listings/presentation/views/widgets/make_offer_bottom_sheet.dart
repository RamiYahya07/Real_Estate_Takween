import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:takween/core/widgets/custom_text_form_field.dart';

class MakeOfferBottomSheet extends StatefulWidget {
  final double listingPrice;
  final bool isSubmitting;
  final Future<void> Function({
    required double offerPriceUsd,
    String? message,
  }) onSubmit;

  const MakeOfferBottomSheet({
    super.key,
    required this.listingPrice,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  State<MakeOfferBottomSheet> createState() => _MakeOfferBottomSheetState();
}

class _MakeOfferBottomSheetState extends State<MakeOfferBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _priceController.text = widget.listingPrice.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _priceController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await widget.onSubmit(
      offerPriceUsd: double.parse(_priceController.text.trim()),
      message: _messageController.text.isEmpty
          ? null
          : _messageController.text.trim(),
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
                        'Make Offer',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Submit a purchase offer to the listing owner.',
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
              label: 'Offer price (USD)',
              hintText: 'e.g. 140000',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: _priceController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Required';
                final n = double.tryParse(value.trim());
                if (n == null || n <= 0) return 'Must be greater than 0';
                return null;
              },
            ),
            CustomTextFormField(
              label: 'Message (optional)',
              hintText: 'Anything you want the owner to know',
              maxLines: 3,
              controller: _messageController,
            ),
            SizedBox(height: 4.h),
            widget.isSubmitting
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : CustomButton(
                    title: 'Submit Offer',
                    icon: Icons.send_rounded,
                    color: AppColors.accent,
                    onTap: _submit,
                  ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: widget.isSubmitting
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
