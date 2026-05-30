import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/projects/data/models/project_list_item_model.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';

class ProjectCard extends StatelessWidget {
  final ProjectListItemModel project;
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
  });

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return AppColors.success;
      case 'IN_PROGRESS':
      case 'PERMITS_OBTAINED':
      case 'CONTRACT_SIGNED':
        return AppColors.info;
      case 'BID_ACCEPTED':
      case 'INSPECTION':
      case 'HANDOVER':
        return AppColors.warning;
      case 'CANCELLED':
        return AppColors.error;
      default:
        return AppColors.primaryMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(project.status);

    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.buildingFlag,
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
                        project.title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.locationDot,
                            size: 10.sp,
                            color: AppColors.textTertiaryLight,
                          ),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: Text(
                              project.city,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.textTertiaryLight,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    project.status.replaceAll('_', ' '),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primaryContainerLight,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                project.investmentType.replaceAll('_', ' '),
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: _PartyChip(
                    icon: FontAwesomeIcons.userTie,
                    label: 'Owner',
                    name: project.landOwnerName,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _PartyChip(
                    icon: FontAwesomeIcons.helmetSafety,
                    label: 'Contractor',
                    name: project.contractorName,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.calendar,
                  size: 10.sp,
                  color: AppColors.textTertiaryLight,
                ),
                SizedBox(width: 6.w),
                Text(
                  project.createdAt.toLocal().formattedDate,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textTertiaryLight,
                  ),
                ),
                const Spacer(),
                FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 11.sp,
                  color: AppColors.primaryMuted,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PartyChip extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final String name;

  const _PartyChip({
    required this.icon,
    required this.label,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(icon, size: 11.sp, color: AppColors.primary),
        SizedBox(width: 6.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: AppColors.textTertiaryLight,
                ),
              ),
              Text(
                name.isEmpty ? '—' : name,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
