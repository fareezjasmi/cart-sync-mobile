import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/item/data/repositories/item_repository_impl.dart';
import 'package:cartsync/features/item/domain/repositories/item_repository.dart';

class DeleteItemUsecase {
  final ItemRepository repository;
  DeleteItemUsecase(this.repository);
  Future<Either<Failure, void>> call(String itemId) =>
      repository.deleteItem(itemId);
}

final deleteItemUsecaseProvider = Provider<DeleteItemUsecase>((ref) {
  return DeleteItemUsecase(ref.watch(itemRepositoryProvider));
});
