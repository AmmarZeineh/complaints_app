import 'package:bloc/bloc.dart';
import 'package:complaints_app/core/services/custom_bloc_observer.dart';
import 'package:complaints_app/core/services/get_it_service.dart';
import 'package:complaints_app/core/services/shared_preference_singletone.dart';
import 'package:complaints_app/feature/auth/views/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  setupLocator();
  await Prefs.init();
  Bloc.observer = CustomBlocObserver();
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => ComplaintApp(),
    ),
  );
}

class ComplaintApp extends StatelessWidget {
  const ComplaintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'cairo'),
      home: SignupView(),
    );
  }
}
