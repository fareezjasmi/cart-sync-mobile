import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/session/data/models/session_model.dart';
import 'package:cartsync/features/session/data/repositories/session_repository_impl.dart';
import 'package:cartsync/features/session/domain/repositories/session_repository.dart';

class CreateSessionUsecase {
  final SessionRepository repository;
  CreateSessionUsecase(this.repository);
  Future<Either<Failure, SessionModel>> call(SessionModel session) =>
      repository.createSession(session);
}

final createSessionUsecaseProvider = Provider<CreateSessionUsecase>((ref) {
  return CreateSessionUsecase(ref.watch(sessionRepositoryProvider));
});
