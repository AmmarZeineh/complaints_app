part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserLoaded extends UserState {
  final String userName;
  UserLoaded(this.userName);
}

final class UserError extends UserState {
  final String errorMessage;
  UserError(this.errorMessage);
}
