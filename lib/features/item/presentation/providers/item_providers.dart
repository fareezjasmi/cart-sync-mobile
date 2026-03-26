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
    try {
      final result = await uploadItemImageUsecase(imageFile);
      String? imageUrl;
      result.fold(
        (failure) => state = state.copyWith(errorMessage: failure.errorMessage),
        (data) => imageUrl = data['image_url'] as String?,
      );
      return imageUrl;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return null;
    }
  }

  Future<bool> createItem(String checklistId, String name, {File? imageFile}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile);
        if (imageUrl == null) return false;
      }

      final item = ItemModel(checklistId: checklistId, name: name, isBought: false, image: imageUrl);
      final result = await createItemUsecase(item);

      return result.fold(
        (failure) {
          state = state.copyWith(errorMessage: failure.errorMessage);
          return false;
        },
        (i) {
          final alreadyExists = state.items.any((existing) => existing.itemId == i.itemId);
          if (!alreadyExists) {
            state = state.copyWith(items: [...state.items, i]);
          }
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> updateItem(ItemModel item, {File? imageFile}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      String? imageUrl = item.image;
      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile);
        if (imageUrl == null) return false;
      }

      final result = await updateItemUsecase(item.copyWith(image: imageUrl));
      return result.fold(
        (failure) {
          state = state.copyWith(errorMessage: failure.errorMessage);
          return false;
        },
        (updated) {
          final items = state.items.map((i) => i.itemId == updated.itemId ? updated : i).toList();
          state = state.copyWith(items: items);
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadAllItems(String checklistId) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await getAllItemsUsecase(checklistId);
      result.fold(
        (failure) => state = state.copyWith(errorMessage: failure.errorMessage),
        (items) => state = state.copyWith(items: items),
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> toggleBought(ItemModel item) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await updateItemUsecase(item);
      result.fold((failure) => state = state.copyWith(errorMessage: failure.errorMessage), (updated) {
        final items = state.items.map((i) => i.itemId == updated.itemId ? updated : i).toList();
        state = state.copyWith(items: items);
      });
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> bulkCreate(List<ItemModel> items) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await bulkCreateItemsUsecase(items);
      return result.fold(
        (failure) {
          state = state.copyWith(errorMessage: failure.errorMessage);
          return false;
        },
        (created) {
          final updated = List<ItemModel>.from(state.items)..addAll(created);
          state = state.copyWith(items: updated);
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> deleteItem(String itemId) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await deleteItemUsecase(itemId);
      result.fold((failure) => state = state.copyWith(errorMessage: failure.errorMessage), (_) {
        final updated = state.items.where((i) => i.itemId != itemId).toList();
        state = state.copyWith(items: updated);
      });
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
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
          if (item.checklistId != null) {
            ref.invalidate(checklistItemsProvider(item.checklistId!));
          }
        }
      case 'ITEM_UPDATED':
      case 'ITEM_BOUGHT':
        if (rawItem != null) {
          final updated = ItemModel.fromJson(rawItem);
          state = state.copyWith(items: state.items.map((i) => i.itemId == updated.itemId ? updated : i).toList());
          if (updated.checklistId != null) {
            ref.invalidate(checklistItemsProvider(updated.checklistId!));
          }
        }
      case 'ITEM_DELETED':
        if (deletedItemId != null) {
          final checklistId = state.items.where((i) => i.itemId == deletedItemId).firstOrNull?.checklistId;
          state = state.copyWith(items: state.items.where((i) => i.itemId != deletedItemId).toList());
          if (checklistId != null) {
            ref.invalidate(checklistItemsProvider(checklistId));
          }
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

final checklistItemsProvider = FutureProvider.family<List<ItemModel>, String>((ref, checklistId) async {
  final usecase = ref.watch(getAllItemsUsecaseProvider);
  final result = await usecase(checklistId);
  return result.fold((_) => [], (items) => items);
});
