import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.label,
    this.obsecureText = false,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.controller,
  });
  final String? label;
  final String hintText;
  final bool obsecureText;
  final int maxLines;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? '',
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: obsecureText,
          maxLines: maxLines,
          validator: validator,
          onSaved: onSaved,
          onChanged: onChanged,
          cursorColor: Theme.of(context).colorScheme.primary,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: suffixIcon,
            border: buildBorder(context),
            enabledBorder: buildBorder(context),
            focusedBorder: buildBorder(
              context,
              Theme.of(context).colorScheme.primary,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 16.w,
            ),
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}

OutlineInputBorder buildBorder(BuildContext context, [Color? color]) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(
      color: color ?? Theme.of(context).colorScheme.outline,
    ),
  );
}
