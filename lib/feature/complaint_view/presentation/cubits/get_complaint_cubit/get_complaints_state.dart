part of 'get_complaints_cubit.dart';

@immutable
sealed class GetComplaintsState {}

final class GetComplaintsInitial extends GetComplaintsState {}

final class GetComplaintsLoading extends GetComplaintsState {}

final class GetComplaintsSuccess extends GetComplaintsState {
  final List<ComplaintEntity> complaints;
  GetComplaintsSuccess(this.complaints);
}

final class GetComplaintsError extends GetComplaintsState {
  final String errMessage;
  GetComplaintsError(this.errMessage);
}
