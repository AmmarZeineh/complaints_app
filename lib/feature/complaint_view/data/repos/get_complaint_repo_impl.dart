import 'dart:developer';

import 'package:complaints_app/constants.dart';
import 'package:complaints_app/core/cubits/cubit/user_cubit.dart';
import 'package:complaints_app/core/errors/failure.dart';
import 'package:complaints_app/core/services/api.dart';
import 'package:complaints_app/feature/complaint_view/data/models/complaint_model.dart';
import 'package:complaints_app/feature/complaint_view/domain/entities/complaint_entity.dart';
import 'package:complaints_app/feature/complaint_view/domain/repos/get_complaints_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetComplaintRepoImpl implements GetComplaintsRepo {
  final Api _api;

  GetComplaintRepoImpl(this._api);

  @override
  Future<Either<Failure, List<ComplaintEntity>>> getComplaints({
  required BuildContext context,
  required int skip,
  required int limit,
}) async {
  try {
    var response = await _api.get(
      url: '$baseUrl/complaint/my-complaints?skip=$skip&limit=$limit',
      token: context.read<UserCubit>().token
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
}
