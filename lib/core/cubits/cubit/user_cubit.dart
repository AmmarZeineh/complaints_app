import 'package:bloc/bloc.dart';
import 'package:complaints_app/feature/auth/domain/entities/user_entity.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  /// Set user data and emit UserLoaded state
  void setUser(UserEntity user) {
    emit(UserLoaded(user));
  }

  /// Clear user data and return to initial state (logout)
  void clearUser() {
    emit(UserInitial());
  }

  /// Update user profile information
  void updateUser(UserEntity updatedUser) {
    if (state is UserLoaded) {
      emit(UserLoaded(updatedUser));
    }
  }

  /// Update user name
  void updateUserName(String newName) {
    if (state is UserLoaded) {
      final currentUser = (state as UserLoaded).user;
      final updatedUser = currentUser.copyWith(name: newName);
      emit(UserLoaded(updatedUser));
    }
  }

  /// Update multiple user fields at once
  void updateUserProfile({String? name, String? preferredLanguage}) {
    if (state is UserLoaded) {
      final currentUser = (state as UserLoaded).user;
      final updatedUser = currentUser.copyWith(name: name);
      emit(UserLoaded(updatedUser));
    }
  }

  // Getters
  /// Get current user (null if not logged in)
  UserEntity? get currentUser {
    if (state is UserLoaded) {
      return (state as UserLoaded).user;
    }
    return null;
  }

  /// Check if user is logged in
  bool get isLoggedIn =>
      state is UserLoaded || state is UserLoading || state is UserError;

  /// Check if currently loading
  bool get isLoading => state is UserLoading || state is UserLoading;

  /// Check if there's an error
  bool get hasError => state is UserError || state is UserError;

  /// Get current error message
  String? get errorMessage {
    if (state is UserError) {
      return (state as UserError).errorMessage;
    }
    return null;
  }

  /// Get user name (empty string if not available)
  String get userName => currentUser?.name ?? '';

  /// Get user email (empty string if not available)
  String get userEmail => currentUser?.email ?? '';
}
