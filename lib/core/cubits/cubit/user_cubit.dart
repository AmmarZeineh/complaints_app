import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());
  late String token;

  void setToken(data) {
    token = data;
    log(token);
  }

  String getToken() {
    return token;
  }
}
