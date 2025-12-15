import 'package:bloc/bloc.dart';
import 'package:complaints_app/feature/complaint_view/domain/entities/complaint_entity.dart';
import 'package:complaints_app/feature/complaint_view/domain/repos/get_complaints_repo.dart';
import 'package:flutter/material.dart';

part 'get_complaints_state.dart';

class GetComplaintsCubit extends Cubit<GetComplaintsState> {
  GetComplaintsCubit(this.getComplaintsRepo) : super(GetComplaintsInitial());
  final GetComplaintsRepo getComplaintsRepo;

  Future<void> getComplaints({
    required int skip,
    required int limit,
    required BuildContext context,
  }) async {
    emit(GetComplaintsLoading());
    final result = await getComplaintsRepo.getComplaints(
      skip: skip,
      limit: limit,
      context: context,
    );
    result.fold(
      (l) => emit(GetComplaintsError(l.message)),
      (r) => emit(GetComplaintsSuccess(r)),
    );
  }
}
