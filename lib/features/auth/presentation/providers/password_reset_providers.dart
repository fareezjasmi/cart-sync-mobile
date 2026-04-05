import 'package:flutter_riverpod/legacy.dart';
import 'package:cartsync/features/auth/data/models/forgot_password_request_model.dart';
import 'package:cartsync/features/auth/data/models/reset_password_request_model.dart';
import 'package:cartsync/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:cartsync/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:cartsync/features/auth/presentation/models/password_reset_page_model.dart';

class PasswordResetNotifier extends StateNotifier<PasswordResetPageModel> {
  final ForgotPasswordUsecase forgotPasswordUsecase;
  final ResetPasswordUsecase resetPasswordUsecase;

  PasswordResetNotifier(this.forgotPasswordUsecase, this.resetPasswordUsecase)
      : super(const PasswordResetPageModel());

  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true);
    final request = ForgotPasswordRequestModel(email: email);
    final result = await forgotPasswordUsecase(request);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage);
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false);
        return true;
      },
    );
  }

  Future<bool> resetPassword(String email, String otp, String newPassword) async {
    state = state.copyWith(isLoading: true);
    final request = ResetPasswordRequestModel(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
    final result = await resetPasswordUsecase(request);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage);
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false, isSuccess: true);
        return true;
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void reset() {
    state = const PasswordResetPageModel();
  }
}

final passwordResetNotifierProvider =
    StateNotifierProvider<PasswordResetNotifier, PasswordResetPageModel>((ref) {
  return PasswordResetNotifier(
    ref.watch(forgotPasswordUsecaseProvider),
    ref.watch(resetPasswordUsecaseProvider),
  );
});
