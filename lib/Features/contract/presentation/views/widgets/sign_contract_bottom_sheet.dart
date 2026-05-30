import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:takween/core/widgets/custom_text_form_field.dart';

class SignContractBottomSheet extends StatefulWidget {
  final bool isSigning;
  final Future<void> Function(String passphrase) onSign;

  const SignContractBottomSheet({
    super.key,
    required this.isSigning,
    required this.onSign,
  });

  @override
  State<SignContractBottomSheet> createState() =>
      _SignContractBottomSheetState();
}

class _SignContractBottomSheetState extends State<SignContractBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await widget.onSign(_controller.text);
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
                    FontAwesomeIcons.signature,
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
                        'Sign Contract',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Use your signature passphrase to sign digitally.',
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
              label: 'Passphrase',
              hintText: 'Your signature passphrase',
              controller: _controller,
              obsecureText: true,
              prefixIcon: Icons.lock_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Passphrase is required';
                }
                return null;
              },
            ),
            SizedBox(height: 4.h),
            widget.isSigning
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : CustomButton(
                    title: 'Sign Now',
                    icon: Icons.draw_outlined,
                    color: AppColors.accent,
                    onTap: _submit,
                  ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: widget.isSigning ? null : () => Navigator.pop(context),
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
