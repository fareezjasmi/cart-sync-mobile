import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/session/data/models/session_model.dart';
import 'package:cartsync/features/session/data/repositories/session_repository_impl.dart';
import 'package:cartsync/features/session/domain/repositories/session_repository.dart';

class GetSessionUsecase {
  final SessionRepository repository;
  GetSessionUsecase(this.repository);
  Future<Either<Failure, SessionModel>> call(String sessionId) =>
      repository.getSession(sessionId);
}

final getSessionUsecaseProvider = Provider<GetSessionUsecase>((ref) {
  return GetSessionUsecase(ref.watch(sessionRepositoryProvider));
});
