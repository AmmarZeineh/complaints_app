import 'package:complaints_app/core/services/get_it_service.dart';
import 'package:complaints_app/core/utils/app_colors.dart';
import 'package:complaints_app/core/utils/app_font_styles.dart';
import 'package:complaints_app/feature/notification/domain/repos/notification_repo.dart';
import 'package:complaints_app/feature/notification/presentation/cubits/fetch_notification_cubit/fetch_notification_cubit.dart';
import 'package:complaints_app/feature/notification/presentation/cubits/mark_as_read_cubit/mark_as_read_cubit.dart';
import 'package:complaints_app/feature/notification/presentation/views/widgets/notification_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});
  static const routeName = 'notification-view';

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          'الاشعارات',
          style: AppTextStyles.w600_18.copyWith(color: AppColors.primaryColor),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => MarkAsReadCubit(getIt.get<NotificationRepo>()),
          child: RefreshIndicator(
            onRefresh: () async {
              await context.read<FetchNotificationCubit>().fetchNotifications(
                context: context,
              );
            },
            child: NotificationViewBody(),
          ),
        ),
      ),
    );
  }
}
