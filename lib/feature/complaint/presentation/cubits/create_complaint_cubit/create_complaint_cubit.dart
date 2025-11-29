import 'package:bloc/bloc.dart';
import 'package:complaints_app/feature/complaint/domain/repos/create_complaint_repo.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'create_complaint_state.dart';

class CreateComplaintCubit extends Cubit<CreateComplaintState> {
  CreateComplaintCubit(this.complaintRepo) : super(CreateComplaintInitial());
  final CreateComplaintRepo complaintRepo;
  Future<void> createComplaint({
    required BuildContext context,
    required String type,
    required String description,

    required num governmentId,
    required String location,
    String imagePath = '',
  }) async {
    emit(CreateComplaintLoading());
    final result = await complaintRepo.createComplaint(
      context: context,
      type: type,
      description: description,
      location: location,

      governmentId: governmentId,
      imagePath: imagePath,
    );
    result.fold(
      (l) => emit(CreateComplaintFailure(l.message)),
      (r) => emit(CreateComplaintSuccess()),
    );
  }
}
