import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:cartsync/utils/secure_storage_service.dart' show StorageService;

// ─── Read providers ───────────────────────────────────────────────────────────

final authTokenProvider = FutureProvider<String?>((ref) async {
  return StorageService.instance.readData('token');
});

final userIdProvider = FutureProvider<String?>((ref) async {
  return StorageService.instance.readData('userId');
});

final usernameProvider = FutureProvider<String?>((ref) async {
  return StorageService.instance.readData('username');
});

final familyIdProvider = FutureProvider<String?>((ref) async {
  return StorageService.instance.readData('familyId');
});

final sessionIdProvider = FutureProvider<String?>((ref) async {
  return StorageService.instance.readData('sessionId');
});

// ─── Write providers ──────────────────────────────────────────────────────────

class _TokenNotifier extends StateNotifier<void> {
  final Ref _ref;
  _TokenNotifier(this._ref) : super(null);
  Future<void> save(String value) async {
    await StorageService.instance.writeData('token', value);
    _ref.invalidate(authTokenProvider);
  }
}

final saveTokenProvider = StateNotifierProvider<_TokenNotifier, void>((ref) {
  return _TokenNotifier(ref);
});

class _UserIdNotifier extends StateNotifier<void> {
  final Ref _ref;
  _UserIdNotifier(this._ref) : super(null);
  Future<void> save(String value) async {
    await StorageService.instance.writeData('userId', value);
    _ref.invalidate(userIdProvider);
  }
}

final saveUserIdProvider =
    StateNotifierProvider<_UserIdNotifier, void>((ref) {
  return _UserIdNotifier(ref);
});

class _UsernameNotifier extends StateNotifier<void> {
  final Ref _ref;
  _UsernameNotifier(this._ref) : super(null);
  Future<void> save(String value) async {
    await StorageService.instance.writeData('username', value);
    _ref.invalidate(usernameProvider);
  }
}

final saveUsernameProvider =
    StateNotifierProvider<_UsernameNotifier, void>((ref) {
  return _UsernameNotifier(ref);
});

class _FamilyIdNotifier extends StateNotifier<void> {
  final Ref _ref;
  _FamilyIdNotifier(this._ref) : super(null);
  Future<void> save(String value) async {
    await StorageService.instance.writeData('familyId', value);
    _ref.invalidate(familyIdProvider);
  }
}

final saveFamilyIdProvider =
    StateNotifierProvider<_FamilyIdNotifier, void>((ref) {
  return _FamilyIdNotifier(ref);
});

class _SessionIdNotifier extends StateNotifier<void> {
  final Ref _ref;
  _SessionIdNotifier(this._ref) : super(null);
  Future<void> save(String value) async {
    await StorageService.instance.writeData('sessionId', value);
    _ref.invalidate(sessionIdProvider);
  }
}

final saveSessionIdProvider =
    StateNotifierProvider<_SessionIdNotifier, void>((ref) {
  return _SessionIdNotifier(ref);
});

// ─── Clear session (logout) ───────────────────────────────────────────────────

class _ClearSessionNotifier extends StateNotifier<void> {
  final Ref _ref;
  _ClearSessionNotifier(this._ref) : super(null);
  Future<void> clear() async {
    await StorageService.instance.deleteAll();
    _ref.invalidate(authTokenProvider);
    _ref.invalidate(userIdProvider);
    _ref.invalidate(usernameProvider);
    _ref.invalidate(familyIdProvider);
    _ref.invalidate(sessionIdProvider);
  }
}

final clearSessionProvider =
    StateNotifierProvider<_ClearSessionNotifier, void>((ref) {
  return _ClearSessionNotifier(ref);
});
