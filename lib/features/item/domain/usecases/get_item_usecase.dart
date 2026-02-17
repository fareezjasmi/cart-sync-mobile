import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/item/data/models/item_model.dart';
import 'package:cartsync/features/item/data/repositories/item_repository_impl.dart';
import 'package:cartsync/features/item/domain/repositories/item_repository.dart';

class GetItemUsecase {
  final ItemRepository repository;
  GetItemUsecase(this.repository);
  Future<Either<Failure, ItemModel>> call(String itemId) =>
      repository.getItem(itemId);
}

final getItemUsecaseProvider = Provider<GetItemUsecase>((ref) {
  return GetItemUsecase(ref.watch(itemRepositoryProvider));
});
