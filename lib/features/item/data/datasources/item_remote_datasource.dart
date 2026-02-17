import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/core/errors/exceptions.dart';
import 'package:cartsync/features/item/data/models/item_model.dart';
import 'package:cartsync/service/dio_client.dart';

abstract class ItemRemoteDatasource {
  Future<ItemModel> createItem(ItemModel item);
  Future<ItemModel> getItem(String itemId);
  Future<ItemModel> updateItem(ItemModel item);
  Future<List<ItemModel>> getAllItems(String checklistId);
  Future<List<ItemModel>> createBulkItems(List<ItemModel> items);
  Future<void> deleteItem(String itemId);
}

class ItemRemoteDatasourceImpl implements ItemRemoteDatasource {
  final Dio dio;
  ItemRemoteDatasourceImpl(this.dio);

  @override
  Future<ItemModel> createItem(ItemModel item) async {
    try {
      final response = await dio.post('/item/create', data: item.toJson());
      return ItemModel.fromJson(response.data as Map<String, Object?>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<ItemModel> getItem(String itemId) async {
    try {
      final response = await dio.get('/item/$itemId');
      return ItemModel.fromJson(response.data as Map<String, Object?>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      if (e.response?.statusCode == 404) throw ServerException(message: 'Item not found');
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<ItemModel> updateItem(ItemModel item) async {
    try {
      final response = await dio.put('/item/update', data: item.toJson());
      return ItemModel.fromJson(response.data as Map<String, Object?>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<List<ItemModel>> getAllItems(String checklistId) async {
    try {
      final response = await dio.get('/items/getAll/$checklistId');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((e) => ItemModel.fromJson(e as Map<String, Object?>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<List<ItemModel>> createBulkItems(List<ItemModel> items) async {
    try {
      final response = await dio.post('/items/createBulk',
          data: items.map((i) => i.toJson()).toList());
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((e) => ItemModel.fromJson(e as Map<String, Object?>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<void> deleteItem(String itemId) async {
    try {
      await dio.delete('/item/delete/$itemId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException();
      throw ServerException(message: e.message);
    }
  }
}

final itemRemoteDatasourceProvider = Provider<ItemRemoteDatasource>((ref) {
  return ItemRemoteDatasourceImpl(ref.watch(dioProvider));
});
