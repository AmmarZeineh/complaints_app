import 'package:complaints_app/core/errors/failure.dart';
import 'package:complaints_app/feature/complaint_view/domain/entities/complaint_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

abstract class GetComplaintsRepo {
  Future<Either<Failure, List<ComplaintEntity>>> getComplaints({
    required BuildContext context,
    required int skip,
    required int limit,
  });
  Future<Either<Failure, void>> sendIneraction({
    required BuildContext context,
   required int receiverId,
   required  List<XFile> attachmentFiles,
    required List<XFile> imageFiles,
    required int id,
  });
}
