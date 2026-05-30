import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:takween/Features/authentication/presentation/viewmodel/create_account/create_account_cubit.dart';
import 'package:takween/core/router/routes.dart';
import 'package:takween/core/services/auth_service.dart';
import 'package:takween/core/utils/app_strings.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/utils/validators.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:takween/core/widgets/custom_dropdown_form_field.dart';
import 'package:takween/core/widgets/custom_text_form_field.dart';
import 'package:takween/core/widgets/password_text_form_field.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  String? firstName, lastName, email, password, confirmPassword, role;
  void _submit() {
    context.hideKeyboard();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<CreateAccountCubit>().createAccount(
        firstName: firstName!,
        lastName: lastName!,
        email: email!,
        role: role!,
        password: password!,
        confirmPassword: confirmPassword!,
      );
    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: BlocListener<CreateAccountCubit, CreateAccountState>(
          listener: (context, state) {
            if (state is CreateAccountLoadingState) {
              context.showLoading();
            } else if (state is CreateAccountSuccessState) {
              context.hideLoading();
              AuthService.navigateByRole(context, role);
              context.showSuccessSnackBar('Success');
            } else if (state is CreateAccountFailureState) {
              context.hideLoading();
              context.showErrorSnackBar(state.errorMessage);
            }
          },

          child: Form(
            key: _formKey,
            autovalidateMode: _autoValidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),

                /// Logo
                Center(
                  child: Container(
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person_add_alt_1_rounded,
                      size: 36.sp,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Title
                Text(
                  AppStrings.createAccount.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  AppStrings.signUpSubtitle.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),

                const SizedBox(height: 30),

                /// First Name
                CustomTextFormField(
                  hintText: AppStrings.firstName.tr(),
                  label: AppStrings.firstName.tr(),
                  prefixIcon: Icons.person_outline,
                  validator: (value) => Validators.minLength(
                    value,
                    3,
                    fieldName: AppStrings.firstName,
                  ),
                  onSaved: (value) => firstName = value,
                ),

                const SizedBox(height: 16),

                /// Last Name
                CustomTextFormField(
                  hintText: AppStrings.lastName.tr(),
                  label: AppStrings.lastName.tr(),
                  prefixIcon: Icons.person_outline,
                  validator: (value) => Validators.minLength(
                    value,
                    3,
                    fieldName: AppStrings.lastName,
                  ),
                  onSaved: (value) => lastName = value,
                ),

                const SizedBox(height: 16),

                /// Email
                CustomTextFormField(
                  hintText: AppStrings.email.tr(),
                  label: AppStrings.email.tr(),
                  prefixIcon: Icons.email_outlined,
                  validator: (value) => Validators.email(value),
                  onSaved: (value) => email = value,
                ),

                const SizedBox(height: 16),

                /// Role
                CustomDropdownFormField<String>(
                  label: AppStrings.role.tr(),
                  hintText: "Select role",
                  value: role,
                  items: const [
                    DropdownMenuItem(
                      value: "LandOwner",
                      child: Text("Land Owner"),
                    ),
                    DropdownMenuItem(
                      value: "Contractor",
                      child: Text("Contractor"),
                    ),
                    DropdownMenuItem(
                      value: "Buyer",
                      child: Text("Buyer"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      role = value;
                    });
                  },
                  onSaved: (value) => role = value,
                  validator: (value) =>
                      value == null ? "Please select a role" : null,
                ),

                const SizedBox(height: 16),

                /// Password
                SensitiveContent(
                  sensitivity: ContentSensitivity.sensitive,
                  child: PasswordTextFormField(
                    hintText: AppStrings.password.tr(),
                    label: AppStrings.password.tr(),
                    validator: (value) => Validators.password(value),
                    onChanged: (value) => password = value,
                    onSaved: (value) => password = value,
                  ),
                ),

                const SizedBox(height: 16),

                /// Confirm Password
                SensitiveContent(
                  sensitivity: ContentSensitivity.sensitive,
                  child: PasswordTextFormField(
                    hintText: AppStrings.confirmPassword.tr(),
                    label: AppStrings.confirmPassword.tr(),
                    validator: (value) =>
                        Validators.confirmPassword(value, password),
                    onSaved: (value) => confirmPassword = value,
                  ),
                ),

                const SizedBox(height: 30),

                /// Sign Up Button
                CustomButton(title: AppStrings.signUp.tr(), onTap: _submit),

                const SizedBox(height: 24),

                /// Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.alreadyHaveAccount.tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => context.go(Routes.signIn),
                      child: Text(
                        AppStrings.signIn.tr(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


