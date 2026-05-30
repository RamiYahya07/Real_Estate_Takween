import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/projects/data/models/milestone_model.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/widgets/custom_button.dart';

class UpdateMilestoneStatusBottomSheet extends StatelessWidget {
  final MilestoneModel milestone;
  final bool isLandOwner;
  final bool isContractor;
  final Future<void> Function(String newStatus) onUpdate;

  const UpdateMilestoneStatusBottomSheet({
    super.key,
    required this.milestone,
    required this.isLandOwner,
    required this.isContractor,
    required this.onUpdate,
  });

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'VERIFIED':
        return AppColors.success;
      case 'COMPLETED':
        return AppColors.warning;
      case 'IN_PROGRESS':
        return AppColors.info;
      case 'PENDING':
      default:
        return AppColors.primaryMuted;
    }
  }

  List<_NextAction> _availableActions() {
    final s = milestone.status?.toUpperCase();
    final actions = <_NextAction>[];
    if (s == 'PENDING' && isContractor) {
      actions.add(_NextAction(
        label: 'Start',
        icon: Icons.play_arrow_outlined,
        nextStatus: 'IN_PROGRESS',
        color: AppColors.info,
      ));
    } else if (s == 'IN_PROGRESS' && isContractor) {
      actions.add(_NextAction(
        label: 'Mark Completed',
        icon: Icons.check_circle_outline,
        nextStatus: 'COMPLETED',
        color: AppColors.warning,
      ));
    } else if (s == 'COMPLETED' && isLandOwner) {
      actions.add(_NextAction(
        label: 'Verify',
        icon: Icons.verified_outlined,
        nextStatus: 'VERIFIED',
        color: AppColors.success,
      ));
    }
    return actions;
  }

  Future<void> _trigger(BuildContext context, String status) async {
    await onUpdate(status);
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(milestone.status??"");
    final actions = _availableActions();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20.h,
        left: 20.w,
        right: 20.w,
      ),
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
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: FaIcon(
                  FontAwesomeIcons.flag,
                  color: statusColor,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      milestone.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        milestone.status?.replaceAll('_', ' ') ?? '',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (milestone.description != null &&
              milestone.description!.isNotEmpty) ...[
            SizedBox(height: 14.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryContainerLight.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                milestone.description!,
                style: TextStyle(
                  fontSize: 12.sp,
                  height: 1.4,
                ),
              ),
            ),
          ],
          SizedBox(height: 20.h),
          if (actions.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.primaryContainerLight,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.circleInfo,
                    size: 14.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      milestone.status?.toUpperCase() == 'VERIFIED'
                          ? 'This milestone is fully verified.'
                          : 'No actions available for your role at this stage.',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            ...actions.map(
              (a) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: CustomButton(
                  title: a.label,
                  icon: a.icon,
                  color: a.color,
                  onTap: () => _trigger(context, a.nextStatus),
                ),
              ),
            ),
          SizedBox(height: 8.h),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: AppColors.textTertiaryLight),
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}

class _NextAction {
  final String label;
  final IconData icon;
  final String nextStatus;
  final Color color;

  _NextAction({
    required this.label,
    required this.icon,
    required this.nextStatus,
    required this.color,
  });
}
