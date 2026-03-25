import 'package:cartsync/features/session/data/models/session_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/features/session/presentation/providers/session_providers.dart';
import 'package:cartsync/shared/providers/app_config_providers.dart';
import 'package:cartsync/utils/app_colors.dart';

class SessionsPage extends ConsumerStatefulWidget {
  const SessionsPage({super.key});

  @override
  ConsumerState<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends ConsumerState<SessionsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final familyId = await ref.read(sessionIdProvider.future);
    if (familyId != null && familyId.isNotEmpty) {
      ref.read(sessionNotifierProvider.notifier).loadAllSessions(familyId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionNotifierProvider);
    final all = state.allSession ?? [];
    final active = all.where((s) => s.sessionStatus == 'ACTIVE' || s.sessionStatus == 'PAUSED').toList();
    final endedCount = all.where((s) => s.sessionStatus == 'ENDED').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sessions', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        actions: [
          if (endedCount > 0)
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/session-history'),
              icon: const Icon(Icons.history_rounded, color: Colors.white, size: 18),
              label: Text(
                'History ($endedCount)',
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
      body: state.isLoading && state.allSession == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _load,
              color: AppColors.primary,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                children: [
                  if (state.errorMessage != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.errorLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(state.errorMessage!, style: TextStyle(color: AppColors.error, fontSize: 13)),
                    ),

                  // History banner (shown when there are ended sessions but none active)
                  if (active.isEmpty && endedCount > 0)
                    _HistoryBanner(count: endedCount),

                  // Active sessions
                  if (active.isNotEmpty) ...[
                    Row(
                      children: [
                        const Text(
                          'Active',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.3),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryXLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${active.length}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...active.map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _SessionCard(
                        session: s,
                        onTap: () => Navigator.pushNamed(context, '/session-detail', arguments: s.sessionId),
                      ),
                    )),
                  ],

                  // Empty state
                  if (active.isEmpty && endedCount == 0) _buildEmpty(),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/create-session'),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('New Session', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(color: AppColors.primaryXLight, borderRadius: BorderRadius.circular(20)),
              child: const Center(child: Text('🛒', style: TextStyle(fontSize: 32))),
            ),
            const SizedBox(height: 16),
            const Text(
              'No active sessions',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap + to start a new grocery run',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryBanner extends StatelessWidget {
  final int count;
  const _HistoryBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/session-history'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1))],
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Icon(Icons.history_rounded, color: AppColors.textSecondary, size: 22)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Past Sessions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  Text('$count ended session${count == 1 ? '' : 's'}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final SessionModel session;
  final VoidCallback onTap;

  const _SessionCard({required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final status = session.sessionStatus ?? 'ACTIVE';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1))],
        ),
        child: Row(
          children: [
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: status == 'PAUSED' ? const Color(0xFFFFF8E1) : AppColors.primaryXLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(
                  status == 'PAUSED' ? Icons.pause_rounded : Icons.shopping_cart_rounded,
                  color: status == 'PAUSED' ? const Color(0xFFE65100) : AppColors.primary,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.name ?? 'Shopping Session',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  if (session.location != null && session.location!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textSecondary),
                        const SizedBox(width: 2),
                        Text(session.location!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _StatusBadge(status: status),
                const SizedBox(height: 6),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
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
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}
