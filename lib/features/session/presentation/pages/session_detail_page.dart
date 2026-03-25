import 'dart:io';

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
import 'package:image_picker/image_picker.dart';

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
    final isEnded = session?.sessionStatus == 'ENDED';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: session != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        session.name ?? 'Session',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusBadge(session.sessionStatus ?? 'ACTIVE'),
                    ],
                  ),
                  if (session.location != null && session.location!.isNotEmpty)
                    Text(session.location!, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
                ],
              )
            : const Text('Session'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (session != null && !isEnded)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'end') {
                  _showCloseSessionSheet();
                } else {
                  _updateStatus(value);
                }
              },
              icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              itemBuilder: (_) => [
                if (session.sessionStatus != 'PAUSED')
                  const PopupMenuItem(
                    value: 'PAUSED',
                    child: Row(
                      children: [
                        Icon(Icons.pause_rounded, color: Color(0xFFE65100), size: 20),
                        SizedBox(width: 10),
                        Text('Pause session', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                if (session.sessionStatus == 'PAUSED')
                  const PopupMenuItem(
                    value: 'ACTIVE',
                    child: Row(
                      children: [
                        Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 20),
                        SizedBox(width: 10),
                        Text('Resume session', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'end',
                  child: Row(
                    children: [
                      Icon(Icons.stop_rounded, color: Color(0xFFC62828), size: 20),
                      SizedBox(width: 10),
                      Text('End session', style: TextStyle(fontSize: 14, color: Color(0xFFC62828))),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: isEnded
          ? null
          : FloatingActionButton(
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
                    if (isEnded) ...[_buildEndedCard(session), const SizedBox(height: 12)],
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
                      if (!isEnded)
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

  Widget _buildEndedCard(SessionModel session) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (session.endTime != null)
            Row(
              children: [
                const Icon(Icons.schedule_rounded, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  'Ended ${_formatDate(session.endTime!)}',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          if (session.receiptUrl != null) ...[
            const SizedBox(height: 12),
            const Text(
              'RECEIPT',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                session.receiptUrl!,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 80,
                  decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: Icon(Icons.receipt_long_rounded, color: AppColors.textSecondary, size: 32),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActiveUsersCard(List<SessionActiveUser> users) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1))],
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
                decoration: BoxDecoration(color: AppColors.primaryXLight, borderRadius: BorderRadius.circular(20)),
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
                  decoration: BoxDecoration(color: AppColors.primaryXLight, borderRadius: BorderRadius.circular(20)),
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
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
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
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1))],
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          const Text('📝', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 12),
          const Text(
            'No checklists yet',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text('Tap + to create your first checklist', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
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

  void _showCloseSessionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CloseSessionSheet(sessionId: widget.sessionId, onClosed: () => Navigator.pop(context)),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}

// ── Close Session Bottom Sheet ───────────────────────────────────────────────

class _CloseSessionSheet extends ConsumerStatefulWidget {
  final String sessionId;
  final VoidCallback onClosed;

  const _CloseSessionSheet({required this.sessionId, required this.onClosed});

  @override
  ConsumerState<_CloseSessionSheet> createState() => _CloseSessionSheetState();
}

class _CloseSessionSheetState extends ConsumerState<_CloseSessionSheet> {
  File? _receipt;
  bool _confirmed = false;
  bool _isLoading = false;

  Future<void> _pickReceipt(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) setState(() => _receipt = File(picked.path));
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    final success = await ref.read(sessionNotifierProvider.notifier).closeSession(widget.sessionId, receipt: _receipt);
    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
      widget.onClosed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),

          // Icon + title
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(16)),
            child: const Center(child: Icon(Icons.stop_circle_rounded, color: Color(0xFFC62828), size: 28)),
          ),
          const SizedBox(height: 14),
          const Text(
            'End this session?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'This will close the grocery run. All checklists will be locked. This action cannot be undone.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
          ),

          const SizedBox(height: 24),

          // Receipt section
          Text(
            'UPLOAD RECEIPT (OPTIONAL)',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),

          if (_receipt != null)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_receipt!, height: 140, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => setState(() => _receipt = null),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                      child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _ReceiptPickerBtn(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    onTap: () => _pickReceipt(ImageSource.gallery),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ReceiptPickerBtn(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    onTap: () => _pickReceipt(ImageSource.camera),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 24),

          // Confirmation checkbox
          GestureDetector(
            onTap: () => setState(() => _confirmed = !_confirmed),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: _confirmed ? const Color(0xFFC62828) : Colors.white,
                    border: Border.all(color: _confirmed ? const Color(0xFFC62828) : const Color(0xFFBDBDBD), width: 2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: _confirmed ? const Icon(Icons.check_rounded, color: Colors.white, size: 14) : null,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'I confirm I want to end this session',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFFE0E0E0)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: (_isLoading || !_confirmed) ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC62828),
                    disabledBackgroundColor: const Color(0xFFEF9A9A),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'End Session',
                          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReceiptPickerBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ReceiptPickerBtn({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Checklist Row ────────────────────────────────────────────────────────────

class _ChecklistRow extends ConsumerWidget {
  final ChecklistModel checklist;
  final bool isLast;
  final VoidCallback onTap;

  const _ChecklistRow({required this.checklist, required this.isLast, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checklistState = ref.watch(checklistNotifierProvider);
    final itemState = ref.watch(itemNotifierProvider);
    final checklist = checklistState.currentChecklist;
    final items = itemState.items;
    final bought = items.where((i) => i.isBought ?? false).toList();
    final total = items.length;
    final boughtCount = bought.length;
    final progress = total > 0 ? boughtCount / total : 0.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(bottom: isLast ? const Radius.circular(16) : Radius.zero),
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
              decoration: BoxDecoration(color: AppColors.primaryXLight, borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text('📋', style: TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    checklist?.name ?? 'Checklist',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            '$boughtCount/$total items',
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                          const Spacer(),
                          Text(
                            '${(progress * 100).round()}%',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: AppColors.primaryXLight,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Pulsing Dot ──────────────────────────────────────────────────────────────

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
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
      builder: (_, __) => Opacity(
        opacity: _animation.value,
        child: Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
        ),
      ),
    );
  }
}
