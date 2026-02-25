import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/item/data/models/item_model.dart';

abstract class ItemRepository {
  Future<Either<Failure, ItemModel>> createItem(ItemModel item);
  Future<Either<Failure, ItemModel>> getItem(String itemId);
  Future<Either<Failure, ItemModel>> updateItem(ItemModel item);
  Future<Either<Failure, List<ItemModel>>> getAllItems(String checklistId);
  Future<Either<Failure, List<ItemModel>>> createBulkItems(List<ItemModel> items);
  Future<Either<Failure, void>> deleteItem(String itemId);
  Future<Either<Failure, Map<String, dynamic>>> uploadItemImage(File file);
}
