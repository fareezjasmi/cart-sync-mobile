import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/item/data/models/item_model.dart';
import 'package:cartsync/features/item/data/repositories/item_repository_impl.dart';
import 'package:cartsync/features/item/domain/repositories/item_repository.dart';

class GetAllItemsUsecase {
  final ItemRepository repository;
  GetAllItemsUsecase(this.repository);
  Future<Either<Failure, List<ItemModel>>> call(String checklistId) =>
      repository.getAllItems(checklistId);
}

final getAllItemsUsecaseProvider = Provider<GetAllItemsUsecase>((ref) {
  return GetAllItemsUsecase(ref.watch(itemRepositoryProvider));
});
