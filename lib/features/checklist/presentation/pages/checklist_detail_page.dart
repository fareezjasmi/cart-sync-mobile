import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/features/checklist/presentation/providers/checklist_providers.dart';
import 'package:cartsync/features/item/presentation/providers/item_providers.dart';
import 'package:cartsync/service/websocket_service.dart';
import 'package:cartsync/shared/widgets/base_screen_wrapper.dart';
import 'package:cartsync/utils/app_colors.dart';
import 'package:cartsync/utils/secure_storage_service.dart' show StorageService;

class ChecklistDetailPage extends ConsumerStatefulWidget {
  final String checklistId;
  const ChecklistDetailPage({super.key, required this.checklistId});

  @override
  ConsumerState<ChecklistDetailPage> createState() => _ChecklistDetailPageState();
}

class _ChecklistDetailPageState extends ConsumerState<ChecklistDetailPage> {
  final _wsService = WebSocketService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(checklistNotifierProvider.notifier).loadChecklist(widget.checklistId);
      ref.read(itemNotifierProvider.notifier).loadAllItems(widget.checklistId);
      await _connectWebSocket();
    });
  }

  Future<void> _connectWebSocket() async {
    final token = await StorageService.instance.readData('token');
    final familyId = await StorageService.instance.readData('familyId');

    if (token == null || familyId == null) return;

    _wsService.connect(
      token: token,
      familyId: familyId,
      onItemEvent: (event) {
        if (!mounted) return;
        ref.read(itemNotifierProvider.notifier).handleWsEvent(event);
        _showEventToast(event['type'] as String? ?? 'update');
      },
      onPresenceEvent: (event) {
        if (!mounted) return;
        debugPrint('[WS] Presence update: $event');
        _showEventToast(event['type'] as String? ?? 'presence');
      },
    );
  }

  void _showEventToast(String eventType) {
    final label = switch (eventType) {
      'ITEM_ADDED' => '+ Item added',
      'ITEM_BOUGHT' => '✓ Item marked bought',
      'ITEM_UPDATED' => '✎ Item updated',
      'ITEM_DELETED' => '✕ Item deleted',
      'PRESENCE_UPDATE' => 'New user online!',
      _ => 'Item changed',
    };
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label), duration: const Duration(seconds: 2)));
  }

  @override
  void dispose() {
    _wsService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checklistState = ref.watch(checklistNotifierProvider);
    final itemState = ref.watch(itemNotifierProvider);
    final checklist = checklistState.currentChecklist;

    return BaseScreenWrapper(
      title: checklist?.name ?? 'Checklist',
      isLoading: checklistState.isLoading || itemState.isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (checklistState.errorMessage != null || itemState.errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: AppColors.errorLight, borderRadius: BorderRadius.circular(8)),
              child: Text(
                checklistState.errorMessage ?? itemState.errorMessage ?? '',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Items',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _showRenameDialog(context),
                    icon: Icon(Icons.edit, color: AppColors.primary),
                    tooltip: 'Rename',
                  ),
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/create-item', arguments: widget.checklistId),
                    icon: Icon(Icons.add, color: AppColors.primary),
                    tooltip: 'Add item',
                  ),
                ],
              ),
            ],
          ),
          if (itemState.items.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text('No items yet. Tap + to add.', style: TextStyle(color: AppColors.textSecondary)),
              ),
            )
          else
            ...itemState.items.map(
              (item) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Checkbox(
                    value: item.isBought ?? false,
                    onChanged: (val) {
                      ref.read(itemNotifierProvider.notifier).toggleBought(item.copyWith(isBought: val));
                    },
                    activeColor: AppColors.primary,
                  ),
                  title: Text(
                    item.name ?? '',
                    style: TextStyle(
                      decoration: (item.isBought ?? false) ? TextDecoration.lineThrough : null,
                      color: (item.isBought ?? false) ? AppColors.textSecondary : AppColors.textPrimary,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: AppColors.error),
                    onPressed: () => _confirmDelete(context, item.itemId!),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showRenameDialog(BuildContext context) {
    final controller = TextEditingController(text: ref.read(checklistNotifierProvider).currentChecklist?.name ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Checklist'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(checklistNotifierProvider.notifier).updateName(widget.checklistId, controller.text.trim());
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String itemId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(itemNotifierProvider.notifier).deleteItem(itemId);
    }
  }
}
