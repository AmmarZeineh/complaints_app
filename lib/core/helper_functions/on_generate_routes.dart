import 'package:complaints_app/feature/auth/presentation/views/login_view.dart';
import 'package:complaints_app/feature/auth/presentation/views/signup_view.dart';
import 'package:complaints_app/feature/auth/presentation/views/verify_view.dart';
import 'package:complaints_app/feature/complaint/presentation/views/create_complaint_view.dart';
import 'package:complaints_app/feature/notification/presentation/views/notification_view.dart';
import 'package:flutter/material.dart';

Route<dynamic> onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case SignupView.routeName:
      return MaterialPageRoute(builder: (_) => const SignupView());
    case LoginView.routeName:
      return MaterialPageRoute(builder: (_) => const LoginView());
    case VerifyView.routeName:
      return MaterialPageRoute(
        builder: (_) {
          final email = settings.arguments as String;
          return VerifyView(email: email);
        },
      );
    case CreateComplaintView.routeName:
      return MaterialPageRoute(builder: (_) => const CreateComplaintView());
    case NotificationView.routeName:
      return MaterialPageRoute(builder: (_) => const NotificationView());
    default:
      return MaterialPageRoute(builder: (_) => const Scaffold());
  }
}
