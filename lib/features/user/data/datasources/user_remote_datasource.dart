import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/exceptions.dart';
import 'package:cartsync/features/user/data/models/user_model.dart';
import 'package:cartsync/service/dio_client.dart';

abstract class UserRemoteDatasource {
  Future<UserModel> getCurrentUser();
  Future<UserModel> upsertUser(UserModel user);
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final Dio dio;
  UserRemoteDatasourceImpl(this.dio);

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dio.get('/users/me');
      return UserModel.fromJson(response.data as Map<String, Object?>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<UserModel> upsertUser(UserModel user) async {
    try {
      final response = await dio.put('/users', data: user.toJson());
      return UserModel.fromJson(response.data as Map<String, Object?>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      throw ServerException(message: e.message);
    }
  }
}

final userRemoteDatasourceProvider = Provider<UserRemoteDatasource>((ref) {
  return UserRemoteDatasourceImpl(ref.watch(dioProvider));
});
