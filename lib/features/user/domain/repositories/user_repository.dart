import 'package:dartz/dartz.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/user/data/models/user_model.dart';

abstract class UserRepository {
  Future<Either<Failure, UserModel>> getCurrentUser();
  Future<Either<Failure, UserModel>> upsertUser(UserModel user);
}
