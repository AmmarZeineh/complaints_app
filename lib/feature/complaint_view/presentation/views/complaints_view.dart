import 'package:complaints_app/core/services/get_it_service.dart';
import 'package:complaints_app/core/utils/app_colors.dart';
import 'package:complaints_app/core/utils/app_font_styles.dart';
import 'package:complaints_app/feature/complaint_view/domain/repos/get_complaints_repo.dart';
import 'package:complaints_app/feature/complaint_view/presentation/cubits/get_complaint_cubit/get_complaints_cubit.dart';
import 'package:complaints_app/feature/complaint_view/presentation/views/widgets/complaints_view_body.dart';
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
        title: Text(
          " الشكاوي المقدمة ",
          style: AppTextStyles.w800_16.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) =>
              GetComplaintsCubit(getIt.get<GetComplaintsRepo>())..getComplaints(skip: 0, limit: 10, context: context),
          child: ComplaintsViewBody(),
        ),
      ),
    );
  }
}
