import 'package:dartz/dartz.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/auth/data/models/forgot_password_request_model.dart';
import 'package:cartsync/features/auth/data/models/login_request_model.dart';
import 'package:cartsync/features/auth/data/models/login_response_model.dart';
import 'package:cartsync/features/auth/data/models/reset_password_request_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponseModel>> login(LoginRequestModel request);
  Future<Either<Failure, LoginResponseModel>> register(LoginRequestModel request);
  Future<Either<Failure, void>> forgotPassword(ForgotPasswordRequestModel request);
  Future<Either<Failure, void>> resetPassword(ResetPasswordRequestModel request);
}
