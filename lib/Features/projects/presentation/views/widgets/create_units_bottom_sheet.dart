import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:takween/core/widgets/custom_text_form_field.dart';

class CreateUnitsBottomSheet extends StatefulWidget {
  final bool isCreating;
  final Future<void> Function(List<Map<String, dynamic>> units) onSubmit;

  const CreateUnitsBottomSheet({
    super.key,
    required this.isCreating,
    required this.onSubmit,
  });

  @override
  State<CreateUnitsBottomSheet> createState() => _CreateUnitsBottomSheetState();
}

class _CreateUnitsBottomSheetState extends State<CreateUnitsBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final List<_UnitInput> _rows = [_UnitInput()];

  @override
  void dispose() {
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  void _addRow() {
    setState(() => _rows.add(_UnitInput()));
  }

  void _removeRow(int index) {
    setState(() {
      _rows[index].dispose();
      _rows.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_rows.isEmpty) return;
    final payload = _rows
        .map(
          (r) => {
            'unitNumber': r.unitNumberController.text.trim(),
            'floor': int.tryParse(r.floorController.text.trim()) ?? 0,
            'areaSqm': double.tryParse(r.areaController.text.trim()) ?? 0,
            if (r.typeController.text.trim().isNotEmpty)
              'unitType': r.typeController.text.trim(),
          },
        )
        .toList();
    await widget.onSubmit(payload);
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
          maxHeight: MediaQuery.of(context).size.height * 0.85,
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
                      FontAwesomeIcons.buildingUser,
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
                          'Create Units',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Add one row per apartment / unit.',
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
                      for (int i = 0; i < _rows.length; i++)
                        _UnitRow(
                          index: i,
                          input: _rows[i],
                          onRemove:
                              _rows.length > 1 ? () => _removeRow(i) : null,
                        ),
                      SizedBox(height: 8.h),
                      OutlinedButton.icon(
                        onPressed: _addRow,
                        icon: const Icon(Icons.add),
                        label: const Text('Add another unit'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              widget.isCreating
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  : CustomButton(
                      title: 'Create ${_rows.length} unit(s)',
                      icon: Icons.check,
                      color: AppColors.primary,
                      onTap: _submit,
                    ),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: widget.isCreating
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

class _UnitRow extends StatelessWidget {
  final int index;
  final _UnitInput input;
  final VoidCallback? onRemove;

  const _UnitRow({
    required this.index,
    required this.input,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryContainerLight.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Unit #${index + 1}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              if (onRemove != null)
                IconButton(
                  iconSize: 18.sp,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onRemove,
                  icon: Icon(Icons.close, color: AppColors.error),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          CustomTextFormField(
            label: 'Unit Number',
            hintText: 'e.g. A101',
            controller: input.unitNumberController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  label: 'Floor',
                  hintText: '1',
                  keyboardType: TextInputType.number,
                  controller: input.floorController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    if (int.tryParse(value.trim()) == null) {
                      return 'Invalid';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: CustomTextFormField(
                  label: 'Area (m²)',
                  hintText: '120',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: input.areaController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    final n = double.tryParse(value.trim());
                    if (n == null || n <= 0) {
                      return 'Invalid';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          CustomTextFormField(
            label: 'Type (optional)',
            hintText: 'e.g. 2BR, Studio',
            controller: input.typeController,
          ),
        ],
      ),
    );
  }
}

class _UnitInput {
  final unitNumberController = TextEditingController();
  final floorController = TextEditingController();
  final areaController = TextEditingController();
  final typeController = TextEditingController();

  void dispose() {
    unitNumberController.dispose();
    floorController.dispose();
    areaController.dispose();
    typeController.dispose();
  }
}

