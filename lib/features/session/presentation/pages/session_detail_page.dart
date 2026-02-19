import 'package:cartsync/features/checklist/data/models/checklist_model.dart';
import 'package:cartsync/features/item/presentation/providers/item_providers.dart';
import 'package:cartsync/features/session/data/models/session_model.dart';
import 'package:cartsync/service/websocket_service.dart';
import 'package:cartsync/utils/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/features/checklist/presentation/providers/checklist_providers.dart';
import 'package:cartsync/features/session/presentation/providers/session_providers.dart';
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
      },
      onPresenceEvent: (event) {
        if (!mounted) return;
        final activeUserList = event['onlineUsers'] as List;
        final finalList = activeUserList.map((e) => SessionActiveUser.fromJson(e)).toList();
        ref.read(sessionNotifierProvider.notifier).updateActiveUser(finalList);
      },
    );
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: session != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.name ?? 'Session',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  if (session.location != null && session.location!.isNotEmpty)
                    Text(
                      session.location!,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11),
                    ),
                ],
              )
            : const Text('Session'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create-checklist', arguments: widget.sessionId),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
      ),
      body: sessionState.isLoading && session == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: () async {
                ref.read(sessionNotifierProvider.notifier).loadSession(widget.sessionId);
                ref.read(checklistNotifierProvider.notifier).loadChecklistsBySession(widget.sessionId);
              },
              color: AppColors.primary,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                children: [
                  if (session != null) ...[
                    _buildStatusCard(session),
                    const SizedBox(height: 12),
                    _buildActiveUsersCard(sessionState.activeUser ?? []),
                    const SizedBox(height: 20),
                  ],

                  Row(
                    children: [
                      const Text(
                        'Checklists',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/create-checklist', arguments: widget.sessionId),
                        child: const Row(
                          children: [
                            Icon(Icons.add_rounded, color: AppColors.primary, size: 18),
                            SizedBox(width: 2),
                            Text(
                              'Add',
                              style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (checklistState.isLoading && checklistState.checklists.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    )
                  else if (checklistState.checklists.isEmpty)
                    _buildEmptyChecklists()
                  else
                    _buildChecklistCards(checklistState.checklists),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusCard(SessionModel session) {
    final status = session.sessionStatus ?? 'ACTIVE';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Session Status',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              _buildStatusBadge(status),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildStatusBtn(
                  label: 'Pause',
                  icon: Icons.pause_rounded,
                  bg: const Color(0xFFFFF8E1),
                  fg: const Color(0xFFE65100),
                  onTap: () => _updateStatus('PAUSED'),
                  isActive: status == 'PAUSED',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatusBtn(
                  label: 'Resume',
                  icon: Icons.play_arrow_rounded,
                  bg: AppColors.primaryXLight,
                  fg: AppColors.primary,
                  onTap: () => _updateStatus('ACTIVE'),
                  isActive: status == 'ACTIVE',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatusBtn(
                  label: 'End',
                  icon: Icons.stop_rounded,
                  bg: const Color(0xFFFFEBEE),
                  fg: const Color(0xFFC62828),
                  onTap: () => _updateStatus('ENDED'),
                  isActive: status == 'ENDED',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBtn({
    required String label,
    required IconData icon,
    required Color bg,
    required Color fg,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: isActive ? Border.all(color: fg, width: 1.5) : null,
        ),
        child: Column(
          children: [
            Icon(icon, color: fg, size: 18),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveUsersCard(List<SessionActiveUser> users) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Active Now',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryXLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _PulsingDot(),
                    const SizedBox(width: 5),
                    const Text(
                      'Live',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (users.isEmpty)
            Text('No users online', style: TextStyle(color: AppColors.textSecondary, fontSize: 13))
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: users.map((u) {
                final name = u.username ?? '?';
                final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
                return Container(
                  padding: const EdgeInsets.fromLTRB(5, 5, 12, 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryXLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.primaryLight,
                        child: Text(
                          initial,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 6, height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildChecklistCards(List<ChecklistModel> checklists) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1)),
        ],
      ),
      child: Column(
        children: checklists.asMap().entries.map((entry) {
          final i = entry.key;
          final c = entry.value;
          final isLast = i == checklists.length - 1;
          return _ChecklistRow(
            checklist: c,
            isLast: isLast,
            onTap: () => Navigator.pushNamed(context, '/checklist-detail', arguments: c.checklistId),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyChecklists() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('📝', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 12),
          Text(
            'No checklists yet',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap + to create your first checklist',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg, fg;
    String dot = '● ';
    switch (status) {
      case 'ACTIVE':
        bg = AppColors.primaryXLight;
        fg = AppColors.primary;
        break;
      case 'PAUSED':
        bg = const Color(0xFFFFF8E1);
        fg = const Color(0xFFE65100);
        break;
      default:
        bg = const Color(0xFFF5F5F5);
        fg = AppColors.textSecondary;
        dot = '';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        '$dot$status',
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }

  Future<void> _updateStatus(String status) async {
    await ref.read(sessionNotifierProvider.notifier).updateStatus(widget.sessionId, status);
  }
}

class _ChecklistRow extends StatelessWidget {
  final ChecklistModel checklist;
  final bool isLast;
  final VoidCallback onTap;

  const _ChecklistRow({required this.checklist, required this.isLast, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: const Radius.circular(0),
        bottom: isLast ? const Radius.circular(16) : Radius.zero,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryXLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text('📋', style: TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                checklist.name ?? 'Checklist',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
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
          decoration: const BoxDecoration(
            color: Color(0xFF4CAF50),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
