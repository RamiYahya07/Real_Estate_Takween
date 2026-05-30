import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:takween/core/widgets/custom_dropdown_form_field.dart';
import 'package:takween/core/widgets/custom_text_form_field.dart';

class CreateListingBottomSheet extends StatefulWidget {
  final bool isSubmitting;
  final Future<void> Function({
    required String title,
    String? description,
    required String type,
    required double priceUsd,
    double? areaSqm,
    int? rooms,
    int? floor,
  }) onSubmit;

  const CreateListingBottomSheet({
    super.key,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  State<CreateListingBottomSheet> createState() =>
      _CreateListingBottomSheetState();
}

class _CreateListingBottomSheetState extends State<CreateListingBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _areaController = TextEditingController();
  final _roomsController = TextEditingController();
  final _floorController = TextEditingController();

  String _type = 'SALE';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _areaController.dispose();
    _roomsController.dispose();
    _floorController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await widget.onSubmit(
      title: _titleController.text,
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      type: _type,
      priceUsd: double.parse(_priceController.text.trim()),
      areaSqm: _areaController.text.trim().isEmpty
          ? null
          : double.tryParse(_areaController.text.trim()),
      rooms: _roomsController.text.trim().isEmpty
          ? null
          : int.tryParse(_roomsController.text.trim()),
      floor: _floorController.text.trim().isEmpty
          ? null
          : int.tryParse(_floorController.text.trim()),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20.h,
        left: 20.w,
        right: 20.w,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.textQuaternaryLight,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.house,
                      color: AppColors.primary,
                      size: 18.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'List Property',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Publish a unit from this completed project.',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textTertiaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTextFormField(
                        label: 'Title',
                        hintText: 'e.g. 3BR Apartment in Damascus',
                        controller: _titleController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        label: 'Description (optional)',
                        hintText: 'Anything that helps buyers',
                        maxLines: 3,
                        controller: _descriptionController,
                      ),
                      CustomDropdownFormField<String>(
                        label: 'Type',
                        hintText: 'Select type',
                        value: _type,
                        items: const [
                          DropdownMenuItem(value: 'SALE', child: Text('SALE')),
                          DropdownMenuItem(value: 'RENT', child: Text('RENT')),
                        ],
                        onChanged: (value) {
                          if (value != null) setState(() => _type = value);
                        },
                      ),
                      CustomTextFormField(
                        label: 'Price (USD)',
                        hintText: 'e.g. 140000',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        controller: _priceController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }
                          final n = double.tryParse(value.trim());
                          if (n == null || n <= 0) {
                            return 'Must be greater than 0';
                          }
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              label: 'Area (m²)',
                              hintText: '120',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              controller: _areaController,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomTextFormField(
                              label: 'Rooms',
                              hintText: '3',
                              keyboardType: TextInputType.number,
                              controller: _roomsController,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomTextFormField(
                              label: 'Floor',
                              hintText: '2',
                              keyboardType: TextInputType.number,
                              controller: _floorController,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              widget.isSubmitting
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : CustomButton(
                      title: 'Publish Listing',
                      icon: Icons.publish_outlined,
                      color: AppColors.primary,
                      onTap: _submit,
                    ),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: widget.isSubmitting
                    ? null
                    : () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textTertiaryLight),
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
