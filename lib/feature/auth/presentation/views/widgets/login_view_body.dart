import 'package:complaints_app/core/services/notification_service.dart';
import 'package:complaints_app/core/utils/app_font_styles.dart';
import 'package:complaints_app/core/widgets/custom_elevated_button.dart';
import 'package:complaints_app/core/widgets/custom_text_form_field.dart';
import 'package:complaints_app/feature/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:complaints_app/feature/auth/presentation/views/signup_view.dart';
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
                'مرحبا مرة اخرى',
                style: AppTextStyles.w700_20,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'نتمنى انك بخير',
                style: AppTextStyles.w400_14,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              CustomFormTextField(
                textInputType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email),
                title: 'البريد الالكتروني',
                onSaved: (p0) => email = p0,
              ),
              SizedBox(height: 20),
              CustomFormTextField(
                textInputType: TextInputType.text,
                obscureText: true,
                prefixIcon: Icon(Icons.password),
                title: 'كلمة المرور',
                onSaved: (p0) => password = p0,
              ),
              SizedBox(height: 23),
              CustomElevatedButton(
                title: 'تسجيل الدخول',
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    var token = await NotificationService.getFcmToken();
                    if (context.mounted) {
                      await context.read<LoginCubit>().login(
                        context: context,
                        email: email!,
                        password: password!,
                        fcmToken: token!,
                      );
                    }
                    autovalidateMode = AutovalidateMode.always;
                  }
                },
              ),
              SizedBox(height: 15),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'ليس لديك حساب؟ ',
                    style: AppTextStyles.w400_14,
                    children: [
                      TextSpan(
                        text: 'تسجيل',
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
                  'هل نسيت كلمة المرور؟',
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
