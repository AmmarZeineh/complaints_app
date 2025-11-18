part of 'create_complaint_cubit.dart';

@immutable
sealed class CreateComplaintState {}

final class CreateComplaintInitial extends CreateComplaintState {}

final class CreateComplaintLoading extends CreateComplaintState {}

final class CreateComplaintSuccess extends CreateComplaintState {}
final class CreateComplaintFailure extends CreateComplaintState {
  final String errorMessage;
  CreateComplaintFailure(this.errorMessage);
}
