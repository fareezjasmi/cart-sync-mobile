import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/exceptions.dart';
import 'package:cartsync/core/errors/failure.dart';
import 'package:cartsync/features/item/data/datasources/item_remote_datasource.dart';
import 'package:cartsync/features/item/data/models/item_model.dart';
import 'package:cartsync/features/item/domain/repositories/item_repository.dart';

class ItemRepositoryImpl implements ItemRepository {
  final ItemRemoteDatasource datasource;
  ItemRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, ItemModel>> createItem(ItemModel item) async {
    try {
      return Right(await datasource.createItem(item));
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Failed to create item'));
    }
  }

  @override
  Future<Either<Failure, ItemModel>> getItem(String itemId) async {
    try {
      return Right(await datasource.getItem(itemId));
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Item not found'));
    }
  }

  @override
  Future<Either<Failure, ItemModel>> updateItem(ItemModel item) async {
    try {
      return Right(await datasource.updateItem(item));
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Failed to update item'));
    }
  }

  @override
  Future<Either<Failure, List<ItemModel>>> getAllItems(String checklistId) async {
    try {
      return Right(await datasource.getAllItems(checklistId));
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Failed to get items'));
    }
  }

  @override
  Future<Either<Failure, List<ItemModel>>> createBulkItems(List<ItemModel> items) async {
    try {
      return Right(await datasource.createBulkItems(items));
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Failed to create items'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteItem(String itemId) async {
    try {
      await datasource.deleteItem(itemId);
      return const Right(null);
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Failed to delete item'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> uploadItemImage(File file) async {
    try {
      return Right(await datasource.uploadItemImage(file));
    } on UnauthorizedException {
      return Left(UnauthorizedError());
    } on ServerException catch (e) {
      return Left(ServerError(errorMessage: e.message ?? 'Failed to upload image item'));
    }
  }
}

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  return ItemRepositoryImpl(ref.watch(itemRemoteDatasourceProvider));
});
