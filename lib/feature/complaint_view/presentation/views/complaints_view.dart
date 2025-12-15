import 'package:complaints_app/core/services/get_it_service.dart';
import 'package:complaints_app/core/utils/app_colors.dart';
import 'package:complaints_app/core/utils/app_font_styles.dart';
import 'package:complaints_app/feature/complaint_view/domain/repos/get_complaints_repo.dart';
import 'package:complaints_app/feature/complaint_view/presentation/cubits/get_complaint_cubit/get_complaints_cubit.dart';
import 'package:complaints_app/feature/complaint_view/presentation/views/widgets/complaints_view_body.dart';
import 'package:complaints_app/feature/notification/presentation/cubits/fetch_notification_cubit/fetch_notification_cubit.dart';
import 'package:complaints_app/feature/notification/presentation/views/notification_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComplaintsView extends StatelessWidget {
  const ComplaintsView({super.key});
  static const String routeName = "complaintsview";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            BlocBuilder<FetchNotificationCubit, FetchNotificationState>(
              builder: (context, state) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      // عرض النقطة الحمراء فقط عند وجود notifications غير مقروءة
                      if (state is FetchNotificationSuccess &&
                          state.hasUnreadNotifications)
                        Positioned(
                          right: 32,
                          top: 8,
                          child: Container(
                            height: MediaQuery.of(context).size.width * 0.025,
                            width: MediaQuery.of(context).size.width * 0.025,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            NotificationView.routeName,
                          );
                        },
                        icon: const Icon(
                          Icons.notifications,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Spacer(),
            Text(
              "الشكاوي المقدمة",
              style: AppTextStyles.w800_16.copyWith(color: Colors.white),
            ),
            Spacer(),
          ],
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) =>
              GetComplaintsCubit(getIt.get<GetComplaintsRepo>())
                ..getComplaints(skip: 0, limit: 10, context: context),
          child: ComplaintsViewBody(),
        ),
      ),
    );
  }
}
