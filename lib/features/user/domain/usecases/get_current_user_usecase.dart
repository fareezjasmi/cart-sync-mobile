import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/user/data/models/user_model.dart';
import 'package:cartsync/features/user/data/repositories/user_repository_impl.dart';
import 'package:cartsync/features/user/domain/repositories/user_repository.dart';

class GetCurrentUserUsecase {
  final UserRepository repository;
  GetCurrentUserUsecase(this.repository);

  Future<Either<Failure, UserModel>> call() async {
    return repository.getCurrentUser();
  }
}

final getCurrentUserUsecaseProvider = Provider<GetCurrentUserUsecase>((ref) {
  return GetCurrentUserUsecase(ref.watch(userRepositoryProvider));
});
