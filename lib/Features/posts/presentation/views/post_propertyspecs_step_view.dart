import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:takween/Features/posts/presentation/viewmodels/create_land_post/create_land_post_cubit.dart';
import 'package:takween/core/utils/constants.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:takween/core/widgets/custom_dropdown_form_field.dart';
import 'package:takween/core/widgets/custom_text_form_field.dart';

class PostPropertySpecsStepView extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const PostPropertySpecsStepView({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<PostPropertySpecsStepView> createState() =>
      _PostPropertySpecsStepViewState();
}

class _PostPropertySpecsStepViewState extends State<PostPropertySpecsStepView> {
  double? area;
  double? width;
  double? depth;

  int? ownershipBasis;
  int? buildingType;
  int floors = 12;

  String? getOwnershipKey(int? value) {
    if (value == null) return null;
    return ownershipMap.entries.firstWhere((e) => e.value == value).key;
  }

  String? getBuildingKey(int? value) {
    if (value == null) return null;
    return buildingTypeMap.entries.firstWhere((e) => e.value == value).key;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔹 HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: widget.onBack,
                ),

                Expanded(
                  child: Text(
                    "Step 2: Property Specifications",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                _badge("2 of 4"),
              ],
            ),

            const SizedBox(height: 16),

            /// 🔹 PROGRESS
            StepProgressIndicator(
              totalSteps: 4,
              currentStep: 2,
              size: 8,
              roundedEdges: const Radius.circular(10),
              selectedColor: theme.colorScheme.secondary,
              unselectedColor: theme.dividerColor,
            ),

            const SizedBox(height: 24),

            /// 🔹 CONTENT
            Expanded(
              child: ListView(
                children: [
                  /// 🔸 Ownership
                  CustomDropdownFormField<String>(
                    hintText: 'Select Ownership Basis',
                    label: "Ownership Basis",
                    value: getOwnershipKey(ownershipBasis),
                    items: ownershipMap.keys
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        ownershipBasis = ownershipMap[v];
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  /// 🔸 Building Type
                  CustomDropdownFormField<String>(
                    hintText: 'Select Desired Building Type',
                    label: "Desired Building Type",
                    value: getBuildingKey(buildingType),
                    items: buildingTypeMap.keys
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        buildingType = buildingTypeMap[v];
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  /// 🔸 PROPERTY DIMENSIONS
                  _sectionTitle(
                    icon: Icons.square_foot,
                    title: "Property Dimensions",
                  ),

                  const SizedBox(height: 12),

                  CustomTextFormField(
                    hintText: '800',
                    label: "Area (m²)",
                    onChanged: (v) => area = double.tryParse(v ?? ''),
                  ),

                  CustomTextFormField(
                    hintText: '25',
                    label: "Plot Width (m)",
                    onChanged: (v) => width = double.tryParse(v ?? ''),
                  ),

                  CustomTextFormField(
                    hintText: '25',
                    label: "Plot Depth (m)",
                    onChanged: (v) => depth = double.tryParse(v ?? ''),
                  ),

                  const SizedBox(height: 24),

                  /// 🔸 BUILDING CAPACITY
                  _sectionTitle(
                    icon: Icons.apartment,
                    title: "Building Capacity",
                    trailing: _floorsBadge(),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Desired Floors (1 - 50)",
                    style: theme.textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 10),

                  /// 🔹 SLIDER
                  Slider(
                    value: floors.toDouble(),
                    min: 1,
                    max: 50,
                    divisions: 49,
                    label: floors.round().toString(),
                    activeColor: theme.colorScheme.secondary,
                    onChanged: (value) {
                      setState(() => floors = value.toInt());
                    },
                  ),

                  /// 🔹 LABELS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("1 Floor"),
                      Text("25 Floors"),
                      Text("50 Floors"),
                    ],
                  ),
                ],
              ),
            ),

            /// 🔹 BUTTON
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: "Next",
                    onTap: () {
                      final cubit = context.read<CreateLandPostCubit>();
                      final model = cubit.state.model;

                      model.areaSqm = area;
                      model.plotWidth = width;
                      model.plotDepth = depth;

                      model.ownershipBasis = ownershipBasis;
                      model.desiredBuildingType = buildingType;
                      model.desiredFloors = floors;

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
  }

  /// 🔹 SECTION TITLE
  Widget _sectionTitle({
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: context.theme.colorScheme.secondary),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const Spacer(),
        ?trailing,
      ],
    );
  }

  /// 🔹 BADGE (2 of 4)
  Widget _badge(String text) {
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

  /// 🔹 FLOORS BADGE (e.g. 12 Floors)
  Widget _floorsBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.secondary.withOpacity(.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "${floors.round()} Floors",
        style: TextStyle(
          color: context.theme.colorScheme.secondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
