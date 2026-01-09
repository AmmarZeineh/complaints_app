import 'package:complaints_app/feature/notification/presentation/cubits/fetch_notification_cubit/fetch_notification_cubit.dart';
import 'package:complaints_app/feature/notification/presentation/views/widgets/notification_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationViewBody extends StatefulWidget {
  const NotificationViewBody({super.key});

  @override
  State<NotificationViewBody> createState() => _NotificationViewBodyState();
}

class _NotificationViewBodyState extends State<NotificationViewBody> {
  @override
  void initState() {
    context.read<FetchNotificationCubit>().fetchNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchNotificationCubit, FetchNotificationState>(
      builder: (context, state) {
        if (state is FetchNotificationLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FetchNotificationFailure) {
          return Center(child: Text(state.errMessage));
        } else if (state is FetchNotificationSuccess) {
          if (state.notifications.isEmpty) {
            return Center(child: Text('No Notifications'.tr()));
          } else {
            return CustomScrollView(
              slivers: [
                SliverList.builder(
                  itemCount: state.notifications.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: NotificationWidget(
                        notification: state.notifications[index],
                      ),
                    );
                  },
                ),
              ],
            );
          }
        }
        return SizedBox();
      },
    );
  }
}
