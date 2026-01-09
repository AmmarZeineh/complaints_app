import 'package:complaints_app/core/cubits/cubit/user_cubit.dart';
import 'package:complaints_app/core/helper_functions/on_generate_routes.dart';
import 'package:complaints_app/core/services/custom_bloc_observer.dart';
import 'package:complaints_app/core/services/get_it_service.dart';
import 'package:complaints_app/core/services/notification_service.dart';
import 'package:complaints_app/core/services/shared_preference_singletone.dart';
import 'package:complaints_app/feature/auth/domain/repos/auth_repo.dart';
import 'package:complaints_app/feature/auth/presentation/cubits/verify_cubit/verify_cubit.dart';
import 'package:complaints_app/feature/auth/presentation/views/signup_view.dart';
import 'package:complaints_app/feature/notification/domain/repos/notification_repo.dart';
import 'package:complaints_app/feature/notification/presentation/cubits/fetch_notification_cubit/fetch_notification_cubit.dart';
import 'package:complaints_app/firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initializeNotification(navKey: navigatorKey);
  FirebaseMessaging.onBackgroundMessage(
    NotificationService.firebaseMessagingBackgroundHandler,
  );

  setupLocator();
  await Prefs.init();
  Bloc.observer = CustomBlocObserver();
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => EasyLocalization(
        supportedLocales: [Locale('ar')],
        path: 'assets/langs', // <-- change the path of the translation files
        fallbackLocale: Locale('ar'),
        child: ComplaintApp(),
      ),
    ),
  );
}

class ComplaintApp extends StatelessWidget {
  const ComplaintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserCubit()),
        BlocProvider(create: (context) => VerifyCubit(getIt.get<AuthRepo>())),
        BlocProvider(
          create: (context) =>
              FetchNotificationCubit(getIt.get<NotificationRepo>()),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'cairo',
          scaffoldBackgroundColor: Colors.white,
        ),
        onGenerateRoute: onGenerateRoutes,
        initialRoute: SignupView.routeName,
      ),
    );
  }
}
