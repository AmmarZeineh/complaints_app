import 'dart:developer';

import 'package:complaints_app/constants.dart';
import 'package:complaints_app/core/errors/failure.dart';
import 'package:complaints_app/core/services/api.dart';
import 'package:complaints_app/feature/complaint_view/data/models/complaint/complaint_model.dart';
import 'package:complaints_app/feature/complaint_view/domain/entities/complaint_entity.dart';
import 'package:complaints_app/feature/complaint_view/domain/repos/get_complaints_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class GetComplaintRepoImpl implements GetComplaintsRepo {
  final Api _api;

  GetComplaintRepoImpl(this._api);

  @override
  Future<Either<Failure, List<ComplaintEntity>>> getComplaints({
    required int skip,
    required int limit,
  }) async {
    try {
      var response = await _api.get(
        url: '$baseUrl/complaint/my-complaints?skip=$skip&limit=$limit',
      );

      log(response.toString());

      // استخرج الـ data array من الـ response
      final List<dynamic> dataList = response['data'] as List<dynamic>;

      // حول كل عنصر لـ ComplaintModel ثم لـ Entity
      final complaints = dataList
          .map((e) => ComplaintModel.fromJson(e).toEntity())
          .toList();

      return Right(complaints);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendIneraction({
    required int id,
    required int receiverId,
    required List<XFile> attachmentFiles,
    required List<XFile> imageFiles,
  }) async {
    try {
      log('Images: ${imageFiles.length}, Documents: ${attachmentFiles.length}');

      List<MultipartFile> images = [];
      for (var img in imageFiles) {
        images.add(await MultipartFile.fromFile(img.path, filename: img.name));
      }

      List<MultipartFile> documents = [];
      for (var doc in attachmentFiles) {
        documents.add(
          await MultipartFile.fromFile(doc.path, filename: doc.name),
        );
      }

      await _api.postFormData(
        url: '$baseUrl/complaint/interaction',
        data: {
          'complaintId': id,
          'receiverId': receiverId,
          'message': "message",
          'type': "CITIZEN_RESPONSE",
          'images': images,
          'documents': documents,
        },
      );

      return Right(null);
    } catch (e) {
      log('Error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComplaint({required int id}) async {
    try {
      await _api.delete(url: '$baseUrl/complaint/$id');
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
