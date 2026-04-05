import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/exceptions.dart';
import 'package:cartsync/features/auth/data/models/forgot_password_request_model.dart';
import 'package:cartsync/features/auth/data/models/login_request_model.dart';
import 'package:cartsync/features/auth/data/models/login_response_model.dart';
import 'package:cartsync/features/auth/data/models/reset_password_request_model.dart';
import 'package:cartsync/service/dio_client.dart';

abstract class AuthRemoteDatasource {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<LoginResponseModel> register(LoginRequestModel request);
  Future<void> forgotPassword(ForgotPasswordRequestModel request);
  Future<void> resetPassword(ResetPasswordRequestModel request);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasourceImpl(this.dio);

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: request.toJson(),
      );
      return LoginResponseModel.fromJson(response.data as Map<String, Object?>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<LoginResponseModel> register(LoginRequestModel request) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: request.toJson(),
      );
      return LoginResponseModel.fromJson(response.data as Map<String, Object?>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      if (e.response?.statusCode == 409) {
        throw ServerException(message: 'Username already exists');
      }
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<void> forgotPassword(ForgotPasswordRequestModel request) async {
    try {
      await dio.post(
        '/auth/forgot-password',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<void> resetPassword(ResetPasswordRequestModel request) async {
    try {
      await dio.post(
        '/auth/reset-password',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 410) {
        throw ServerException(message: 'OTP has expired. Please request a new one.');
      }
      if (e.response?.statusCode == 400) {
        throw ServerException(message: 'Invalid OTP or email. Please try again.');
      }
      throw ServerException(message: e.message);
    }
  }
}

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasourceImpl(ref.watch(dioProvider));
});
