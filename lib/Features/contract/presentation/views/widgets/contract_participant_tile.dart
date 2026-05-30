import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/contract/data/models/contract_participant_model.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';

class ContractParticipantTile extends StatelessWidget {
  final ContractParticipantModel participant;
  final bool isCurrentUser;

  const ContractParticipantTile({
    super.key,
    required this.participant,
    required this.isCurrentUser,
  });

  String _displayName() {
    final full = participant.fullName?.trim();
    if (full != null && full.isNotEmpty) return full;
    return participant.name;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = _displayName();
    final initial = name.isEmpty ? '?' : name[0].toUpperCase();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isCurrentUser
              ? AppColors.accent
              : theme.dividerColor.withValues(alpha: 0.5),
          width: isCurrentUser ? 1.4 : 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: Text(
              initial,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'You',
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainerLight,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        participant.role.replaceAll('_', ' '),
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '${participant.shares} shares • ${participant.percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textTertiaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FaIcon(
                participant.hasSigned
                    ? FontAwesomeIcons.circleCheck
                    : FontAwesomeIcons.hourglassHalf,
                color: participant.hasSigned
                    ? AppColors.success
                    : AppColors.warning,
                size: 18.sp,
              ),
              SizedBox(height: 4.h),
              Text(
                participant.hasSigned
                    ? (participant.signedAt?.toLocal().formattedDate ??
                        'Signed')
                    : 'Pending',
                style: TextStyle(
                  fontSize: 9.sp,
                  color: participant.hasSigned
                      ? AppColors.success
                      : AppColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
