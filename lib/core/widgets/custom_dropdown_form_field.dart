import 'package:flutter/material.dart';
import 'package:takween/core/widgets/custom_text_form_field.dart';

class CustomDropdownFormField<T> extends StatelessWidget {
  const CustomDropdownFormField({
    super.key,
    this.label,
    this.hintText,
    required this.items,
    this.value,
    this.onChanged,
    this.onSaved,
    this.validator,
  });

  final String? label;
  final String? hintText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final void Function(T?)? onChanged;
  final void Function(T?)? onSaved;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
          ),
        const SizedBox(height: 8),

        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            border: buildBorder(context),
            enabledBorder: buildBorder(context),
            focusedBorder: buildBorder(
              context,
              Theme.of(context).colorScheme.primary,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
        ),

        const SizedBox(height: 12),
      ],
    );
  }
}
