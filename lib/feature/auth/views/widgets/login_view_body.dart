import 'package:complaints_app/core/utils/app_font_styles.dart';
import 'package:complaints_app/core/widgets/custom_elevated_button.dart';
import 'package:complaints_app/core/widgets/custom_text_form_field.dart';
import 'package:complaints_app/feature/auth/views/cubits/login_cubit/login_cubit.dart';
import 'package:complaints_app/feature/auth/views/signup_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? email, password;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),

              Text(
                "auth.hi_welcome_back".tr(),
                style: AppTextStyles.w700_20,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "auth.hope_your_fine".tr(),
                style: AppTextStyles.w400_14,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              CustomFormTextField(
                textInputType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email),
                title: "auth.email".tr(),
                onSaved: (p0) => email = p0,
              ),
              SizedBox(height: 20),
              CustomFormTextField(
                textInputType: TextInputType.text,
                obscureText: true,
                prefixIcon: Icon(Icons.password),
                title: "auth.password".tr(),
                onSaved: (p0) => password = p0,
              ),
              SizedBox(height: 23),
              CustomElevatedButton(
                title: "auth.login".tr(),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    if (context.mounted) {
                      await context.read<LoginCubit>().login(
                        email: email!,
                        password: password!,
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 15),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "auth.dont_have_an_account".tr(),
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                    children: [
                      TextSpan(
                        text: "auth.signup".tr(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, SignupView.routeName);
                          },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Navigator.pushNamed(context, ForgotPasswordView.routeName);
                },
                child: Text(
                  "auth.forgot_password".tr(),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
