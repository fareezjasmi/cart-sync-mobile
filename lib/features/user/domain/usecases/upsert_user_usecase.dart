import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/user/data/models/user_model.dart';
import 'package:cartsync/features/user/data/repositories/user_repository_impl.dart';
import 'package:cartsync/features/user/domain/repositories/user_repository.dart';

class UpsertUserUsecase {
  final UserRepository repository;
  UpsertUserUsecase(this.repository);

  Future<Either<Failure, UserModel>> call(UserModel user) async {
    return repository.upsertUser(user);
  }
}

final upsertUserUsecaseProvider = Provider<UpsertUserUsecase>((ref) {
  return UpsertUserUsecase(ref.watch(userRepositoryProvider));
});
