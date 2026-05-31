import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:takween/Features/projects/data/models/project_model.dart';
import 'package:takween/Features/projects/presentation/viewmodels/get_project_details/get_project_details_cubit.dart';
import 'package:takween/Features/projects/presentation/viewmodels/get_project_details/get_project_details_state.dart';
import 'package:takween/Features/feasibility/presentation/views/widgets/project_feasibility_section.dart';
import 'package:takween/Features/investments/presentation/views/widgets/investor_requests_section.dart';
import 'package:takween/Features/listings/presentation/views/widgets/create_listing_section.dart';
import 'package:takween/Features/projects/presentation/views/widgets/expenses_section.dart';
import 'package:takween/Features/projects/presentation/views/widgets/milestones_section.dart';
import 'package:takween/Features/projects/presentation/views/widgets/pending_payment_section.dart';
import 'package:takween/Features/projects/presentation/views/widgets/share_allocation_tile.dart';
import 'package:takween/Features/projects/presentation/views/widgets/share_listings_section.dart';
import 'package:takween/Features/projects/presentation/views/widgets/units_section.dart';
import 'package:takween/core/data/secure_storage_service.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/router/routes.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/widgets/custom_button.dart';

class ProjectDetailsViewBody extends StatelessWidget {
  final String projectId;
  final String projectTitle;

  const ProjectDetailsViewBody({
    super.key,
    required this.projectId,
    required this.projectTitle,
  });
  Future<String?> _getRole() {
    final storage = sl<SecureStorageService>();
    return storage.getRole();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getRole(),
      builder: (context, roleSnapshot) {
        final role = roleSnapshot.data;

        return BlocBuilder<GetProjectDetailsCubit, GetProjectDetailsState>(
          builder: (context, state) {
            if (state is GetProjectDetailsLoadingState ||
                state is GetProjectDetailsInitialState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GetProjectDetailsFailureState) {
              return _ErrorView(
                message: state.message,
                onRetry: () =>
                    context.read<GetProjectDetailsCubit>().load(projectId),
              );
            }

            if (state is GetProjectDetailsSuccessState) {
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<GetProjectDetailsCubit>().refresh(projectId),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                  children: [
                    _HeaderCard(project: state.project, title: projectTitle),
                    SizedBox(height: 14.h),
                    _ActionButtons(
                      projectId: projectId,
                      projectTitle: projectTitle,
                    ),
                    SizedBox(height: 18.h),
                    PendingPaymentSection(project: state.project),
                    _SectionHeader(
                      icon: FontAwesomeIcons.handshake,
                      title: 'Parties',
                    ),
                    SizedBox(height: 8.h),
                    _PartiesCard(project: state.project),
                    SizedBox(height: 18.h),
                    _SectionHeader(
                      icon: FontAwesomeIcons.chartPie,
                      title:
                          'Share Allocations (${state.project.shares.length})',
                    ),
                    SizedBox(height: 8.h),
                    if (state.project.shares.isEmpty)
                      _EmptyShares(totalShares: state.project.totalShares)
                    else
                      ...state.project.shares.map(
                        (sa) => ShareAllocationTile(allocation: sa),
                      ),
                    InvestorRequestsSection(project: state.project),
                    if (role != 'Buyer')
                      MilestonesSection(project: state.project),
                    if (role != 'Buyer')
                      ExpensesSection(project: state.project),
                    UnitsSection(project: state.project),
                    ShareListingsSection(project: state.project),
                    CreateListingSection(project: state.project),
                    ProjectFeasibilitySection(project: state.project),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final ProjectModel project;
  final String title;

  const _HeaderCard({required this.project, required this.title});

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

    return Container(
      padding: EdgeInsets.all(16.w),
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
                  size: 18.sp,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title.isEmpty ? 'Project' : title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  project.status.replaceAll('_', ' '),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _MetaChip(
                  icon: FontAwesomeIcons.handshake,
                  label: 'Investment',
                  value: project.investmentType.replaceAll('_', ' '),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _MetaChip(
                  icon: FontAwesomeIcons.building,
                  label: 'Building',
                  value: project.buildingType.replaceAll('_', ' '),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _MetaChip(
                  icon: FontAwesomeIcons.layerGroup,
                  label: 'Total Shares',
                  value: project.totalShares.toString(),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _MetaChip(
                  icon: FontAwesomeIcons.calendar,
                  label: 'Created',
                  value: project.createdAt.toLocal().formattedDate,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final String projectId;
  final String projectTitle;

  const _ActionButtons({required this.projectId, required this.projectTitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            title: 'Open Chat',
            icon: Icons.chat_bubble_outline,
            color: AppColors.primary,
            onTap: () => context.push(
              Routes.chat,
              extra: {'projectId': projectId, 'projectTitle': projectTitle},
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: CustomButton(
            title: 'Contract',
            icon: Icons.description_outlined,
            color: AppColors.accent,
            onTap: () => context.push(
              Routes.contract,
              extra: {'projectId': projectId, 'projectTitle': projectTitle},
            ),
          ),
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final String value;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.primaryContainerLight.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          FaIcon(icon, size: 14.sp, color: AppColors.primary),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textTertiaryLight,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PartiesCard extends StatelessWidget {
  final ProjectModel project;

  const _PartiesCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          _PartyRow(
            icon: FontAwesomeIcons.userTie,
            label: 'Land Owner',
            name: project.landOwnerName,
          ),
          Divider(height: 18.h, color: theme.dividerColor),
          _PartyRow(
            icon: FontAwesomeIcons.helmetSafety,
            label: 'Contractor',
            name: project.contractorName,
          ),
        ],
      ),
    );
  }
}

class _PartyRow extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final String name;

  const _PartyRow({
    required this.icon,
    required this.label,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: FaIcon(icon, size: 14.sp, color: AppColors.primary),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.textTertiaryLight,
                ),
              ),
              Text(
                name.isEmpty ? '—' : name,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final FaIconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(icon, size: 14.sp, color: AppColors.primary),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _EmptyShares extends StatelessWidget {
  final int totalShares;

  const _EmptyShares({required this.totalShares});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.circleInfo,
            size: 16.sp,
            color: AppColors.warning,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'No shares allocated yet (out of $totalShares).',
              style: TextStyle(fontSize: 12.sp, color: AppColors.warning),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 40.sp,
              color: AppColors.error,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp),
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
