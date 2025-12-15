import 'package:bloc/bloc.dart';
import 'package:complaints_app/feature/complaint_view/domain/repos/get_complaints_repo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'send_interaction_state.dart';

class SendInteractionCubit extends Cubit<SendInteractionState> {
  SendInteractionCubit(this.getComplaintRepo) : super(SendInteractionInitial());
  final GetComplaintsRepo getComplaintRepo;

  Future<void> sendInteraction({
    required BuildContext context,
    required int id,
    required int reciverId,
    required List<XFile> images,
    required List<XFile> files,
  }) async {

    emit(SendInteractionLoading());
    final result = await getComplaintRepo.sendIneraction(
      context: context,
      id: id,
      receiverId: reciverId,
      imageFiles: images,
      attachmentFiles: files,
    );
    result.fold(
      (l) => emit(SendInteractionFailure(l.message)),
      (r) => emit(SendInteractionSuccess()),
    );
    
  }
}
