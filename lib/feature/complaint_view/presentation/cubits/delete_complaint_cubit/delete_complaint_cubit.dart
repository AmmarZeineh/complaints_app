import 'package:bloc/bloc.dart';
import 'package:complaints_app/feature/complaint_view/domain/repos/get_complaints_repo.dart';
import 'package:meta/meta.dart';

part 'delete_complaint_state.dart';

class DeleteComplaintCubit extends Cubit<DeleteComplaintState> {
  DeleteComplaintCubit(this.complaintRepo) : super(DeleteComplaintInitial());
  final GetComplaintsRepo complaintRepo;

  Future<void> deleteComplaint({required int id}) async {
    emit(DeleteComplaintLoading());
    final result = await complaintRepo.deleteComplaint(id: id);
    result.fold(
      (failure) {
        emit(DeleteComplaintFailure(failure.toString()));
      },
      (_) {
        emit(DeleteComplaintSuccess());
      },
    );
  }
}
