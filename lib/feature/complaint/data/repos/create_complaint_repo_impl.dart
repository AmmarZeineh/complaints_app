import 'package:complaints_app/constants.dart';
import 'package:complaints_app/core/errors/failure.dart';
import 'package:complaints_app/core/services/api.dart';
import 'package:complaints_app/feature/complaint/data/models/government_model.dart';
import 'package:complaints_app/feature/complaint/domain/entities/government_entity.dart';
import 'package:complaints_app/feature/complaint/domain/repos/create_complaint_repo.dart';
import 'package:dartz/dartz.dart';

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
    required String type,
    required String description,
    required num governmentId,
    String imagePath = '',
  }) async {
    try {
      await _api.post(
        url: '$baseUrl/complaint',
        body: {
          'type': type,
          'description': description,
          'governmentId': governmentId,
          'imagePath': imagePath,
        },
        // token:
            
      );

      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
