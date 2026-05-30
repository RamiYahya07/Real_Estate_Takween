import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:takween/Features/posts/presentation/viewmodels/create_land_post/create_land_post_cubit.dart';
import 'package:takween/core/router/routes.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/app_strings.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/utils/validators.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:takween/core/widgets/custom_dropdown_form_field.dart';
import 'package:takween/core/widgets/custom_text_form_field.dart';

class PostDetailsStepView extends StatefulWidget {
  final VoidCallback onNext;
  const PostDetailsStepView({super.key, required this.onNext});

  @override
  State<PostDetailsStepView> createState() => _PostDetailsStepViewState();
}

@override
void initState() {}

class _PostDetailsStepViewState extends State<PostDetailsStepView> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? selectedCity;
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔹 HEADER (Step title + counter)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${AppStrings.step.tr().capitalize()} 1: ${AppStrings.propertyDetails.tr().capitalizeWords()}",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withOpacity(.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "1 of 4",
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// 🔹 PROGRESS BAR
            StepProgressIndicator(
              totalSteps: 4,
              currentStep: 1,
              size: 8,
              padding: 0,
              roundedEdges: const Radius.circular(10),
              selectedColor: theme.colorScheme.secondary,
              unselectedColor: theme.dividerColor,
            ),

            const SizedBox(height: 24),

            /// 🔹 FORM CONTENT
            Expanded(
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: ListView(
                  children: [
                    /// Property Title
                    CustomTextFormField(
                      label: AppStrings.propertyTitle.tr().capitalizeWords(),
                      hintText: AppStrings.propertyTitleExample
                          .tr()
                          .capitalize(),
                      validator: (value) => Validators.required(
                        value,
                        fieldName: AppStrings.propertyTitle,
                      ),
                      onSaved: (value) {
                        final cubit = context.read<CreateLandPostCubit>();
                        final model = cubit.state.model;

                        model.title = value;
                        cubit.updateModel(model);
                      },
                    ),

                    const SizedBox(height: 16),

                    /// Description
                    CustomTextFormField(
                      label: AppStrings.description.tr().capitalize(),
                      hintText: AppStrings.descriptionExample.tr(),
                      maxLines: 4,
                      validator: (value) => Validators.required(
                        value,
                        fieldName: AppStrings.description,
                      ),
                      onSaved: (value) {
                        final cubit = context.read<CreateLandPostCubit>();
                        final model = cubit.state.model;

                        model.description = value;
                        cubit.updateModel(model);
                      },
                    ),

                    const SizedBox(height: 16),

                    /// City Dropdown
                    CustomDropdownFormField<String>(
                      label: AppStrings.city.tr().capitalize(),
                      hintText: AppStrings.selectCity.tr().capitalizeWords(),
                      value: selectedCity,
                      items: AppStrings.syrianCities
                          .map(
                            (cityKey) => DropdownMenuItem(
                              value: cityKey,
                              child: Text(cityKey.tr()),
                            ),
                          )
                          .toList(),
                      validator: (value) => Validators.required(
                        value,
                        fieldName: AppStrings.city,
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedCity = value;
                        });
                      },
                      onSaved: (value) {
                        final cubit = context.read<CreateLandPostCubit>();
                        final model = cubit.state.model;

                        model.city = value;
                        cubit.updateModel(model);
                      },
                    ),
                    const SizedBox(height: 16),

                    CustomTextFormField(
                      label: AppStrings.neighborhood.tr().capitalize(),
                      hintText: AppStrings.neighborhoodExample
                          .tr()
                          .capitalize(),
                      validator: (value) => Validators.required(
                        value,
                        fieldName: AppStrings.neighborhood,
                      ),
                      onSaved: (value) {
                        final cubit = context.read<CreateLandPostCubit>();
                        final model = cubit.state.model;

                        model.neighborhood = value;
                        cubit.updateModel(model);
                      },
                    ),
                    const SizedBox(height: 16),

                    /// Location
                    Text(AppStrings.exactLocation.tr().capitalizeWords()),
                    const SizedBox(height: 6),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final result = await context.push<LatLng>(Routes.map);

                        if (result != null) {
                          setState(() {
                            selectedLocation = result;
                          });
                        }
                      },
                      icon: const Icon(Icons.location_on_outlined),
                      label: Text(AppStrings.tapToSelectOnMap.tr()),
                    ),
                    if (selectedLocation != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Lat: ${selectedLocation!.latitude}, Lng: ${selectedLocation!.longitude}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            /// 🔹 ACTION BUTTONS
            CustomButton(
              title: AppStrings.nextStep.tr().capitalizeWords(),
              onTap: () {
                context.hideKeyboard();
                if (_formKey.currentState!.validate()) {
                  if (selectedCity == null) {
                    context.showSnackBarMessage(
                      'Please select location',
                      backgroundColor: AppColors.info,
                    );
                    return;
                  }

                  _formKey.currentState!.save();

                  if (selectedLocation != null) {
                    final cubit = context.read<CreateLandPostCubit>();
                    final model = cubit.state.model;

                    model.latitude = selectedLocation!.latitude;
                    model.longitude = selectedLocation!.longitude;

                    cubit.updateModel(model);
                  }

                  widget.onNext();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
