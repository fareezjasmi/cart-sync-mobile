
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/session/data/models/session_model.dart';
import 'package:cartsync/features/session/data/repositories/session_repository_impl.dart';
import 'package:cartsync/features/session/domain/repositories/session_repository.dart';

class GetAllSessionUsecase {
  final SessionRepository repository;
  GetAllSessionUsecase(this.repository);
  Future<Either<Failure, List<SessionModel>>> call(String sessionId) =>
      repository.getAllSession(sessionId);
}

final getAllSessionUsecaseProvider = Provider<GetAllSessionUsecase>((ref) {
  return GetAllSessionUsecase(ref.watch(sessionRepositoryProvider));
});
