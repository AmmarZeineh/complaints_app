import 'package:bloc/bloc.dart';
import 'package:complaints_app/feature/auth/domain/repos/auth_repo.dart';
import 'package:flutter/material.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo authRepo;

  LoginCubit(this.authRepo) : super(LoginInitial());

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    emit(LoginLoading());
    final result = await authRepo.login(context, email, password);
    result.fold(
      (l) => emit(LoginFailure(l.message)),
      (r) => emit(LoginSuccess()),
    );
  }
}
