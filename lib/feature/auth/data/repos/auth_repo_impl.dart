import 'package:complaints_app/constants.dart';
import 'package:complaints_app/core/errors/failure.dart';
import 'package:complaints_app/core/services/api.dart';
import 'package:complaints_app/core/services/backend_endpoints.dart';
import 'package:complaints_app/feature/auth/data/models/user_model.dart';
import 'package:complaints_app/feature/auth/domain/entities/user_entity.dart';
import 'package:complaints_app/feature/auth/domain/repos/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImpl implements AuthRepo {
  final Api _api;
  AuthRepoImpl(this._api);
  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> signup(
    String email,
    String password,
    String name,
  ) async {
    try {
      var data = await _api.post(
        url: '$baseUrl/${BackendEndpoints.createUser}',
        body: {'email': email, 'password': password, 'name': name, 'roleId': 3},
      );
      UserModel userModel = UserModel.fromJson(data);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
