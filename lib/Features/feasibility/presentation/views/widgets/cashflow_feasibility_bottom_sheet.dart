import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:takween/core/widgets/custom_text_form_field.dart';

class CashflowFeasibilityBottomSheet extends StatefulWidget {
  final bool isRunning;

  final Future<void> Function({
    required double marketPricePerSqmUsd,
    required double preSalePercent,
    required double constructionPaymentFrontLoadPercent,
  })
  onSubmit;

  const CashflowFeasibilityBottomSheet({
    super.key,
    required this.isRunning,
    required this.onSubmit,
  });

  @override
  State<CashflowFeasibilityBottomSheet> createState() =>
      _CashflowFeasibilityBottomSheetState();
}

class _CashflowFeasibilityBottomSheetState
    extends State<CashflowFeasibilityBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _marketPrice = TextEditingController();
  final _preSale = TextEditingController(text: '30');
  final _frontLoad = TextEditingController(text: '40');

  @override
  void dispose() {
    _marketPrice.dispose();
    _preSale.dispose();
    _frontLoad.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await widget.onSubmit(
      marketPricePerSqmUsd: double.parse(_marketPrice.text),
      preSalePercent: double.parse(_preSale.text),
      constructionPaymentFrontLoadPercent: double.parse(_frontLoad.text),
    );

    if (mounted) Navigator.pop(context);
  }

  String? _validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }

    if (double.tryParse(value) == null) {
      return 'Invalid number';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                label: 'Market Price Per Sqm',
                controller: _marketPrice,
                validator: _validator,
                hintText: 'e.g. 1000',
              ),

              CustomTextFormField(
                label: 'Pre Sale Percent',
                controller: _preSale,
                validator: _validator,
                hintText: 'e.g. 30',
              ),

              CustomTextFormField(
                label: 'Construction Payment Front Load %',
                controller: _frontLoad,
                validator: _validator,
                hintText: 'e.g. 40',
              ),

              SizedBox(height: 16.h),

              CustomButton(
                title: 'Run Cashflow',
                icon: Icons.timeline,
                color: AppColors.primary,
                onTap: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
