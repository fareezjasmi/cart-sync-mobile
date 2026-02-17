import 'package:cartsync/features/item/data/models/item_model.dart';

class ItemPageModel {
  final bool isLoading;
  final List<ItemModel> items;
  final String? errorMessage;

  ItemPageModel({
    this.isLoading = false,
    this.items = const [],
    this.errorMessage,
  });

  ItemPageModel copyWith({
    bool? isLoading,
    List<ItemModel>? items,
    String? errorMessage,
  }) {
    return ItemPageModel(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }
}

class ItemPageInitial extends ItemPageModel {
  ItemPageInitial() : super();
}
