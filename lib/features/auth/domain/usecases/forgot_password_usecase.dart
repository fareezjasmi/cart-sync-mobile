import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/auth/data/models/forgot_password_request_model.dart';
import 'package:cartsync/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:cartsync/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUsecase {
  final AuthRepository repository;
  ForgotPasswordUsecase(this.repository);

  Future<Either<Failure, void>> call(ForgotPasswordRequestModel request) {
    return repository.forgotPassword(request);
  }
}

final forgotPasswordUsecaseProvider = Provider<ForgotPasswordUsecase>((ref) {
  return ForgotPasswordUsecase(ref.watch(authRepositoryProvider));
});
