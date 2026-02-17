import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/item/data/models/item_model.dart';
import 'package:cartsync/features/item/data/repositories/item_repository_impl.dart';
import 'package:cartsync/features/item/domain/repositories/item_repository.dart';

class UpdateItemUsecase {
  final ItemRepository repository;
  UpdateItemUsecase(this.repository);
  Future<Either<Failure, ItemModel>> call(ItemModel item) =>
      repository.updateItem(item);
}

final updateItemUsecaseProvider = Provider<UpdateItemUsecase>((ref) {
  return UpdateItemUsecase(ref.watch(itemRepositoryProvider));
});
