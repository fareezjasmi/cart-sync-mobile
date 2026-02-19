import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/features/checklist/presentation/providers/checklist_providers.dart';
import 'package:cartsync/features/item/data/models/item_model.dart';
import 'package:cartsync/features/item/presentation/providers/item_providers.dart';
import 'package:cartsync/service/websocket_service.dart';
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
      onPresenceEvent: (_) {},
    );
  }

  void _showEventToast(String eventType) {
    final (String label, Color color) = switch (eventType) {
      'ITEM_ADDED' => ('Item added', const Color(0xFF4CAF50)),
      'ITEM_BOUGHT' => ('Item marked as bought', const Color(0xFF4CAF50)),
      'ITEM_UPDATED' => ('Item updated', AppColors.warning),
      'ITEM_DELETED' => ('Item deleted', AppColors.error),
      _ => ('Item changed', AppColors.textSecondary),
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
        backgroundColor: const Color(0xFF323232),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        duration: const Duration(seconds: 2),
      ),
    );
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
    final items = itemState.items;
    final remaining = items.where((i) => !(i.isBought ?? false)).toList();
    final bought = items.where((i) => i.isBought ?? false).toList();
    final total = items.length;
    final boughtCount = bought.length;
    final progress = total > 0 ? boughtCount / total : 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            pinned: true,
            elevation: 0,
            expandedHeight: total > 0 ? 110 : 56,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.edit_outlined, size: 16),
                ),
                onPressed: () => _showRenameDialog(context),
              ),
              const SizedBox(width: 8),
            ],
            title: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        checklist?.name ?? 'Checklist',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                // Live indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _PulsingDot(color: const Color(0xFFA5D6A7)),
                      const SizedBox(width: 5),
                      const Text(
                        'Live',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: total > 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '$boughtCount of $total items bought',
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${(progress * 100).round()}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.white.withValues(alpha: 0.25),
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        ],
        body: checklistState.isLoading && items.isEmpty
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : items.isEmpty
                ? _buildEmptyState()
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                    children: [
                      if (checklistState.errorMessage != null || itemState.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.errorLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              checklistState.errorMessage ?? itemState.errorMessage ?? '',
                              style: TextStyle(color: AppColors.error, fontSize: 13),
                            ),
                          ),
                        ),

                      if (remaining.isNotEmpty) ...[
                        _buildSectionHeader('Remaining', remaining.length),
                        const SizedBox(height: 8),
                        _buildItemsCard(remaining, false),
                        const SizedBox(height: 16),
                      ],

                      if (bought.isNotEmpty) ...[
                        _buildSectionHeader('Bought', bought.length),
                        const SizedBox(height: 8),
                        _buildItemsCard(bought, true),
                      ],
                    ],
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create-item', arguments: widget.checklistId),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
      ),
    );
  }

  Widget _buildSectionHeader(String label, int count) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primaryXLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsCard(List<ItemModel> items, bool isBought) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1)),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          final isLast = i == items.length - 1;
          return _ItemRow(
            item: item,
            isLast: isLast,
            onToggle: () => ref.read(itemNotifierProvider.notifier).toggleBought(item.copyWith(isBought: !(item.isBought ?? false))),
            onDelete: () => _confirmDelete(context, item.itemId!),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryXLight,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(child: Text('🛍️', style: TextStyle(fontSize: 36))),
          ),
          const SizedBox(height: 16),
          const Text(
            'No items yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first item',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(BuildContext context) {
    final controller = TextEditingController(
      text: ref.read(checklistNotifierProvider).currentChecklist?.name ?? '',
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Rename Checklist', style: TextStyle(fontWeight: FontWeight.w700)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Checklist name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(checklistNotifierProvider.notifier).updateName(
                    widget.checklistId,
                    controller.text.trim(),
                  );
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Item', style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to remove this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
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

class _ItemRow extends StatelessWidget {
  final ItemModel item;
  final bool isLast;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _ItemRow({
    required this.item,
    required this.isLast,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isBought = item.isBought ?? false;
    return Container(
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1)),
      ),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.vertical(
          bottom: isLast ? const Radius.circular(16) : Radius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            children: [
              // Checkbox
              GestureDetector(
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22, height: 22,
                  decoration: BoxDecoration(
                    color: isBought ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: isBought
                        ? null
                        : Border.all(color: const Color(0xFFDEDEDE), width: 2),
                  ),
                  child: isBought
                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              // Icon
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: isBought ? const Color(0xFFF5F5F5) : AppColors.primaryXLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    _getEmoji(item.name ?? ''),
                    style: TextStyle(fontSize: 20, color: isBought ? null : null),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name
              Expanded(
                child: Text(
                  item.name ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isBought ? AppColors.textSecondary : AppColors.textPrimary,
                    decoration: isBought ? TextDecoration.lineThrough : null,
                    decorationColor: AppColors.textSecondary,
                  ),
                ),
              ),
              // Delete
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error.withValues(alpha: 0.6),
                  size: 20,
                ),
                onPressed: onDelete,
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getEmoji(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('milk') || lower.contains('susu')) return '🥛';
    if (lower.contains('egg') || lower.contains('telur')) return '🥚';
    if (lower.contains('bread') || lower.contains('roti')) return '🍞';
    if (lower.contains('tomato') || lower.contains('tomat')) return '🍅';
    if (lower.contains('carrot') || lower.contains('lobak')) return '🥕';
    if (lower.contains('apple') || lower.contains('epal')) return '🍎';
    if (lower.contains('chicken') || lower.contains('ayam')) return '🍗';
    if (lower.contains('fish') || lower.contains('ikan')) return '🐟';
    if (lower.contains('rice') || lower.contains('nasi') || lower.contains('beras')) return '🍚';
    if (lower.contains('onion') || lower.contains('bawang')) return '🧅';
    if (lower.contains('potato') || lower.contains('kentang')) return '🥔';
    if (lower.contains('water') || lower.contains('air')) return '💧';
    if (lower.contains('soap') || lower.contains('sabun')) return '🧼';
    return '🛍️';
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context2, child2) => Opacity(
        opacity: _animation.value,
        child: Container(
          width: 7, height: 7,
          decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
