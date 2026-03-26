import 'package:cartsync/features/session/data/models/session_model.dart';
import 'package:cartsync/router/route_generator.dart';
import 'package:cartsync/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AllSessionsPage extends StatelessWidget {
  final List<SessionModel> sessions;
  final String familyId;
  final bool? isAdmin;

  const AllSessionsPage({
    super.key,
    required this.sessions,
    required this.familyId,
    this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Shopping Sessions',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: sessions.isEmpty
          ? _buildEmpty()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: sessions.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final s = sessions[i];
                return _SessionCard(
                  session: s,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/session-detail',
                    arguments: SessionDetailsPageArgs(
                      s.sessionId ?? '',
                      isAdmin,
                      familyId,
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryXLight,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(child: Text('🛒', style: TextStyle(fontSize: 36))),
          ),
          const SizedBox(height: 16),
          const Text(
            'No sessions yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start a shopping session so your\nfamily can track items in real-time.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
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
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _statusBgColor(status),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(child: Text(_statusEmoji(status), style: const TextStyle(fontSize: 20))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.name ?? 'Unnamed Session',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (session.location != null && session.location!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textSecondary),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            session.location!,
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildStatusBadge(status),
                const SizedBox(height: 6),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
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
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }

  Color _statusBgColor(String status) {
    switch (status) {
      case 'ACTIVE':
        return AppColors.primaryXLight;
      case 'PAUSED':
        return const Color(0xFFFFF8E1);
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  String _statusEmoji(String status) {
    switch (status) {
      case 'ACTIVE':
        return '🛒';
      case 'PAUSED':
        return '⏸️';
      default:
        return '✅';
    }
  }
}
