import 'package:bloc/bloc.dart';
import 'package:complaints_app/feature/complaint/domain/repos/create_complaint_repo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'create_complaint_state.dart';

class CreateComplaintCubit extends Cubit<CreateComplaintState> {
  CreateComplaintCubit(this.complaintRepo) : super(CreateComplaintInitial());
  final CreateComplaintRepo complaintRepo;
  // في ملف create_complaint_cubit.dart
  // قم بتحديث دالة createComplaint لتكون كالتالي:

  Future<void> createComplaint({
    required String type,
    required String description,
    required int governmentId,
    required List<XFile> imageFiles,
    required List<XFile> attachmentFiles,
    required String location,
  }) async {
    emit(CreateComplaintLoading());

    try {
      // هنا يتم استدعاء الـ Repository مع البيانات الجديدة
      final result = await complaintRepo.createComplaint(
        type: type,
        description: description,
        governmentId: governmentId,
        imageFiles: imageFiles,
        attachmentFiles: attachmentFiles,
        location: location,
      );

      result.fold(
        (failure) {
          emit(CreateComplaintFailure(failure.message));
        },
        (success) {
          emit(CreateComplaintSuccess());
        },
      );
    } catch (e) {
      emit(CreateComplaintFailure(e.toString()));
    }
  }
}
