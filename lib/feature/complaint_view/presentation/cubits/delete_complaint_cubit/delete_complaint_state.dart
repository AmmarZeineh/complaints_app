part of 'delete_complaint_cubit.dart';

@immutable
sealed class DeleteComplaintState {}

final class DeleteComplaintInitial extends DeleteComplaintState {}

final class DeleteComplaintLoading extends DeleteComplaintState {}

final class DeleteComplaintFailure extends DeleteComplaintState {
  final String errorMessage;

  DeleteComplaintFailure(this.errorMessage);
}

final class DeleteComplaintSuccess extends DeleteComplaintState {}
