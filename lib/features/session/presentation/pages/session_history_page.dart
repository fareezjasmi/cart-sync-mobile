import 'package:cartsync/features/session/data/models/session_model.dart';
import 'package:cartsync/features/session/presentation/providers/session_providers.dart';
import 'package:cartsync/shared/providers/app_config_providers.dart';
import 'package:cartsync/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionHistoryPage extends ConsumerStatefulWidget {
  const SessionHistoryPage({super.key});

  @override
  ConsumerState<SessionHistoryPage> createState() => _SessionHistoryPageState();
}

class _SessionHistoryPageState extends ConsumerState<SessionHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final familyId = await ref.read(sessionIdProvider.future);
    print(familyId);
    if (familyId != null && familyId.isNotEmpty) {
      ref.read(sessionNotifierProvider.notifier).loadAllSessions(familyId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionNotifierProvider);
    final ended = (state.allSession ?? []).where((s) => s.sessionStatus == 'ENDED').toList()
      ..sort((a, b) => (b.endTime ?? '').compareTo(a.endTime ?? ''));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Session History',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: state.isLoading && state.allSession == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _load,
              color: AppColors.primary,
              child: ended.isEmpty
                  ? _buildEmpty()
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: ended.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => _SessionHistoryCard(
                        session: ended[i],
                        onTap: () => Navigator.pushNamed(context, '/session-detail', arguments: ended[i].sessionId),
                      ),
                    ),
            ),
    );
  }

  Widget _buildEmpty() {
    return ListView(
      children: [
        const SizedBox(height: 80),
        Center(
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(20)),
                child: const Center(child: Text('🧾', style: TextStyle(fontSize: 32))),
              ),
              const SizedBox(height: 16),
              const Text(
                'No history yet',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              Text('Ended sessions will appear here', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }
}

class _SessionHistoryCard extends StatelessWidget {
  final SessionModel session;
  final VoidCallback onTap;

  const _SessionHistoryCard({required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            // Receipt thumbnail
            if (session.receiptUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  session.receiptUrl!,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _receiptPlaceholder(),
                ),
              )
            else
              _receiptPlaceholder(),

            // Info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          session.name ?? 'Shopping Session',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      _EndedBadge(),
                    ],
                  ),
                  if (session.location != null && session.location!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 3),
                        Text(session.location!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (session.startTime != null) ...[
                        const Icon(Icons.play_arrow_rounded, size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 3),
                        Text(
                          _formatDate(session.startTime!),
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(width: 12),
                      ],
                      if (session.endTime != null) ...[
                        const Icon(Icons.stop_rounded, size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 3),
                        Text(
                          _formatDate(session.endTime!),
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        'View details',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 16),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _receiptPlaceholder() {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: session.receiptUrl == null
            ? const BorderRadius.vertical(top: Radius.circular(16))
            : BorderRadius.zero,
      ),
      child: const Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_rounded, color: Color(0xFFBDBDBD), size: 24),
            SizedBox(width: 6),
            Text('No receipt uploaded', style: TextStyle(fontSize: 12, color: Color(0xFFBDBDBD))),
          ],
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${dt.day} ${months[dt.month - 1]}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}

class _EndedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(20)),
      child: const Text(
        'ENDED',
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
      ),
    );
  }
}
