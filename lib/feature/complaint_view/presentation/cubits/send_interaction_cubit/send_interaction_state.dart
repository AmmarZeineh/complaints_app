part of 'send_interaction_cubit.dart';

@immutable
sealed class SendInteractionState {}

final class SendInteractionInitial extends SendInteractionState {}

final class SendInteractionLoading extends SendInteractionState {}

final class SendInteractionSuccess extends SendInteractionState {}

final class SendInteractionFailure extends SendInteractionState {
  final String message;

  SendInteractionFailure(this.message);

  
}
