import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/projects/data/models/milestone_model.dart';
import 'package:takween/Features/projects/data/models/project_model.dart';
import 'package:takween/Features/projects/presentation/viewmodels/milestones/milestones_cubit.dart';
import 'package:takween/Features/projects/presentation/viewmodels/milestones/milestones_state.dart';
import 'package:takween/Features/projects/presentation/views/widgets/add_milestone_bottom_sheet.dart';
import 'package:takween/Features/projects/presentation/views/widgets/milestone_tile.dart';
import 'package:takween/Features/projects/presentation/views/widgets/update_milestone_status_bottom_sheet.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/widgets/custom_button.dart';

class MilestonesSection extends StatelessWidget {
  final ProjectModel project;

  const MilestonesSection({super.key, required this.project});

  static const _activeStatuses = {
    'CONTRACT_SIGNED',
    'IN_PROGRESS',
    'INSPECTION',
    'COMPLETED',
  };

  static const _addAllowedStatuses = {
    'CONTRACT_SIGNED',
    'IN_PROGRESS',
  };

  @override
  Widget build(BuildContext context) {
    final status = project.status.toUpperCase();
    if (!_activeStatuses.contains(status)) return const SizedBox.shrink();

    return BlocProvider(
      create: (_) => sl<MilestonesCubit>()..load(project.id),
      child: _MilestonesSectionView(project: project),
    );
  }
}

class _MilestonesSectionView extends StatelessWidget {
  final ProjectModel project;

  const _MilestonesSectionView({required this.project});

  bool _isProjectContractor(MilestonesLoadedState state) {
    final me = state.currentUserId;
    if (me == null || !state.isContractor) return false;
    return project.shares.any(
      (s) => s.userId == me && s.role.toUpperCase() == 'CONTRACTOR',
    );
  }

  void _openAdd(BuildContext context, MilestonesLoadedState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => BlocProvider.value(
        value: context.read<MilestonesCubit>(),
        child: BlocBuilder<MilestonesCubit, MilestonesState>(
          builder: (innerCtx, s) {
            final adding = s is MilestonesLoadedState && s.isAdding;
            return AddMilestoneBottomSheet(
              isAdding: adding,
              onSubmit: ({required title, description}) async {
                await innerCtx.read<MilestonesCubit>().addMilestone(
                      projectId: project.id,
                      title: title,
                      description: description,
                    );
              },
            );
          },
        ),
      ),
    );
  }

  void _openUpdate(
    BuildContext context,
    MilestonesLoadedState state,
    MilestoneModel milestone,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => BlocProvider.value(
        value: context.read<MilestonesCubit>(),
        child: UpdateMilestoneStatusBottomSheet(
          milestone: milestone,
          isLandOwner: state.isLandOwner,
          isContractor: _isProjectContractor(state),
          onUpdate: (newStatus) async {
            await context.read<MilestonesCubit>().updateStatus(
                  projectId: project.id,
                  milestoneId: milestone.id,
                  newStatus: newStatus,
                );
          },
        ),
      ),
    );
  }

  bool _canTapTile(MilestoneModel m, MilestonesLoadedState state) {
    final isProjectContractor = _isProjectContractor(state);
    final s = m.status?.toUpperCase();
    if (s == 'PENDING' || s == 'IN_PROGRESS') return isProjectContractor;
    if (s == 'COMPLETED') return state.isLandOwner;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MilestonesCubit, MilestonesState>(
      listener: (context, state) {
        if (state is MilestonesTransientError) {
          context.showErrorSnackBar(state.message);
        }
      },
      buildWhen: (prev, curr) => curr is! MilestonesTransientError,
      builder: (context, state) {
        if (state is MilestonesInitialState ||
            state is MilestonesLoadingState) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 18.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is MilestonesFailureState) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.triangleExclamation,
                  size: 14.sp,
                  color: AppColors.error,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.error,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      context.read<MilestonesCubit>().load(project.id),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is MilestonesLoadedState) {
          final canAdd =
              _isProjectContractor(state) &&
              MilestonesSection._addAllowedStatuses.contains(
                project.status.toUpperCase(),
              );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 18.h),
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.flagCheckered,
                    size: 14.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Milestones (${state.milestones.length})',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              if (state.milestones.isEmpty)
                _EmptyMilestones(canAdd: canAdd)
              else
                ...state.milestones.map(
                  (m) => MilestoneTile(
                    milestone: m,
                    isUpdating: state.updatingId == m.id,
                    onTap: _canTapTile(m, state)
                        ? () => _openUpdate(context, state, m)
                        : null,
                  ),
                ),
              if (canAdd) ...[
                SizedBox(height: 10.h),
                CustomButton(
                  title: 'Add Milestone',
                  icon: Icons.add,
                  color: AppColors.primary,
                  onTap: () => _openAdd(context, state),
                ),
              ],
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _EmptyMilestones extends StatelessWidget {
  final bool canAdd;

  const _EmptyMilestones({required this.canAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryContainerLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.borderLight.withValues(alpha: 0.6),
        ),
      ),
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.flagCheckered,
            size: 16.sp,
            color: AppColors.primaryMuted,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              canAdd
                  ? 'No milestones yet. Add the first to start construction.'
                  : 'No milestones yet.',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.primaryMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
