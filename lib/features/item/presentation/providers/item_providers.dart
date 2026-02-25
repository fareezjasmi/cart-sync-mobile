import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:cartsync/features/item/data/models/item_model.dart';
import 'package:cartsync/features/item/domain/usecases/bulk_create_items_usecase.dart';
import 'package:cartsync/features/item/domain/usecases/create_item_usecase.dart';
import 'package:cartsync/features/item/domain/usecases/delete_item_usecase.dart';
import 'package:cartsync/features/item/domain/usecases/get_all_items_usecase.dart';
import 'package:cartsync/features/item/domain/usecases/get_item_usecase.dart';
import 'package:cartsync/features/item/domain/usecases/update_item_usecase.dart';
import 'package:cartsync/features/item/domain/usecases/upload_item_image_usecase.dart';
import 'package:cartsync/features/item/presentation/models/item_page_model.dart';

class ItemNotifier extends StateNotifier<ItemPageModel> {
  final Ref ref;
  final CreateItemUsecase createItemUsecase;
  final GetItemUsecase getItemUsecase;
  final UpdateItemUsecase updateItemUsecase;
  final GetAllItemsUsecase getAllItemsUsecase;
  final BulkCreateItemsUsecase bulkCreateItemsUsecase;
  final DeleteItemUsecase deleteItemUsecase;
  final UploadItemImageUsecase uploadItemImageUsecase;

  ItemNotifier(
    this.ref,
    this.createItemUsecase,
    this.getItemUsecase,
    this.updateItemUsecase,
    this.getAllItemsUsecase,
    this.bulkCreateItemsUsecase,
    this.deleteItemUsecase,
    this.uploadItemImageUsecase,
  ) : super(ItemPageInitial());

  Future<String?> _uploadImage(File imageFile) async {
    final result = await uploadItemImageUsecase(imageFile);
    String? imageUrl;
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.errorMessage),
      (data) => imageUrl = data['image_url'] as String?,
    );
    return imageUrl;
  }

  Future<bool> createItem(String checklistId, String name, {File? imageFile}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await _uploadImage(imageFile);
      print('Saved image url: $imageUrl');
      if (imageUrl == null) {
        state = state.copyWith(isLoading: false);
        return false;
      }
    }

    final item = ItemModel(checklistId: checklistId, name: name, isBought: false, image: imageUrl);
    final result = await createItemUsecase(item);

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage);
        return false;
      },
      (i) {
        final updated = List<ItemModel>.from(state.items)..add(i);
        state = state.copyWith(isLoading: false, items: updated);
        return true;
      },
    );
  }

  Future<bool> updateItem(ItemModel item, {File? imageFile}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    String? imageUrl = item.image;
    if (imageFile != null) {
      imageUrl = await _uploadImage(imageFile);
      if (imageUrl == null) {
        state = state.copyWith(isLoading: false);
        return false;
      }
    }

    final result = await updateItemUsecase(item.copyWith(image: imageUrl));
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage);
        return false;
      },
      (updated) {
        final items = state.items.map((i) => i.itemId == updated.itemId ? updated : i).toList();
        state = state.copyWith(isLoading: false, items: items);
        return true;
      },
    );
  }

  Future<void> loadAllItems(String checklistId) async {
    state = state.copyWith(isLoading: true);
    final result = await getAllItemsUsecase(checklistId);
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage),
      (items) => state = state.copyWith(isLoading: false, items: items),
    );
  }

  Future<void> toggleBought(ItemModel item) async {
    final result = await updateItemUsecase(item);
    result.fold((failure) => state = state.copyWith(errorMessage: failure.errorMessage), (updated) {
      final items = state.items.map((i) => i.itemId == updated.itemId ? updated : i).toList();
      state = state.copyWith(items: items);
    });
  }

  Future<bool> bulkCreate(List<ItemModel> items) async {
    state = state.copyWith(isLoading: true);
    final result = await bulkCreateItemsUsecase(items);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage);
        return false;
      },
      (created) {
        final updated = List<ItemModel>.from(state.items)..addAll(created);
        state = state.copyWith(isLoading: false, items: updated);
        return true;
      },
    );
  }

  Future<void> deleteItem(String itemId) async {
    state = state.copyWith(isLoading: true);
    final result = await deleteItemUsecase(itemId);
    result.fold((failure) => state = state.copyWith(isLoading: false, errorMessage: failure.errorMessage), (_) {
      final updated = state.items.where((i) => i.itemId != itemId).toList();
      state = state.copyWith(isLoading: false, items: updated);
    });
  }

  // Called by WebSocketService when a real-time item event arrives
  void handleWsEvent(Map<String, dynamic> event) {
    final type = event['type'] as String?;
    final rawItem = event['item'] as Map<String, dynamic>?;
    final deletedItemId = event['itemId'] as String?;

    switch (type) {
      case 'ITEM_ADDED':
        if (rawItem != null) {
          final item = ItemModel.fromJson(rawItem);
          // Only add if not already in the list (avoid duplicate with HTTP response)
          final alreadyExists = state.items.any((i) => i.itemId == item.itemId);
          if (!alreadyExists) {
            state = state.copyWith(items: [...state.items, item]);
          }
        }
      case 'ITEM_UPDATED':
      case 'ITEM_BOUGHT':
        if (rawItem != null) {
          final updated = ItemModel.fromJson(rawItem);
          state = state.copyWith(items: state.items.map((i) => i.itemId == updated.itemId ? updated : i).toList());
        }
      case 'ITEM_DELETED':
        if (deletedItemId != null) {
          state = state.copyWith(items: state.items.where((i) => i.itemId != deletedItemId).toList());
        }
    }
  }
}

final itemNotifierProvider = StateNotifierProvider<ItemNotifier, ItemPageModel>((ref) {
  return ItemNotifier(
    ref,
    ref.watch(createItemUsecaseProvider),
    ref.watch(getItemUsecaseProvider),
    ref.watch(updateItemUsecaseProvider),
    ref.watch(getAllItemsUsecaseProvider),
    ref.watch(bulkCreateItemsUsecaseProvider),
    ref.watch(deleteItemUsecaseProvider),
    ref.watch(uploadItemImageUsecaseProvider),
  );
});
