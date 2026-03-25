import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/session/data/repositories/session_repository_impl.dart';
import 'package:cartsync/features/session/domain/repositories/session_repository.dart';

class DeleteSessionUsecase {
  final SessionRepository repository;
  DeleteSessionUsecase(this.repository);
  Future<Either<Failure, Map<String, dynamic>>> call(String sessionId) => repository.deleteSession(sessionId);
}

final deleteSessionUsecaseProvider = Provider<DeleteSessionUsecase>((ref) {
  return DeleteSessionUsecase(ref.watch(sessionRepositoryProvider));
});
