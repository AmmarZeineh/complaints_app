part of 'signup_cubit_cubit.dart';

@immutable
sealed class SignupCubitState {}

final class SignupCubitInitial extends SignupCubitState {}

final class SignupCubitLoading extends SignupCubitState {}

final class SignupCubitFailure extends SignupCubitState {
  final String errMessage;

  SignupCubitFailure(this.errMessage);
}

final class SignupCubitSuccess extends SignupCubitState {}
