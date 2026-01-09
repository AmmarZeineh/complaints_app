import 'package:complaints_app/core/cubits/cubit/user_cubit.dart';
import 'package:complaints_app/core/helper_functions/snack_bars.dart';
import 'package:complaints_app/core/services/get_it_service.dart';
import 'package:complaints_app/feature/auth/domain/repos/auth_repo.dart';
import 'package:complaints_app/feature/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:complaints_app/feature/auth/presentation/views/widgets/login_view_body.dart';
import 'package:complaints_app/feature/complaint_view/presentation/views/complaints_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  static const routeName = 'login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => LoginCubit(getIt.get<AuthRepo>()),
          child: LoginViewConsumer(),
        ),
      ),
    );
  }
}

class LoginViewConsumer extends StatelessWidget {
  const LoginViewConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          showErrorMessage(state.errMessage, context);
        } else if (state is LoginSuccess) {
          context.read<UserCubit>().setUser(state.userEntity);
          Navigator.pushNamed(context, ComplaintsView.routeName);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is LoginLoading,
          child: LoginViewBody(),
        );
      },
    );
  }
}
