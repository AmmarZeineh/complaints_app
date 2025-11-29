import 'package:complaints_app/core/utils/app_font_styles.dart';
import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget {
  const CustomFormTextField({
    super.key,
    required this.title,
    required this.textInputType,
    this.prefixIcon,
    this.onSaved,
    this.obscureText = false,
    this.maxLines = 1,
    this.validator,
  });
  final String title;
  final TextInputType textInputType;
  final Widget? prefixIcon;
  final void Function(String?)? onSaved;
  final bool obscureText;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      style: const TextStyle(color: Colors.black),
      obscureText: obscureText,
      onSaved: onSaved,
      validator:
          validator ??
          (value) {
            if (value!.isEmpty) {
              return 'هذا الحقل مطلوب';
            }
            return null;
          },
      keyboardType: textInputType,

      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        border: buildBorder(),
        focusedBorder: buildBorder(),
        enabledBorder: buildBorder(),
        label: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.w400_14.copyWith(color: Colors.black),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  UnderlineInputBorder buildBorder() {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1.8),
    );
  }
}
