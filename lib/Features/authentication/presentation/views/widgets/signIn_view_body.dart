import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:takween/Features/authentication/presentation/viewmodel/sign_in/sign_in_cubit.dart';
import 'package:takween/core/router/routes.dart';
import 'package:takween/core/services/auth_service.dart';
import 'package:takween/core/utils/app_strings.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/utils/validators.dart';
import 'package:takween/core/widgets/custom_text_form_field.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:takween/core/widgets/password_text_form_field.dart';
import 'package:takween/core/widgets/text_between_two_dividers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInViewBody extends StatefulWidget {
  const SignInViewBody({super.key});

  @override
  State<SignInViewBody> createState() => _SignInViewBodyState();
}

class _SignInViewBodyState extends State<SignInViewBody> {
  String? email, password;
  final GlobalKey<FormState> _formKey = GlobalKey();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  void _submit() {
    context.hideKeyboard();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<SignInCubit>().login(
        email: email ?? '',
        password: password ?? "",
      );
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: BlocListener<SignInCubit, SignInState>(
          listener: (context, state) {
            if (state is SignInLoadingState) {
              context.showLoading();
            } else if (state is SignInSuccessState) {
              context.hideLoading();
              final role = state.role;
              debugPrint('role:$role');
              AuthService.navigateByRole(context, role);
              context.showSuccessSnackBar('Success');
            } else if (state is SignInFailureState) {
              context.hideLoading();
              context.showErrorSnackBar(state.errorMessage);
            }
          },
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                /// Logo
                Center(
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Icon(
                      Icons.maps_home_work_rounded,
                      size: 48.sp,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                /// Title
                Text(
                  textAlign: TextAlign.center,
                  AppStrings.welcomeBack.tr(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                /// Subtitle
                Text(
                  textAlign: TextAlign.center,
                  AppStrings.enterDetailsAccessAccount.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),

                const SizedBox(height: 24),

                /// Email
                CustomTextFormField(
                  label: AppStrings.email.tr(),
                  hintText: "takween@example.com",
                  prefixIcon: Icons.email_outlined,
                  validator: (value) => Validators.email(value),
                  onSaved: (value) => email = value,
                ),

                const SizedBox(height: 16),

                /// Password
                // SensitiveContent(
                //   sensitivity: ContentSensitivity.sensitive,
                // child:
                PasswordTextFormField( 
                  label: AppStrings.password.tr(),
                  hintText: "Password123!@#",
                  validator: (value) => Validators.required(
                    value,
                    fieldName: AppStrings.password,
                  ),
                  onSaved: (value) => password = value,
                ),

                // ),   
                const SizedBox(height: 24),

                /// Sign In Button
                CustomButton(title: AppStrings.signIn.tr(), onTap: _submit),

                const SizedBox(height: 24),

                /// OR Divider
                TextBetweenTwoDividers(),

                const SizedBox(height: 24),

                /// Create Account Button
                CustomButton(
                  title: AppStrings.createAccount.tr(),
                  color: Theme.of(context).colorScheme.secondary,
                  onTap: () => context.go(Routes.signUp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
