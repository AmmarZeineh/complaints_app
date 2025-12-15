import 'package:complaints_app/core/services/api.dart';
import 'package:complaints_app/feature/auth/data/repos/auth_repo_impl.dart';
import 'package:complaints_app/feature/auth/domain/repos/auth_repo.dart';
import 'package:complaints_app/feature/complaint/data/repos/create_complaint_repo_impl.dart';
import 'package:complaints_app/feature/complaint/domain/repos/create_complaint_repo.dart';
import 'package:complaints_app/feature/complaint_view/data/repos/get_complaint_repo_impl.dart';
import 'package:complaints_app/feature/complaint_view/domain/repos/get_complaints_repo.dart';
import 'package:complaints_app/feature/notification/data/repos/notification_repo_impl.dart';
import 'package:complaints_app/feature/notification/domain/repos/notification_repo.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  // Core Services
  getIt.registerSingleton<Api>(Api());
  getIt.registerSingleton<AuthRepo>(AuthRepoImpl(getIt.get<Api>()));
  getIt.registerSingleton<CreateComplaintRepo>(
    CreateComplaintRepoImpl(getIt.get<Api>()),
  );
  getIt.registerSingleton<GetComplaintsRepo>(
    GetComplaintRepoImpl(getIt.get<Api>()),
  );
  getIt.registerSingleton<NotificationRepo>(
    NotificationRepoImpl(getIt.get<Api>()),
  );
}
