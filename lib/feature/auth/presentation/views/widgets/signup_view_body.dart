import 'dart:developer';

import 'package:complaints_app/core/helper_functions/snack_bars.dart';
import 'package:complaints_app/core/utils/app_colors.dart';
import 'package:complaints_app/core/utils/app_font_styles.dart';
import 'package:complaints_app/core/widgets/custom_elevated_button.dart';
import 'package:complaints_app/core/widgets/custom_text_form_field.dart';
import 'package:complaints_app/feature/auth/presentation/cubits/signup_cubit/signup_cubit_cubit.dart';
import 'package:complaints_app/feature/auth/presentation/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? name, email, password, nationalId;
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 30.h),
                  SizedBox(height: 20),
                  Text(
                    'مرحبا',
                    style: AppTextStyles.w700_30.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 50),
                  CustomFormTextField(
                    onSaved: (p0) {
                      name = p0;
                    },
                    title: 'الاسم',
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: 30),
                  CustomFormTextField(
                    onSaved: (p0) {
                      email = p0;
                    },
                    title: 'البريد الالكتروني',
                    textInputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 30),
                  CustomFormTextField(
                    onSaved: (p0) {
                      nationalId = p0;
                    },
                    title: 'الرقم الوطني',
                    textInputType: .number,
                  ),
                  SizedBox(height: 30),
                  CustomFormTextField(
                    onSaved: (p0) {
                      password = p0;
                    },
                    prefixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      child: isObscure
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                    ),
                    obscureText: isObscure,
                    title: 'كلمة المرور',
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, LoginView.routeName);
                    },
                    child: Text(
                      'لديك حساب بالفعل؟',
                      style: AppTextStyles.w400_16.copyWith(
                        color: Colors.blueAccent,
                      ),
                      textAlign: .center,
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      title: 'تسجيل',
                      onPressed: () async {
                        if (nationalId == null || nationalId!.length < 13) {
                          showErrorMessage(
                            'يجب ان يكون الرقم الوطني من 13 رقم',
                            context,
                          );
                        }
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                        }
                        log(nationalId.toString());

                        autovalidateMode = AutovalidateMode.onUserInteraction;
                        setState(() {});
                        await context.read<SignupCubitCubit>().signup(
                          email: email!,
                          password: password!,
                          name: name!,
                          nationalId: nationalId!,
                        );
                      },
                      padding: EdgeInsetsGeometry.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
