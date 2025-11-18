import 'package:complaints_app/core/errors/failure.dart';
import 'package:complaints_app/feature/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> login(BuildContext context,String email, String password,);

  Future<Either<Failure, UserEntity>> signup(
    String email,
    String password,
    String name,
  );

  Future<Either<Failure, void>> verifyEmail({
    required String email,
    required String verificationCode,
  });
  Future<Either<Failure, void>> resendVerificationEmail({
    required String email,
  });
}
