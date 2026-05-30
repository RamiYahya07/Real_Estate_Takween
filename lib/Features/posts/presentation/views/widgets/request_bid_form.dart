import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takween/Features/bid/presentation/viewmodels/request_bid/request_bid_cubit.dart';
import 'package:takween/Features/bid/presentation/viewmodels/request_bid/request_bid_state.dart';
import 'package:takween/core/utils/constants.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:takween/core/widgets/custom_dropdown_form_field.dart';
import 'package:takween/core/widgets/custom_text_form_field.dart';

class RequestBidForm extends StatefulWidget {
  final InvestmentType type;
  final dynamic post;

  const RequestBidForm({super.key, required this.type, required this.post});

  @override
  State<RequestBidForm> createState() => _RequestBidFormState();
}

class _RequestBidFormState extends State<RequestBidForm> {
  // ================= CONTROLLERS =================

  final offerPriceController = TextEditingController();
  final contractorShareController = TextEditingController();
  final landOwnerShareController = TextEditingController();
  final costController = TextEditingController();
  final floorsController = TextEditingController();
  final monthsController = TextEditingController();
  final notesController = TextEditingController();
  final approachController = TextEditingController();

  String? finishTier;

  final List<String> finishOptions = ['STANDARD', 'MID_RANGE', 'LUXURY'];

  // ================= DISPOSE =================

  @override
  void dispose() {
    offerPriceController.dispose();
    contractorShareController.dispose();
    landOwnerShareController.dispose();
    costController.dispose();
    floorsController.dispose();
    monthsController.dispose();
    notesController.dispose();
    approachController.dispose();

    super.dispose();
  }

  // ================= HELPERS =================

  Widget _numberField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: CustomTextFormField(
        label: label,
        hintText: hint,
        keyboardType: TextInputType.number,
        controller: controller,
      ),
    );
  }

  Widget _textField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: CustomTextFormField(
        label: label,
        hintText: hint,
        controller: controller,
        maxLines: maxLines,
      ),
    );
  }

  Widget _finishTierField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: CustomDropdownFormField<String>(
        label: "Finish Tier",
        hintText: "Select finish tier",
        value: finishTier,
        items: finishOptions
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (value) {
          setState(() {
            finishTier = value;
          });
        },
      ),
    );
  }

  // ================= VALIDATION =================

  bool _validate() {
    switch (widget.type) {
      case InvestmentType.directSale:
        return offerPriceController.text.isNotEmpty;

      case InvestmentType.shareOffering:
        return offerPriceController.text.isNotEmpty;

      case InvestmentType.muqasama:
        return landOwnerShareController.text.isNotEmpty &&
            costController.text.isNotEmpty &&
            monthsController.text.isNotEmpty &&
            floorsController.text.isNotEmpty &&
            finishTier != null &&
            approachController.text.isNotEmpty;

      case InvestmentType.jointInvestment:
        return contractorShareController.text.isNotEmpty &&
            landOwnerShareController.text.isNotEmpty &&
            costController.text.isNotEmpty &&
            monthsController.text.isNotEmpty &&
            floorsController.text.isNotEmpty &&
            finishTier != null &&
            approachController.text.isNotEmpty;
    }
  }

  // ================= SUBMIT =================

  void _submit() {
    if (!_validate()) {
      context.showErrorSnackBar("Please fill all required fields");
      return;
    }

    context.read<RequestBidCubit>().requestBid(
      type: widget.type,
      landPostId: widget.post.id,

      // prices
      offerPriceUsd: double.tryParse(offerPriceController.text.trim()),

      // shares
      contractorSharePercent: double.tryParse(
        contractorShareController.text.trim(),
      ),

      landownerSharePercent: double.tryParse(
        landOwnerShareController.text.trim(),
      ),

      // construction
      estimatedConstructionCostUsd: double.tryParse(costController.text.trim()),

      estimatedTimelineMonths: int.tryParse(monthsController.text.trim()),

      proposedFloors: int.tryParse(floorsController.text.trim()),

      // text
      finishTier: finishTier,

      proposedApproach: approachController.text.trim().isEmpty
          ? null
          : approachController.text.trim(),

      notes: notesController.text.trim().isEmpty
          ? null
          : notesController.text.trim(),
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestBidCubit, RequestBidState>(
      listener: (context, state) {
        // ================= SUCCESS =================

        if (state is RequestBidSuccessState) {
          Navigator.pop(context);

          context.showSuccessSnackBar('Bid request submitted successfully');
        }

        // ================= FAILURE =================

        if (state is RequestBidFailureState) {
          Navigator.pop(context);

          context.showErrorSnackBar(state.message);
        }
      },

      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20.h,
            left: 16.w,
            right: 16.w,
          ),

          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.type.name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20.h),

                // =========================================================
                // DIRECT SALE
                // =========================================================
                if (widget.type == InvestmentType.directSale) ...[
                  _numberField(
                    label: "Offer Price",
                    hint: "Enter offer price",
                    controller: offerPriceController,
                  ),

                  _textField(
                    label: "Proposed Approach",
                    hint: "Describe your proposed approach",
                    controller: approachController,
                  ),
                ],

                // =========================================================
                // MUQASAMA
                // =========================================================
                if (widget.type == InvestmentType.muqasama) ...[
                  _finishTierField(),

                  _numberField(
                    label: "Land Share %",
                    hint: "Enter land share percentage",
                    controller: landOwnerShareController,
                  ),

                  _numberField(
                    label: "Estimated Cost",
                    hint: "Enter estimated construction cost",
                    controller: costController,
                  ),

                  _numberField(
                    label: "Timeline (Months)",
                    hint: "Enter estimated timeline",
                    controller: monthsController,
                  ),

                  _numberField(
                    label: "Proposed Floors",
                    hint: "Enter proposed floors",
                    controller: floorsController,
                  ),

                  _textField(
                    label: "Proposed Approach",
                    hint: "Describe your proposed approach",
                    controller: approachController,
                  ),
                ],

                // =========================================================
                // JOINT INVESTMENT
                // =========================================================
                if (widget.type == InvestmentType.jointInvestment) ...[
                  _finishTierField(),

                  _numberField(
                    label: "Contractor Share %",
                    hint: "Enter contractor share percentage",
                    controller: contractorShareController,
                  ),

                  _numberField(
                    label: "Land Owner Share %",
                    hint: "Enter land owner share percentage",
                    controller: landOwnerShareController,
                  ),

                  _numberField(
                    label: "Estimated Cost",
                    hint: "Enter estimated construction cost",
                    controller: costController,
                  ),

                  _numberField(
                    label: "Timeline (Months)",
                    hint: "Enter estimated timeline",
                    controller: monthsController,
                  ),

                  _numberField(
                    label: "Proposed Floors",
                    hint: "Enter proposed floors",
                    controller: floorsController,
                  ),

                  _textField(
                    label: "Proposed Approach",
                    hint: "Describe your proposed approach",
                    controller: approachController,
                  ),
                ],

                // =========================================================
                // SHARE OFFERING
                // =========================================================
                if (widget.type == InvestmentType.shareOffering) ...[
                  _numberField(
                    label: "Offer Price",
                    hint: "Enter offer price",
                    controller: offerPriceController,
                  ),
                ],

                // =========================================================
                // NOTES
                // =========================================================
                _textField(
                  label: "Notes",
                  hint: "Any additional notes or comments",
                  controller: notesController,
                  maxLines: 3,
                ),

                SizedBox(height: 20.h),

                // =========================================================
                // SUBMIT
                // =========================================================
                CustomButton(
                  title: state is RequestBidLoadingState
                      ? "Submitting..."
                      : "Submit Request",

                  icon: Icons.send_rounded,

                  onTap: () {
                    if (state is! RequestBidLoadingState) {
                      _submit();
                    }
                  },
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
