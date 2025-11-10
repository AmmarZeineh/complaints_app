import 'package:complaints_app/core/helper_functions/snack_bars.dart';
import 'package:complaints_app/core/services/get_it_service.dart';
import 'package:complaints_app/feature/auth/domain/repos/auth_repo.dart';
import 'package:complaints_app/feature/auth/views/cubits/cubit/signup_cubit_cubit.dart';
import 'package:complaints_app/feature/auth/views/widgets/signup_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => SignupCubitCubit(getIt.get<AuthRepo>()),
          child: SignupViewBlocConsumer(),
        ),
      ),
    );
  }
}

class SignupViewBlocConsumer extends StatelessWidget {
  const SignupViewBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubitCubit, SignupCubitState>(
      listener: (context, state) {
        if (state is SignupCubitFailure) {
          showErrorMessage(state.errMessage, context);
        }
        if (state is SignupCubitSuccess) {
          showSuccessMessage('done', context);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is SignupCubitLoading,
          child: SignupViewBody(),
        );
      },
    );
  }
}
