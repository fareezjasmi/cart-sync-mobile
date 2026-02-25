import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/features/item/presentation/providers/item_providers.dart';
import 'package:cartsync/shared/widgets/base_screen_wrapper.dart';
import 'package:cartsync/utils/app_colors.dart';

class ItemsPage extends ConsumerStatefulWidget {
  final String checklistId;
  const ItemsPage({super.key, required this.checklistId});

  @override
  ConsumerState<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends ConsumerState<ItemsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(itemNotifierProvider.notifier).loadAllItems(widget.checklistId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(itemNotifierProvider);
    return BaseScreenWrapper(
      title: 'Items',
      isLoading: state.isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/create-item',
                arguments: widget.checklistId),
            icon: const Icon(Icons.add),
            label: const Text('Add Item'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          if (state.items.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text('No items yet.',
                    style: TextStyle(color: AppColors.textSecondary)),
              ),
            )
          else
            ...state.items.map((item) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: CheckboxListTile(
                    value: item.isBought ?? false,
                    onChanged: (val) => ref
                        .read(itemNotifierProvider.notifier)
                        .toggleBought(item.copyWith(isBought: val)),
                    title: Text(
                      item.name ?? '',
                      style: TextStyle(
                        decoration: (item.isBought ?? false)
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    activeColor: AppColors.primary,
                    secondary: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit_outlined, color: AppColors.primary),
                          onPressed: () => Navigator.pushNamed(context, '/update-item', arguments: item),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: AppColors.error),
                          onPressed: () =>
                              ref.read(itemNotifierProvider.notifier).deleteItem(item.itemId!),
                        ),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
