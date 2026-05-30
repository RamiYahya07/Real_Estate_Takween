import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takween/Features/investments/data/models/investment_opportunity_model.dart';
import 'package:takween/Features/investments/presentation/viewmodels/invest/invest_cubit.dart';
import 'package:takween/Features/investments/presentation/viewmodels/invest/invest_state.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:takween/core/widgets/custom_text_form_field.dart';

class SubmitInvestmentSheet extends StatefulWidget {
  final InvestmentOpportunityModel opportunity;
  const SubmitInvestmentSheet({super.key, required this.opportunity});

  @override
  State<SubmitInvestmentSheet> createState() => _SubmitInvestmentSheetState();
}

class _SubmitInvestmentSheetState extends State<SubmitInvestmentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_amountController.text.trim());
    final notes = _notesController.text.trim();
    context.read<InvestCubit>().submit(
          projectId: widget.opportunity.projectId,
          amount: amount,
          notes: notes.isEmpty ? null : notes,
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvestCubit, InvestState>(
      builder: (context, state) {
        final submitting = state is InvestLoaded && state.submitting;
        return Padding(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: 12.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColors.borderLight,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    widget.opportunity.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${widget.opportunity.city} • ${widget.opportunity.availableShares} shares available',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.primaryMuted,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  CustomTextFormField(
                    hintText: 'Amount (USD)',
                    label: 'Investment amount',
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Amount is required';
                      }
                      final n = double.tryParse(v.trim());
                      if (n == null || n <= 0) return 'Enter a valid amount';
                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),
                  CustomTextFormField(
                    hintText: 'Optional notes',
                    label: 'Notes',
                    controller: _notesController,
                    maxLines: 3,
                  ),
                  SizedBox(height: 18.h),
                  CustomButton(
                    title: submitting ? 'Submitting...' : 'Submit request',
                    color: AppColors.primary,
                    onTap: submitting ? () {} : _submit,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
