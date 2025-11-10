import 'package:complaints_app/core/services/api.dart';
import 'package:complaints_app/feature/auth/data/repos/auth_repo_impl.dart';
import 'package:complaints_app/feature/auth/domain/repos/auth_repo.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  // Core Services
  getIt.registerSingleton<Api>(Api());
  getIt.registerSingleton<AuthRepo>(AuthRepoImpl(getIt.get<Api>()));
}
