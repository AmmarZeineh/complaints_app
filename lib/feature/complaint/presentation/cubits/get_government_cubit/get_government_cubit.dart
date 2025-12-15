import 'package:bloc/bloc.dart';
import 'package:complaints_app/feature/complaint/domain/entities/government_entity.dart';
import 'package:complaints_app/feature/complaint/domain/repos/create_complaint_repo.dart';
import 'package:meta/meta.dart';

part 'get_government_state.dart';

class GetGovernmentCubit extends Cubit<GetGovernmentState> {
  GetGovernmentCubit(this.complaintRepo) : super(GetGovernmentInitial());
  final CreateComplaintRepo complaintRepo;

  Future<void> getGovernment() async {
    emit(GetGovernmentLoading());
    final result = await complaintRepo.getGovernment();
    result.fold(
      (l) => emit(GetGovernmentFailure(l.message)),
      (r) => emit(GetGovernmentSuccess(r)),
    );
  }
}
