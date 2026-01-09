import 'package:bloc/bloc.dart';
import 'package:complaints_app/feature/notification/domain/entities/notification_entity.dart';
import 'package:complaints_app/feature/notification/domain/repos/notification_repo.dart';
import 'package:meta/meta.dart';

part 'fetch_notification_state.dart';

class FetchNotificationCubit extends Cubit<FetchNotificationState> {
  FetchNotificationCubit(this._notificationRepo)
    : super(FetchNotificationInitial());

  final NotificationRepo _notificationRepo;

  bool get hasRedDot {
    final currentState = state;
    if (currentState is FetchNotificationSuccess) {
      return currentState.hasUnreadNotifications;
    }
    return false;
  }

  Future<void> fetchNotifications() async {
    emit(FetchNotificationLoading());
    final result = await _notificationRepo.getNotifications();
    result.fold((failure) => emit(FetchNotificationFailure(failure.message)), (
      notifications,
    ) {
      // التحقق من وجود notifications غير مقروءة
      bool hasUnread = notifications.any(
        (notification) => !notification.isRead!,
      );
      emit(
        FetchNotificationSuccess(
          notifications,
          hasUnreadNotifications: hasUnread,
        ),
      );
    });
  }
}
