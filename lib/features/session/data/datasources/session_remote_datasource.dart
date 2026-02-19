import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/exceptions.dart';
import 'package:cartsync/features/session/data/models/session_model.dart';
import 'package:cartsync/features/session/data/models/update_session_status_model.dart';
import 'package:cartsync/service/dio_client.dart';

abstract class SessionRemoteDatasource {
  Future<SessionModel> createSession(SessionModel session);
  Future<SessionModel> getSession(String sessionId);
  Future<List<SessionModel>> getAllSession(String familyId);
  Future<SessionModel> updateSessionStatus(String sessionId, String status);
}

class SessionRemoteDatasourceImpl implements SessionRemoteDatasource {
  final Dio dio;
  SessionRemoteDatasourceImpl(this.dio);

  @override
  Future<SessionModel> createSession(SessionModel session) async {
    try {
      final response = await dio.post('/session/create', data: session.toJson());
      return SessionModel.fromJson(response.data as Map<String, Object?>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<SessionModel> getSession(String sessionId) async {
    try {
      final response = await dio.get('/session/$sessionId');
      return SessionModel.fromJson(response.data as Map<String, Object?>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      if (e.response?.statusCode == 404) throw ServerException(message: 'Session not found');
      throw ServerException(message: e.message);
    }
  }

    @override
  Future<List<SessionModel>> getAllSession(String familyId) async {
    try {
      final response = await dio.get('/session/getAll/$familyId');
      final list = response.data as List;
      return list
          .map((e) => SessionModel.fromJson(e as Map<String, Object?>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      if (e.response?.statusCode == 404) throw ServerException(message: 'Session not found');
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<SessionModel> updateSessionStatus(
      String sessionId, String status) async {
    try {
      final request = UpdateSessionStatusModel(sessionId: sessionId, status: status);
      final response = await dio.put('/session/updateStatus', data: request.toJson());
      return SessionModel.fromJson(response.data as Map<String, Object?>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      throw ServerException(message: e.message);
    }
  }
}

final sessionRemoteDatasourceProvider = Provider<SessionRemoteDatasource>((ref) {
  return SessionRemoteDatasourceImpl(ref.watch(dioProvider));
});
