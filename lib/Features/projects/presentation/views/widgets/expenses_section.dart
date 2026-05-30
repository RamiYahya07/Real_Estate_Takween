import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/projects/data/models/project_model.dart';
import 'package:takween/Features/projects/presentation/viewmodels/expenses/expenses_cubit.dart';
import 'package:takween/Features/projects/presentation/viewmodels/expenses/expenses_state.dart';
import 'package:takween/Features/projects/presentation/views/widgets/add_expense_bottom_sheet.dart';
import 'package:takween/Features/projects/presentation/views/widgets/expense_tile.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/widgets/custom_button.dart';

class ExpensesSection extends StatelessWidget {
  final ProjectModel project;

  const ExpensesSection({super.key, required this.project});

  static const _activeStatuses = {
    'CONTRACT_SIGNED',
    'IN_PROGRESS',
    'INSPECTION',
    'COMPLETED',
  };

  @override
  Widget build(BuildContext context) {
    final status = project.status.toUpperCase();
    if (!_activeStatuses.contains(status)) return const SizedBox.shrink();

    return BlocProvider(
      create: (_) => sl<ExpensesCubit>()..load(project.id),
      child: _ExpensesSectionView(project: project),
    );
  }
}

class _ExpensesSectionView extends StatelessWidget {
  final ProjectModel project;

  const _ExpensesSectionView({required this.project});

  bool _isProjectContractor(ExpensesLoadedState state) {
    final me = state.currentUserId;
    if (me == null || !state.isContractor) return false;
    return project.shares.any(
      (s) => s.userId == me && s.role.toUpperCase() == 'CONTRACTOR',
    );
  }

  void _openAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => BlocProvider.value(
        value: context.read<ExpensesCubit>(),
        child: BlocBuilder<ExpensesCubit, ExpensesState>(
          builder: (innerCtx, s) {
            final adding = s is ExpensesLoadedState && s.isAdding;
            return AddExpenseBottomSheet(
              isAdding: adding,
              onSubmit: ({
                required category,
                required description,
                required amountUsd,
                required paidAt,
              }) async {
                await innerCtx.read<ExpensesCubit>().addExpense(
                      projectId: project.id,
                      category: category,
                      description: description,
                      amountUsd: amountUsd,
                      paidAt: paidAt,
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
    return BlocConsumer<ExpensesCubit, ExpensesState>(
      listener: (context, state) {
        if (state is ExpensesTransientError) {
          context.showErrorSnackBar(state.message);
        }
      },
      buildWhen: (prev, curr) => curr is! ExpensesTransientError,
      builder: (context, state) {
        if (state is ExpensesInitialState || state is ExpensesLoadingState) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 18.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ExpensesFailureState) {
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
                      context.read<ExpensesCubit>().load(project.id),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is ExpensesLoadedState) {
          final canAdd = _isProjectContractor(state);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 18.h),
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.receipt,
                    size: 14.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Expenses (${state.expenses.length})',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  if (state.expenses.isNotEmpty)
                    Text(
                      state.totalUsd.toCurrency(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              if (state.expenses.isEmpty)
                _EmptyExpenses(canAdd: canAdd)
              else
                ...state.expenses.map((e) => ExpenseTile(expense: e)),
              if (canAdd) ...[
                SizedBox(height: 10.h),
                CustomButton(
                  title: 'Log Expense',
                  icon: Icons.add,
                  color: AppColors.primary,
                  onTap: () => _openAdd(context),
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

class _EmptyExpenses extends StatelessWidget {
  final bool canAdd;

  const _EmptyExpenses({required this.canAdd});

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
            FontAwesomeIcons.receipt,
            size: 16.sp,
            color: AppColors.primaryMuted,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              canAdd
                  ? 'No expenses yet. Log construction costs as you go.'
                  : 'No expenses logged yet.',
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
