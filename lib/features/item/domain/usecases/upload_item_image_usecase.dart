import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/item/data/repositories/item_repository_impl.dart';
import 'package:cartsync/features/item/domain/repositories/item_repository.dart';

class UploadItemImageUsecase {
  final ItemRepository repository;
  UploadItemImageUsecase(this.repository);
  Future<Either<Failure, Map<String, dynamic>>> call(File file) => repository.uploadItemImage(file);
}

final uploadItemImageUsecaseProvider = Provider<UploadItemImageUsecase>((ref) {
  return UploadItemImageUsecase(ref.watch(itemRepositoryProvider));
});
