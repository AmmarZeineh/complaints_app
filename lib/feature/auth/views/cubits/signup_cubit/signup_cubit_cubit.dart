import 'package:bloc/bloc.dart';
import 'package:complaints_app/feature/auth/domain/repos/auth_repo.dart';
import 'package:meta/meta.dart';

part 'signup_cubit_state.dart';

class SignupCubitCubit extends Cubit<SignupCubitState> {
  SignupCubitCubit(this._authRepo) : super(SignupCubitInitial());
  final AuthRepo _authRepo;
  String email = '';

  Future<void> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(SignupCubitLoading());
    var result = await _authRepo.signup(email, password, name);
    result.fold((l) => emit(SignupCubitFailure(l.message)), (r) {
      this.email = email;
      emit(SignupCubitSuccess());
    });
  }
}
