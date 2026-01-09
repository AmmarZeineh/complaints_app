import 'package:complaints_app/core/services/get_it_service.dart';
import 'package:complaints_app/core/utils/app_colors.dart';
import 'package:complaints_app/core/utils/app_font_styles.dart';
import 'package:complaints_app/feature/complaint_view/domain/entities/complaint_entity.dart';
import 'package:complaints_app/feature/complaint_view/domain/repos/get_complaints_repo.dart';
import 'package:complaints_app/feature/complaint_view/presentation/cubits/send_interaction_cubit/send_interaction_cubit.dart';
import 'package:complaints_app/feature/complaint_view/presentation/views/widgets/complaint_details_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComplaintDetailsView extends StatelessWidget {
  const ComplaintDetailsView({super.key, required this.complaint});
  static const String routeName = '/complaintDetailsView';
  final ComplaintEntity complaint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          "تفاصيل الشكوى",
          style: AppTextStyles.w800_16.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),

      body: SafeArea(
        child: BlocProvider(
          create: (context) =>
              SendInteractionCubit(getIt.get<GetComplaintsRepo>()),
          child: ComplaintDetailsViewBody(complaint: complaint),
        ),
      ),
    );
  }
}
