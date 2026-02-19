import 'package:dartz/dartz.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/session/data/models/session_model.dart';

abstract class SessionRepository {
  Future<Either<Failure, SessionModel>> createSession(SessionModel session);
  Future<Either<Failure, SessionModel>> getSession(String sessionId);
  Future<Either<Failure, List<SessionModel>>> getAllSession(String familyId);
  Future<Either<Failure, SessionModel>> updateSessionStatus(
      String sessionId, String status);
}
