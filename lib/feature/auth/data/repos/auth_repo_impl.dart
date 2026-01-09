import 'dart:developer';

import 'package:complaints_app/constants.dart';
import 'package:complaints_app/core/errors/failure.dart';
import 'package:complaints_app/core/helper_classes/token_manager.dart';
import 'package:complaints_app/core/services/api.dart';
import 'package:complaints_app/feature/auth/data/models/user_model.dart';
import 'package:complaints_app/feature/auth/domain/entities/user_entity.dart';
import 'package:complaints_app/feature/auth/domain/repos/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImpl implements AuthRepo {
  final Api _api;
  final TokenManager _tokenManager = TokenManager();
  AuthRepoImpl(this._api);
  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
    String fcmToken,
  ) async {
    try {
      var data = await _api.post(
        url: '$baseUrl/auth/login',
        body: {'email': email, 'password': password, 'fcmToken': fcmToken},
      );
      log(fcmToken.toString());
      UserEntity userEntity = UserModel.fromJson(data).toEntity();
      await _tokenManager.saveTokens(accessToken: userEntity.accessToken);
      return Right(userEntity);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> signup(
    String email,
    String password,
    String name,
    String nationalId,
  ) async {
    try {
      await _api.post(
        url: '$baseUrl/user',
        body: {
          'email': email,
          'password': password,
          'name': name,
          'roleId': 3,
          'nationalID': nationalId.toString(),
        },
      );
      return Right(email);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resendVerificationEmail({
    required String email,
  }) async {
    try {
      await _api.post(
        url: '$baseUrl/email-verification/send-code',
        body: {'email': email},
      );
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail({
    required String email,
    required String verificationCode,
  }) async {
    try {
      await _api.post(
        url: '$baseUrl/email-verification/verify-email',
        body: {'email': email, 'code': verificationCode},
      );
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
