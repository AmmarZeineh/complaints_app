import 'dart:developer';

import 'package:complaints_app/constants.dart';
import 'package:complaints_app/core/cubits/cubit/user_cubit.dart';
import 'package:complaints_app/core/errors/failure.dart';
import 'package:complaints_app/core/services/api.dart';
import 'package:complaints_app/feature/complaint/data/models/government_model.dart';
import 'package:complaints_app/feature/complaint/domain/entities/government_entity.dart';
import 'package:complaints_app/feature/complaint/domain/repos/create_complaint_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreateComplaintRepoImpl implements CreateComplaintRepo {
  final Api _api;

  CreateComplaintRepoImpl(this._api);

  @override
  Future<Either<Failure, List<GovernmentEntity>>> getGovernment() async {
    try {
      var response = await _api.get(url: '$baseUrl/government?skip=0&limit=10');

      List dataList = response["data"] as List;

      List<GovernmentEntity> governments = GovernmentModel.fromJsonList(
        dataList,
      );

      return Right(governments);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createComplaint({
    required BuildContext context,
    required String type,
    required String description,
    required num governmentId,
    required List<XFile> attachmentFiles,
    required List<XFile> imageFiles,
    required String location,
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
        url: '$baseUrl/complaint',
        data: {
          'type': type,
          'description': description,
          'governmentId': governmentId,
          'images': images,
          'documents': documents,
          'Location': location,
        },
        token: context.read<UserCubit>().currentUser!.accessToken,
      );

      return Right(null);
    } catch (e) {
      log('Error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}
