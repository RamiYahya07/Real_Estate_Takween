import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/feasibility/presentation/viewmodels/project_feasibility/project_feasibility_cubit.dart';
import 'package:takween/Features/feasibility/presentation/viewmodels/project_feasibility/project_feasibility_state.dart';
import 'package:takween/Features/feasibility/presentation/views/widgets/cashflow_feasibility_bottom_sheet.dart';
import 'package:takween/Features/feasibility/presentation/views/widgets/cashflow_result_card.dart';
import 'package:takween/Features/feasibility/presentation/views/widgets/detailed_feasibility_bottom_sheet.dart';
import 'package:takween/Features/feasibility/presentation/views/widgets/detailed_feasibility_result_card.dart';
import 'package:takween/Features/projects/data/models/project_model.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/widgets/custom_button.dart';

class ProjectFeasibilitySection extends StatelessWidget {
  final ProjectModel project;

  const ProjectFeasibilitySection({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProjectFeasibilityCubit>()..init(),
      child: _ProjectFeasibilitySectionView(project: project),
    );
  }
}

class _ProjectFeasibilitySectionView extends StatelessWidget {
  final ProjectModel project;

  const _ProjectFeasibilitySectionView({required this.project});

  void _openDetailed(
    BuildContext context,
    ProjectFeasibilityLoadedState state,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<ProjectFeasibilityCubit>(),
        child: BlocBuilder<ProjectFeasibilityCubit, ProjectFeasibilityState>(
          builder: (innerCtx, state) {
            final running =
                state is ProjectFeasibilityLoadedState &&
                state.isRunningDetailed;

            return DetailedFeasibilityBottomSheet(
              isRunning: running,
              onSubmit:
                  ({
                    required marketPricePerSqmUsd,
                    required sellingExpensePercent,
                    required discountRatePercent,
                    monthlyRentPerSqmUsd,
                    required annualMaintenancePercent,
                    required vacancyRatePercent,
                  }) async {
                    await innerCtx.read<ProjectFeasibilityCubit>().runDetailed(
                      projectId: project.id,
                      marketPricePerSqmUsd: marketPricePerSqmUsd,
                      sellingExpensePercent: sellingExpensePercent,
                      discountRatePercent: discountRatePercent,
                      monthlyRentPerSqmUsd: monthlyRentPerSqmUsd,
                      annualMaintenancePercent: annualMaintenancePercent,
                      vacancyRatePercent: vacancyRatePercent,
                    );
                  },
            );
          },
        ),
      ),
    );
  }

  void _openCashflow(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<ProjectFeasibilityCubit>(),
        child: BlocBuilder<ProjectFeasibilityCubit, ProjectFeasibilityState>(
          builder: (innerCtx, state) {
            final running =
                state is ProjectFeasibilityLoadedState &&
                state.isRunningCashflow;

            return CashflowFeasibilityBottomSheet(
              isRunning: running,
              onSubmit:
                  ({
                    required marketPricePerSqmUsd,
                    required preSalePercent,
                    required constructionPaymentFrontLoadPercent,
                  }) async {
                    await innerCtx.read<ProjectFeasibilityCubit>().runCashflow(
                      projectId: project.id,
                      marketPricePerSqmUsd: marketPricePerSqmUsd,
                      preSalePercent: preSalePercent,
                      constructionPaymentFrontLoadPercent:
                          constructionPaymentFrontLoadPercent,
                    );
                  },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectFeasibilityCubit, ProjectFeasibilityState>(
      listener: (context, state) {
        if (state is ProjectFeasibilityTransientError) {
          context.showErrorSnackBar(state.message);
        }
      },
      buildWhen: (prev, curr) => curr is! ProjectFeasibilityTransientError,
      builder: (context, state) {
        if (state is! ProjectFeasibilityLoadedState) {
          return const SizedBox.shrink();
        }

        if (!state.isAllowed) {  
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 18.h),

            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.calculator,
                  size: 14.sp,
                  color: AppColors.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Feasibility',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.h),

            if (state.detailed != null) ...[
              DetailedFeasibilityResultCard(result: state.detailed!),
              SizedBox(height: 10.h),
            ],

            if (state.cashflow != null) ...[
              CashflowResultCard(result: state.cashflow!),
              SizedBox(height: 10.h),
            ],

            Row(
              children: [
                Expanded(
                  child: state.isRunningDetailed
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          title: state.detailed != null
                              ? 'Re-run Detailed'
                              : 'Detailed',
                          icon: Icons.calculate_outlined,
                          color: AppColors.accent,
                          onTap: () => _openDetailed(context, state),
                        ),
                ),

                SizedBox(width: 10.w),

                Expanded(
                  child: state.isRunningCashflow
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          title: state.cashflow != null
                              ? 'Recashflow'
                              : 'Cashflow',
                          icon: Icons.timeline,
                          color: AppColors.primary,
                          onTap: () => _openCashflow(context),
                        ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
