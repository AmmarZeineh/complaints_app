import 'package:complaints_app/core/errors/failure.dart';
import 'package:complaints_app/feature/complaint/domain/entities/government_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

abstract class CreateComplaintRepo {
  Future<Either<Failure, List<GovernmentEntity>>> getGovernment();
  Future<Either<Failure, void>> createComplaint({
    required BuildContext context,
    required String type,
    required String description,

    required num governmentId,
        required String location,

    String imagePath,
  });
}
