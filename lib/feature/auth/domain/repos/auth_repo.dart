import 'package:complaints_app/core/errors/failure.dart';
import 'package:complaints_app/feature/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  
  Future<Either<Failure, UserEntity>> login(String email, String password);

  Future<Either<Failure, UserEntity>> signup(
    String email,
    String password,
    String name,
  );
}
