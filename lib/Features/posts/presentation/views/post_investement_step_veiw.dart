import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:takween/Features/posts/presentation/viewmodels/create_land_post/create_land_post_cubit.dart';
import 'package:takween/Features/posts/presentation/viewmodels/create_land_post/create_land_post_state.dart';
import 'package:takween/core/router/routes.dart';
import 'package:takween/core/utils/app_strings.dart';
import 'package:takween/core/utils/constants.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/utils/validators.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:takween/core/widgets/custom_dropdown_form_field.dart';
import 'package:takween/core/widgets/custom_switch_tile.dart';
import 'package:takween/core/widgets/custom_text_form_field.dart';

class PostInvestmentStepView extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const PostInvestmentStepView({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<PostInvestmentStepView> createState() => _PostInvestmentStepViewState();
}

class _PostInvestmentStepViewState extends State<PostInvestmentStepView> {
  double? priceUsd;
  int? maxAcceptedBids;
  String? specialRequirements;

  int? investmentType;

  bool isAuction = false;
  bool allowInvestors = false;
  bool isRepresentative = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return BlocConsumer<CreateLandPostCubit, CreateLandPostState>(
      listener: (context, state) {
        if (state.status == CreatePostStatus.loading) {
          context.showLoading();
        }
        if (state.status == CreatePostStatus.failure) {
          context.hideLoading();
          context.showErrorSnackBar(state.errorMessage ?? 'Error');
        }

        if (state.status == CreatePostStatus.draftCreated) {
          context.hideLoading();
          context.showSuccessSnackBar('Draft created successfully');
          context.go(Routes.landOwnerHome);
        }
      },
      builder: (context, state) {
        final cubit = context.read<CreateLandPostCubit>();
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: widget.onBack,
                    ),

                    Expanded(
                      child: Text(
                        "Step 3: Investment & Terms",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    _stepBadge("3 of 4"),
                  ],
                ),

                const SizedBox(height: 16),

                StepProgressIndicator(
                  totalSteps: 4,
                  currentStep: 3,
                  size: 8,
                  roundedEdges: const Radius.circular(10),
                  selectedColor: theme.colorScheme.secondary,
                  unselectedColor: theme.dividerColor,
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: ListView(
                    children: [
                      /// Investment Type
                      CustomDropdownFormField<String>(
                        hintText: 'Select Investment Type',
                        label: "Investment Type",
                        value:
                            investmentTypeMap.entries
                                .firstWhere(
                                  (e) => e.value == investmentType,
                                  orElse: () => const MapEntry("", 0),
                                )
                                .key
                                .isEmpty
                            ? null
                            : investmentTypeMap.entries
                                  .firstWhere((e) => e.value == investmentType)
                                  .key,

                        items: investmentTypeMap.keys
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),

                        onChanged: (v) {
                          setState(() {
                            investmentType = investmentTypeMap[v];
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      /// Asking Price
                      CustomTextFormField(
                        validator: (value) => Validators.required(
                          value,
                          fieldName: AppStrings.price,
                        ),
                        hintText: 'e.g. 150000',
                        label: "Price",
                        onChanged: (v) {
                          priceUsd = double.tryParse(v ?? '');
                        },
                      ),

                      const SizedBox(height: 16),

                      /// Max Bids
                      CustomTextFormField(
                        hintText: 'e.g. 10',
                        label: "Max Accepted Bids",
                        onChanged: (v) {
                          maxAcceptedBids = int.tryParse(v ?? '');
                        },
                        validator: (value) => Validators.required(
                          value,
                          fieldName: AppStrings.maxAcceptedBids,
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// Switches
                      CustomSwitchTile(
                        title: "Is Sealed Auction?",
                        subtitle: "Bids are hidden for participants",
                        value: isAuction,
                        onChanged: (v) => setState(() => isAuction = v),
                      ),

                      CustomSwitchTile(
                        title: "Accept Additional Investors?",
                        subtitle: "Allow others to join equity partners",
                        value: allowInvestors,
                        onChanged: (v) => setState(() => allowInvestors = v),
                      ),

                      CustomSwitchTile(
                        title: "Is Representative?",
                        subtitle: "You are listing on behalf of owner",
                        value: isRepresentative,
                        onChanged: (v) => setState(() => isRepresentative = v),
                      ),

                      const SizedBox(height: 20),

                      /// Special Requirements
                      CustomTextFormField(
                        hintText:
                            'E.g. Only accept bids from verified investors',
                        label: "Special Requirements",
                        maxLines: 3,
                        onChanged: (v) {
                          specialRequirements = v;
                        },
                      ),
                    ],
                  ),
                ),

                /// BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: "Save Draft",
                        color: theme.colorScheme.secondary.withOpacity(.1),
                        textColor: theme.colorScheme.secondary,
                        onTap: () {
                          context.hideKeyboard();
                          final model = cubit.state.model;

                          model.priceUsd = priceUsd;
                          model.maxAcceptedBids = maxAcceptedBids;
                          model.specialRequirements = specialRequirements;

                          model.investmentType = investmentType;
                          model.isSealedAuction = isAuction;
                          model.acceptsAdditionalInvestors = allowInvestors;
                          model.isRepresentative = isRepresentative;

                          cubit.updateModel(model);
                          if (model.title == null ||
                              model.description == null ||
                              model.latitude == null ||
                              model.longitude == null ||
                              model.city == null ||
                              model.neighborhood == null ||
                              model.areaSqm == null ||
                              model.plotWidth == null ||
                              model.plotDepth == null ||
                              model.investmentType == null ||
                              model.priceUsd == null ||
                              model.maxAcceptedBids == null ||
                              model.desiredBuildingType == null ||
                              model.desiredFloors == null ||
                              model.ownershipBasis == null ||
                              model.specialRequirements == null) {
                            context.showErrorSnackBar(
                              'Please complete all steps first',
                            );

                            return;
                          }

                          cubit.createDraft();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        title: "Next",
                        onTap: () {
                          context.hideKeyboard();
                          final model = cubit.state.model;

                          model.priceUsd = priceUsd;
                          model.maxAcceptedBids = maxAcceptedBids;
                          model.specialRequirements = specialRequirements;

                          model.investmentType = investmentType;
                          model.isSealedAuction = isAuction;
                          model.acceptsAdditionalInvestors = allowInvestors;
                          model.isRepresentative = isRepresentative;

                          cubit.updateModel(model);

                          widget.onNext();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _stepBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.secondary.withOpacity(.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: context.theme.colorScheme.secondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
