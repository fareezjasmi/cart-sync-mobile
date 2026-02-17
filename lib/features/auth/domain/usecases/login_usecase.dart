import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/auth/data/models/login_request_model.dart';
import 'package:cartsync/features/auth/data/models/login_response_model.dart';
import 'package:cartsync/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:cartsync/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;
  LoginUsecase(this.repository);

  Future<Either<Failure, LoginResponseModel>> call(
      LoginRequestModel request) async {
    return repository.login(request);
  }
}

final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  return LoginUsecase(ref.watch(authRepositoryProvider));
});
