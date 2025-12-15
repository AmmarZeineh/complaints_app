part of 'get_government_cubit.dart';

@immutable
sealed class GetGovernmentState {}

final class GetGovernmentInitial extends GetGovernmentState {}

final class GetGovernmentLoading extends GetGovernmentState {}

final class GetGovernmentSuccess extends GetGovernmentState {
  final List<GovernmentEntity> governments;
  GetGovernmentSuccess(this.governments);
}

final class GetGovernmentFailure extends GetGovernmentState {
  final String errorMessage;
  GetGovernmentFailure(this.errorMessage);
}
