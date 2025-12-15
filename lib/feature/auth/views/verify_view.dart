import 'package:complaints_app/feature/auth/views/widgets/verify_view_body.dart';
import 'package:flutter/material.dart';

class VerifyView extends StatelessWidget {
  const VerifyView({super.key, required this.email});
  final String email;
  static const String routeName = "verify_view";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: SafeArea(child: VerifyViewBody(email: email)),
    );
  }
}
