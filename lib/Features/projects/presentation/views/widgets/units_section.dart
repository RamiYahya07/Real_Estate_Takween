import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/projects/data/models/allocation_result_model.dart';
import 'package:takween/Features/projects/data/models/project_model.dart';
import 'package:takween/Features/projects/presentation/viewmodels/units/units_cubit.dart';
import 'package:takween/Features/projects/presentation/viewmodels/units/units_state.dart';
import 'package:takween/Features/projects/presentation/views/widgets/create_units_bottom_sheet.dart';
import 'package:takween/Features/projects/presentation/views/widgets/unit_tile.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/widgets/custom_button.dart';

class UnitsSection extends StatelessWidget {
  final ProjectModel project;

  const UnitsSection({super.key, required this.project});

  static const _activeStatuses = {
    'IN_PROGRESS',
    'INSPECTION',
    'COMPLETED',
  };

  static const _createAllowedStatuses = {
    'IN_PROGRESS',
    'INSPECTION',
  };

  static const _allocateAllowedStatuses = {
    'IN_PROGRESS',
    'INSPECTION',
  };

  @override
  Widget build(BuildContext context) {
    final status = project.status.toUpperCase();
    if (!_activeStatuses.contains(status)) return const SizedBox.shrink();

    return BlocProvider(
      create: (_) => sl<UnitsCubit>()..load(project.id),
      child: _UnitsSectionView(project: project),
    );
  }
}

class _UnitsSectionView extends StatelessWidget {
  final ProjectModel project;

  const _UnitsSectionView({required this.project});

  bool _isProjectContractor(UnitsLoadedState state) {
    final me = state.currentUserId;
    if (me == null || !state.isContractor) return false;
    return project.shares.any(
      (s) => s.userId == me && s.role.toUpperCase() == 'CONTRACTOR',
    );
  }

  bool _isProjectLandOwner(UnitsLoadedState state) {
    final me = state.currentUserId;
    if (me == null || !state.isLandOwner) return false;
    return project.shares.any(
      (s) => s.userId == me && s.role.toUpperCase() == 'LANDOWNER',
    );
  }

  void _openCreate(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => BlocProvider.value(
        value: context.read<UnitsCubit>(),
        child: BlocBuilder<UnitsCubit, UnitsState>(
          builder: (innerCtx, s) {
            final creating = s is UnitsLoadedState && s.isCreating;
            return CreateUnitsBottomSheet(
              isCreating: creating,
              onSubmit: (units) async {
                await innerCtx.read<UnitsCubit>().createUnits(
                      projectId: project.id,
                      units: units,
                    );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmAllocate(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Allocate Units'),
        content: const Text(
          'This will distribute all available units to shareholders by share '
          'percentage and advance the project to COMPLETED. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Allocate'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<UnitsCubit>().allocate(project.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UnitsCubit, UnitsState>(
      listener: (context, state) {
        if (state is UnitsTransientError) {
          context.showErrorSnackBar(state.message);
        }
        if (state is UnitsAllocationSuccess) {
          context.showSuccessSnackBar(
            'Allocated ${state.result.allocatedUnits} of ${state.result.totalUnits} units',
          );
        }
      },
      buildWhen: (prev, curr) =>
          curr is! UnitsTransientError && curr is! UnitsAllocationSuccess,
      builder: (context, state) {
        if (state is UnitsInitialState || state is UnitsLoadingState) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 18.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is UnitsFailureState) {
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
                      context.read<UnitsCubit>().load(project.id),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is UnitsLoadedState) {
          final isProjectContractor = _isProjectContractor(state);
          final isProjectLandOwner = _isProjectLandOwner(state);
          final canManage = isProjectContractor || isProjectLandOwner;
          final canCreate = canManage &&
              state.units.isEmpty &&
              UnitsSection._createAllowedStatuses.contains(
                project.status.toUpperCase(),
              );
          final hasAvailable =
              state.units.any((u) => u.status.toUpperCase() == 'AVAILABLE');
          final canAllocate = canManage &&
              state.units.isNotEmpty &&
              hasAvailable &&
              UnitsSection._allocateAllowedStatuses.contains(
                project.status.toUpperCase(),
              );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 18.h),
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.buildingUser,
                    size: 14.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Units (${state.units.length})',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              if (state.units.isEmpty)
                _EmptyUnits(canCreate: canCreate)
              else
                ...state.units.map((u) => UnitTile(unit: u)),
              if (canCreate) ...[
                SizedBox(height: 10.h),
                CustomButton(
                  title: 'Create Units',
                  icon: Icons.add_business_outlined,
                  color: AppColors.primary,
                  onTap: () => _openCreate(context),
                ),
              ],
              if (canAllocate && !state.isAllocating) ...[
                SizedBox(height: 10.h),
                CustomButton(
                  title: 'Allocate Units',
                  icon: Icons.shuffle_outlined,
                  color: AppColors.accent,
                  onTap: () => _confirmAllocate(context),
                ),
              ],
              if (state.isAllocating) ...[
                SizedBox(height: 10.h),
                const Center(child: CircularProgressIndicator()),
              ],
              if (state.lastAllocation != null) ...[
                SizedBox(height: 14.h),
                _AllocationResultPanel(result: state.lastAllocation!),
              ],
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _EmptyUnits extends StatelessWidget {
  final bool canCreate;

  const _EmptyUnits({required this.canCreate});

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
            FontAwesomeIcons.buildingUser,
            size: 16.sp,
            color: AppColors.primaryMuted,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              canCreate
                  ? 'No units yet. Create them to enable allocation.'
                  : 'No units yet.',
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

class _AllocationResultPanel extends StatelessWidget {
  final AllocationResultModel result;

  const _AllocationResultPanel({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.circleCheck,
                size: 14.sp,
                color: AppColors.success,
              ),
              SizedBox(width: 8.w),
              Text(
                'Allocation result',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
              const Spacer(),
              Text(
                '${result.allocatedUnits} / ${result.totalUnits}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          for (final s in result.shareholders) ...[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.userName.isEmpty ? '—' : s.userName,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${s.shares} shares • ${s.percentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textTertiaryLight,
                          ),
                        ),
                        if (s.assignedUnits.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Text(
                              'Units: ${s.assignedUnits.join(', ')}',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '${s.entitledUnits} unit(s)',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
