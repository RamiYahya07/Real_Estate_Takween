import 'package:flutter/material.dart';
import 'package:takween/core/widgets/custom_text_form_field.dart';

class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({
    super.key,
    required this.hintText,
    this.label,
    this.validator,
    this.onSaved,
    this.onChanged,
  });

  final String hintText;
  final String? label;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;

  @override
  State<PasswordTextFormField> createState() =>
      _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState
    extends State<PasswordTextFormField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      label: widget.label,
      hintText: widget.hintText,
      obsecureText: _isObscured,
      prefixIcon: Icons.lock_outline,
      validator: widget.validator,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      suffixIcon: IconButton(
        icon: Icon(
          _isObscured
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
        onPressed: () {
          setState(() {
            _isObscured = !_isObscured;
          });
        },
      ),
    );
  }
}