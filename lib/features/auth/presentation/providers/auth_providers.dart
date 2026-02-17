import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:cartsync/features/auth/data/models/login_request_model.dart';
import 'package:cartsync/features/auth/domain/usecases/login_usecase.dart';
import 'package:cartsync/features/auth/domain/usecases/register_usecase.dart';
import 'package:cartsync/features/auth/presentation/models/auth_page_model.dart';
import 'package:cartsync/shared/providers/app_config_providers.dart';

class AuthNotifier extends StateNotifier<AuthPageModel> {
  final Ref ref;
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;

  AuthNotifier(this.ref, this.loginUsecase, this.registerUsecase)
      : super(AuthPageInitial());

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true);
    final request = LoginRequestModel(username: username, password: password);
    final result = await loginUsecase(request);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage);
        return false;
      },
      (response) async {
        await ref.read(saveTokenProvider.notifier).save(response.token);
        await ref.read(saveUserIdProvider.notifier).save(response.userId);
        await ref.read(saveUsernameProvider.notifier).save(response.username);
        state = state.copyWith(isLoading: false);
        return true;
      },
    );
  }

  Future<bool> register(String username, String password) async {
    state = state.copyWith(isLoading: true);
    final request = LoginRequestModel(username: username, password: password);
    final result = await registerUsecase(request);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage);
        return false;
      },
      (response) async {
        await ref.read(saveTokenProvider.notifier).save(response.token);
        await ref.read(saveUserIdProvider.notifier).save(response.userId);
        await ref.read(saveUsernameProvider.notifier).save(response.username);
        state = state.copyWith(isLoading: false);
        return true;
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthPageModel>((ref) {
  return AuthNotifier(
    ref,
    ref.watch(loginUsecaseProvider),
    ref.watch(registerUsecaseProvider),
  );
});
