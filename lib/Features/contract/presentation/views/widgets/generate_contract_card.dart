import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/widgets/custom_button.dart';

class GenerateContractCard extends StatelessWidget {
  final bool isLandOwner;
  final bool isGenerating;
  final VoidCallback onGenerate;

  const GenerateContractCard({
    super.key,
    required this.isLandOwner,
    required this.isGenerating,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(28.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: FaIcon(
                FontAwesomeIcons.fileContract,
                size: 56.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'No Contract Yet',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              isLandOwner
                  ? 'Generate the contract once all 2400 shares have been allocated.'
                  : 'Waiting for the land owner to generate the contract.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textTertiaryLight,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24.h),
            if (isLandOwner)
              isGenerating
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: const CircularProgressIndicator(),
                    )
                  : CustomButton(
                      title: 'Generate Contract',
                      icon: Icons.draw_outlined,
                      color: AppColors.primary,
                      onTap: onGenerate,
                    ),
          ],
        ),
      ),
    );
  }
}
