import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/auth/data/models/reset_password_request_model.dart';
import 'package:cartsync/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:cartsync/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUsecase {
  final AuthRepository repository;
  ResetPasswordUsecase(this.repository);

  Future<Either<Failure, void>> call(ResetPasswordRequestModel request) {
    return repository.resetPassword(request);
  }
}

final resetPasswordUsecaseProvider = Provider<ResetPasswordUsecase>((ref) {
  return ResetPasswordUsecase(ref.watch(authRepositoryProvider));
});
