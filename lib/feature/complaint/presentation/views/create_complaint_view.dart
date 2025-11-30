import 'package:complaints_app/core/services/get_it_service.dart';
import 'package:complaints_app/core/utils/app_colors.dart';
import 'package:complaints_app/core/utils/app_font_styles.dart';
import 'package:complaints_app/feature/complaint/domain/repos/create_complaint_repo.dart';
import 'package:complaints_app/feature/complaint/presentation/cubits/create_complaint_cubit/create_complaint_cubit.dart';
import 'package:complaints_app/feature/complaint/presentation/cubits/get_government_cubit/get_government_cubit.dart';
import 'package:complaints_app/feature/complaint/presentation/views/widgets/create_complaint_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateComplaintView extends StatelessWidget {
  const CreateComplaintView({super.key});
  static const String routeName = "/create-complaint-view";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "تقديم شكوى جديدة",
          style: AppTextStyles.w800_16.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  GetGovernmentCubit(getIt.get<CreateComplaintRepo>()),
            ),
            BlocProvider(
              create: (context) =>
                  CreateComplaintCubit(getIt.get<CreateComplaintRepo>()),
            ),
          ],
          child: CreateComplaintViewBody(),
        ),
      ),
    );
  }
}
