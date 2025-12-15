import 'package:complaints_app/feature/auth/views/login_view.dart';
import 'package:complaints_app/feature/auth/views/signup_view.dart';
import 'package:complaints_app/feature/auth/views/verify_view.dart';
import 'package:complaints_app/feature/complaint_view/domain/entities/complaint_entity.dart';
import 'package:complaints_app/feature/complaint_view/presentation/views/complaint_details_view.dart';
import 'package:complaints_app/feature/complaint_view/presentation/views/complaints_view.dart';
import 'package:complaints_app/feature/complaint/presentation/views/create_complaint_view.dart';
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
    case ComplaintsView.routeName:
      return MaterialPageRoute(builder: (_) => const ComplaintsView());
    case ComplaintDetailsView.routeName:
      return MaterialPageRoute(
        builder: (_) {
          final complaint = settings.arguments as ComplaintEntity;
          return ComplaintDetailsView(complaint: complaint,);
        },
      );
    default:
      return MaterialPageRoute(builder: (_) => const Scaffold());
  }
}
