import 'package:complaints_app/core/errors/failure.dart';
import 'package:complaints_app/feature/complaint_view/domain/entities/complaint_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

abstract class GetComplaintsRepo {
  Future<Either<Failure, List<ComplaintEntity>>> getComplaints({
    required BuildContext context,
    required int skip,
    required int limit,
  });
}
