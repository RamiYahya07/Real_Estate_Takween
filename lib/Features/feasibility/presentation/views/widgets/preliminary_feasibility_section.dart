import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/feasibility/presentation/viewmodels/preliminary/preliminary_feasibility_cubit.dart';
import 'package:takween/Features/feasibility/presentation/viewmodels/preliminary/preliminary_feasibility_state.dart';
import 'package:takween/Features/feasibility/presentation/views/widgets/preliminary_feasibility_bottom_sheet.dart';
import 'package:takween/Features/feasibility/presentation/views/widgets/preliminary_feasibility_result_card.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/widgets/custom_button.dart';

class PreliminaryFeasibilitySection extends StatelessWidget {
  final String landPostId;

  const PreliminaryFeasibilitySection({super.key, required this.landPostId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<PreliminaryFeasibilityCubit>()..loadIdentity(),
      child: _PreliminaryFeasibilitySectionView(landPostId: landPostId),
    );
  }
}

class _PreliminaryFeasibilitySectionView extends StatelessWidget {
  final String landPostId;

  const _PreliminaryFeasibilitySectionView({required this.landPostId});

  void _openSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => BlocProvider.value(
        value: context.read<PreliminaryFeasibilityCubit>(),
        child: BlocBuilder<PreliminaryFeasibilityCubit,
            PreliminaryFeasibilityState>(
          builder: (innerCtx, s) {
            final loading = s is PreliminaryFeasibilityLoadingState;
            return PreliminaryFeasibilityBottomSheet(
              isLoading: loading,
              onSubmit: (price) async {
                await innerCtx
                    .read<PreliminaryFeasibilityCubit>()
                    .run(
                      landPostId: landPostId,
                      marketPricePerSqmUsd: price,
                    );
              },
            );
          },
        ),
      ),
    );
  }

  bool _isAllowed(PreliminaryFeasibilityState state) {
    if (state is PreliminaryFeasibilityInitialState) return state.isAllowed;
    if (state is PreliminaryFeasibilitySuccessState) return state.isAllowed;
    if (state is PreliminaryFeasibilityFailureState) return state.isAllowed;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PreliminaryFeasibilityCubit,
        PreliminaryFeasibilityState>(
      listener: (context, state) {
        if (state is PreliminaryFeasibilityFailureState) {
          context.showErrorSnackBar(state.message);
        }
      },
      buildWhen: (prev, curr) => curr is! PreliminaryFeasibilityFailureState,
      builder: (context, state) {
        final allowed = _isAllowed(state);
        if (!allowed) return const SizedBox.shrink();

        final isLoading = state is PreliminaryFeasibilityLoadingState;

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
                  'Preliminary Feasibility',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            if (state is PreliminaryFeasibilitySuccessState) ...[
              PreliminaryFeasibilityResultCard(result: state.result),
              SizedBox(height: 8.h),
            ],
            if (isLoading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: const Center(child: CircularProgressIndicator()),
              )
            else
              CustomButton(
                title: state is PreliminaryFeasibilitySuccessState
                    ? 'Recalculate'
                    : 'Run Quick Feasibility',
                icon: Icons.calculate_outlined,
                color: AppColors.primary,
                onTap: () => _openSheet(context),
              ),
          ],
        );
      },
    );
  }
}
