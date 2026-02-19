import 'package:cartsync/features/item/presentation/providers/item_providers.dart';
import 'package:cartsync/features/session/data/models/session_model.dart';
import 'package:cartsync/service/websocket_service.dart';
import 'package:cartsync/utils/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/features/checklist/presentation/providers/checklist_providers.dart';
import 'package:cartsync/features/session/presentation/providers/session_providers.dart';
import 'package:cartsync/shared/widgets/base_screen_wrapper.dart';
import 'package:cartsync/utils/app_colors.dart';

class SessionDetailPage extends ConsumerStatefulWidget {
  final String sessionId;
  const SessionDetailPage({super.key, required this.sessionId});

  @override
  ConsumerState<SessionDetailPage> createState() => _SessionDetailPageState();
}

class _SessionDetailPageState extends ConsumerState<SessionDetailPage> {
  final _wsService = WebSocketService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(sessionNotifierProvider.notifier).loadSession(widget.sessionId);
      ref.read(checklistNotifierProvider.notifier).loadChecklistsBySession(widget.sessionId);
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

        final activeUserList = event['onlineUsers'] as List;

        List<SessionActiveUser> finalList = activeUserList.map((e) => SessionActiveUser.fromJson(e)).toList();

        // List<SessionActiveUser> activeUser = SessionActiveUser.fromJson(event['onlineUsers'] as Map<String, dynamic>);

        ref.read(sessionNotifierProvider.notifier).updateActiveUser(finalList);
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
    final sessionState = ref.watch(sessionNotifierProvider);
    final checklistState = ref.watch(checklistNotifierProvider);
    final session = sessionState.currentSession;

    return BaseScreenWrapper(
      title: session?.name ?? 'Session',
      isLoading: sessionState.isLoading || checklistState.isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (session != null) ...[
            Column(
              children: ref.watch(sessionNotifierProvider).activeUser!.map((e) => Text(e.username ?? '')).toList(),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status', style: TextStyle(color: AppColors.textSecondary)),
                        _statusChip(session.sessionStatus ?? 'ACTIVE'),
                      ],
                    ),
                    if (session.location != null && session.location!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(session.location!, style: TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _updateStatus(context, 'PAUSED'),
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.orange),
                            child: const Text('Pause'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _updateStatus(context, 'ENDED'),
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                            child: const Text('End'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _updateStatus(context, 'ACTIVE'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Resume'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Checklists',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/create-checklist', arguments: widget.sessionId),
                icon: Icon(Icons.add, color: AppColors.primary),
              ),
            ],
          ),
          if (checklistState.checklists.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text('No checklists yet. Tap + to add.', style: TextStyle(color: AppColors.textSecondary)),
              ),
            )
          else
            ...checklistState.checklists.map(
              (c) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(Icons.checklist, color: AppColors.primary),
                ),
                title: Text(c.name ?? 'Checklist'),
                subtitle: Text('ID: ${c.checklistId ?? '-'}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, '/checklist-detail', arguments: c.checklistId),
              ),
            ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color;
    switch (status) {
      case 'ACTIVE':
        color = Colors.green;
        break;
      case 'PAUSED':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Future<void> _updateStatus(BuildContext context, String status) async {
    await ref.read(sessionNotifierProvider.notifier).updateStatus(widget.sessionId, status);
  }
}
