import 'package:bloc/bloc.dart';
import 'package:complaints_app/feature/auth/domain/repos/auth_repo.dart';
import 'package:complaints_app/feature/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:flutter/material.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo authRepo;

  LoginCubit(this.authRepo) : super(LoginInitial());

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
    required String fcmToken,
  }) async {
    emit(LoginLoading());
    final result = await authRepo.login(context, email, password, fcmToken);
    result.fold(
      (l) => emit(LoginFailure(l.message)),
      (r) => emit(LoginSuccess()),
    );
  }
}
