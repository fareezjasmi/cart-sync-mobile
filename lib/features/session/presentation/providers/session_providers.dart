import 'package:cartsync/features/session/domain/usecases/get_all_session_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:cartsync/features/session/data/models/session_model.dart';
import 'package:cartsync/features/session/domain/usecases/create_session_usecase.dart';
import 'package:cartsync/features/session/domain/usecases/get_session_usecase.dart';
import 'package:cartsync/features/session/domain/usecases/update_session_status_usecase.dart';
import 'package:cartsync/features/session/presentation/models/session_page_model.dart';
import 'package:cartsync/shared/providers/app_config_providers.dart';

class SessionNotifier extends StateNotifier<SessionPageModel> {
  final Ref ref;
  final CreateSessionUsecase createSessionUsecase;
  final GetSessionUsecase getSessionUsecase;
  final GetAllSessionUsecase getAllSessionUsecase;
  final UpdateSessionStatusUsecase updateSessionStatusUsecase;

  SessionNotifier(
    this.ref,
    this.createSessionUsecase,
    this.getSessionUsecase,
    this.getAllSessionUsecase,
    this.updateSessionStatusUsecase,
  ) : super(SessionPageInitial());

  Future<bool> createSession({
    required String familyId,
    required String name,
    String? location,
    String? shopperUserId,
  }) async {
    state = state.copyWith(isLoading: true);
    final session = SessionModel(
      familyId: familyId,
      name: name,
      location: location,
      sessionStatus: 'ACTIVE',
      shopperUserId: shopperUserId,
    );
    final result = await createSessionUsecase(session);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage);
        return false;
      },
      (s) async {
        if (s.sessionId != null) {
          await ref.read(saveSessionIdProvider.notifier).save(s.sessionId!);
        }
        state = state.copyWith(isLoading: false, currentSession: s);
        return true;
      },
    );
  }

  Future<void> loadSession(String sessionId) async {
    state = state.copyWith(isLoading: true);
    final result = await getSessionUsecase(sessionId);
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage),
      (session) => state = state.copyWith(isLoading: false, currentSession: session),
    );
  }

  Future<bool> updateStatus(String sessionId, String status) async {
    state = state.copyWith(isLoading: true);
    final result = await updateSessionStatusUsecase(sessionId, status);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage);
        return false;
      },
      (session) {
        state = state.copyWith(isLoading: false, currentSession: session);
        return true;
      },
    );
  }

  void updateActiveUser(List<SessionActiveUser> activeUser) {
    state = state.copyWith(activeUser: activeUser);
  }

  Future<void> loadAllSessions(String familyId) async {
    state = state.copyWith(isLoading: true);
    final result = await getAllSessionUsecase(familyId);
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage),
      (session) => state = state.copyWith(isLoading: false, allSession: session),
    );
  }
}

final sessionNotifierProvider = StateNotifierProvider<SessionNotifier, SessionPageModel>((ref) {
  return SessionNotifier(
    ref,
    ref.watch(createSessionUsecaseProvider),
    ref.watch(getSessionUsecaseProvider),
    ref.watch(getAllSessionUsecaseProvider),
    ref.watch(updateSessionStatusUsecaseProvider),
  );
});
