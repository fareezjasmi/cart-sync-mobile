import 'package:cartsync/features/family/data/models/family_model.dart';
import 'package:cartsync/features/family/presentation/pages/all_sessions_page.dart';
import 'package:cartsync/features/family/presentation/providers/family_providers.dart';
import 'package:cartsync/features/session/presentation/providers/session_providers.dart';
import 'package:cartsync/router/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/shared/providers/app_config_providers.dart';
import 'package:cartsync/utils/app_colors.dart';

class FamilyDetailsPage extends ConsumerStatefulWidget {
  final FamilyModel familyModel;
  const FamilyDetailsPage({super.key, required this.familyModel});

  @override
  ConsumerState<FamilyDetailsPage> createState() => _FamilyDetailsPageState();
}

class _FamilyDetailsPageState extends ConsumerState<FamilyDetailsPage> {
  bool _codeCopied = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final userId = await ref.read(userIdProvider.future);
    final familyId = widget.familyModel.familyId ?? '';
    if (userId != null && userId.isNotEmpty) {
      ref.read(sessionNotifierProvider.notifier).loadAllSessions(familyId);
    }
    if (familyId.isNotEmpty) {
      ref.read(familyNotifierProvider.notifier).loadMembers(familyId);
    }
  }

  Future<void> _copyInviteCode() async {
    final code = widget.familyModel.familyId ?? '';
    await Clipboard.setData(ClipboardData(text: code));
    setState(() => _codeCopied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _codeCopied = false);
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(sessionNotifierProvider);
    final familyState = ref.watch(familyNotifierProvider);
    final familyName = widget.familyModel.name ?? 'Family Details';
    final sessions = sessionState.allSession ?? [];
    final members = familyState.members;
    final recentSessions = sessions.take(3).toList();
    final hasMore = sessions.length > 3;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            expandedHeight: 120,
            pinned: true,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.more_vert_rounded, size: 18),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(56, 0, 56, 16),
              title: Text(
                familyName,
                style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, Color(0xFF43A047)],
                  ),
                ),
              ),
            ),
          ),
        ],
        body: RefreshIndicator(
          onRefresh: _loadData,
          color: AppColors.primary,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            children: [
              if (sessionState.errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.errorLight, borderRadius: BorderRadius.circular(12)),
                  child: Text(sessionState.errorMessage!, style: TextStyle(color: AppColors.error, fontSize: 13)),
                ),
                const SizedBox(height: 16),
              ],

              // ── Family Members ──────────────────────────────────────────
              _SectionHeader(title: 'Family Members', badge: members.isEmpty ? null : '${members.length}'),
              const SizedBox(height: 12),
              if (familyState.isLoading && members.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                  ),
                )
              else if (members.isEmpty)
                _buildEmptyMembers()
              else
                _buildMembersSection(members.map((m) => m.memberName ?? '').toList()),

              const SizedBox(height: 24),

              // ── Shopping Sessions ───────────────────────────────────────
              Row(
                children: [
                  const Text(
                    'Shopping Sessions',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  const Spacer(),
                  if (sessions.isNotEmpty)
                    _StatusBadge(
                      label: '${sessions.where((s) => s.sessionStatus == 'ACTIVE').length} Active',
                      bg: AppColors.primaryXLight,
                      fg: AppColors.primary,
                    ),
                ],
              ),
              const SizedBox(height: 12),

              if (sessionState.isLoading && sessions.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                  ),
                )
              else if (sessions.isEmpty)
                _buildEmptySessions()
              else ...[
                ...recentSessions.map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _SessionCard(
                      session: s,
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/session-detail',
                        arguments: SessionDetailsPageArgs(
                          s.sessionId ?? '',
                          widget.familyModel.isAdmin,
                          widget.familyModel.familyId ?? '',
                        ),
                      ),
                    ),
                  ),
                ),
                if (hasMore)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AllSessionsPage(
                            sessions: sessions,
                            familyId: widget.familyModel.familyId ?? '',
                            isAdmin: widget.familyModel.isAdmin,
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.list_rounded, size: 18),
                      label: Text('View all ${sessions.length} sessions'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size(double.infinity, 44),
                      ),
                    ),
                  ),
              ],

              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/create-session'),
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text('New Session'),
              ),

              const SizedBox(height: 24),

              // ── Invitation Code ─────────────────────────────────────────
              const _SectionHeader(title: 'Invite Members'),
              const SizedBox(height: 12),
              _buildInviteSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMembersSection(List<String> memberName) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1))],
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: memberName.map((name) => _MemberChip(username: name)).toList(),
      ),
    );
  }

  Widget _buildEmptyMembers() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1))],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.primaryXLight, borderRadius: BorderRadius.circular(12)),
            child: const Center(child: Text('👥', style: TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'No members yet. Share the invite code below to add family members.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySessions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(color: AppColors.primaryXLight, borderRadius: BorderRadius.circular(20)),
            child: const Center(child: Text('🛒', style: TextStyle(fontSize: 32))),
          ),
          const SizedBox(height: 14),
          const Text(
            'No sessions yet',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          const Text(
            'Start a shopping session so your\nfamily can track items in real-time.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInviteSection() {
    final code = widget.familyModel.familyId ?? '';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: AppColors.primaryXLight, borderRadius: BorderRadius.circular(10)),
                child: const Center(child: Icon(Icons.link_rounded, color: AppColors.primary, size: 18)),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Family Invite Code',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    Text(
                      'Share this code to add new members',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    code,
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'monospace',
                      color: AppColors.textPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _copyInviteCode,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _codeCopied
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.success,
                            size: 20,
                            key: ValueKey('check'),
                          )
                        : const Icon(Icons.copy_rounded, color: AppColors.primary, size: 20, key: ValueKey('copy')),
                  ),
                ),
              ],
            ),
          ),
          if (_codeCopied) ...[
            const SizedBox(height: 8),
            const Text(
              'Copied to clipboard!',
              style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w500),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? badge;

  const _SectionHeader({required this.title, this.badge});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        if (badge != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: AppColors.primaryXLight, borderRadius: BorderRadius.circular(20)),
            child: Text(
              badge!,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
          ),
        ],
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const _StatusBadge({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _MemberChip extends StatelessWidget {
  final String username;

  const _MemberChip({required this.username});

  @override
  Widget build(BuildContext context) {
    final initials = username.length >= 2 ? username.substring(0, 2).toUpperCase() : username.toUpperCase();
    // final shortId = userId.length > 12 ? '${userId.substring(0, 6)}...${userId.substring(userId.length - 4)}' : userId;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryXLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(13)),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final dynamic session;
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
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: _statusBgColor(status), borderRadius: BorderRadius.circular(14)),
              child: Center(child: Text(_statusEmoji(status), style: const TextStyle(fontSize: 20))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.name ?? 'Unnamed Session',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
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
      child: Text(
        status,
        style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w700),
      ),
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
