import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:cartsync/features/user/data/models/user_model.dart';
import 'package:cartsync/features/user/domain/usecases/get_current_user_usecase.dart';
import 'package:cartsync/features/user/domain/usecases/upsert_user_usecase.dart';
import 'package:cartsync/features/user/presentation/models/user_page_model.dart';

class UserNotifier extends StateNotifier<UserPageModel> {
  final Ref ref;
  final GetCurrentUserUsecase getCurrentUserUsecase;
  final UpsertUserUsecase upsertUserUsecase;

  UserNotifier(this.ref, this.getCurrentUserUsecase, this.upsertUserUsecase)
      : super(UserPageInitial());

  Future<void> loadCurrentUser() async {
    state = state.copyWith(isLoading: true);
    final result = await getCurrentUserUsecase();
    result.fold(
      (failure) => state =
          state.copyWith(isLoading: false, errorMessage: failure.errorMessage),
      (user) => state = state.copyWith(isLoading: false, user: user),
    );
  }

  Future<bool> updateUser({String? name, String? status}) async {
    state = state.copyWith(isLoading: true);
    final currentUser = state.user ?? const UserModel();
    final updated = currentUser.copyWith(
      name: name ?? currentUser.name,
      status: status ?? currentUser.status,
    );
    final result = await upsertUserUsecase(updated);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage);
        return false;
      },
      (user) {
        state = state.copyWith(isLoading: false, user: user);
        return true;
      },
    );
  }
}

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, UserPageModel>((ref) {
  return UserNotifier(
    ref,
    ref.watch(getCurrentUserUsecaseProvider),
    ref.watch(upsertUserUsecaseProvider),
  );
});
