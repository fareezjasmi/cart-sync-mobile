import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/features/session/presentation/providers/session_providers.dart';
import 'package:cartsync/shared/providers/app_config_providers.dart';
import 'package:cartsync/shared/widgets/base_screen_wrapper.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCurrentSession());
  }

  Future<void> _loadCurrentSession() async {
    final sessionId = await ref.read(sessionIdProvider.future);
    if (sessionId != null && sessionId.isNotEmpty) {
      ref.read(sessionNotifierProvider.notifier).loadAllSessions(sessionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionNotifierProvider);
    return BaseScreenWrapper(
      title: 'Sessions',
      isLoading: state.isLoading,
      hasBack: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state.errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(8)),
              child: Text(state.errorMessage!,
                  style: TextStyle(color: AppColors.error)),
            ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/create-session'),
            icon: const Icon(Icons.add),
            label: const Text('New Session'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          if (state.currentSession != null) ...[
            Text('Current Session',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Column(
              children:   state.allSession!.map((e) => _buildSessionCard(context, e.chatId)).toList()        ,
            )
            //_buildSessionCard(context, state.currentSession!);
          ] else ...[
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Icon(Icons.shopping_cart_outlined,
                      size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text('No active session',
                      style: TextStyle(
                          fontSize: 18, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text('Create a new session to start shopping.',
                      style: TextStyle(color: AppColors.textSecondary),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, session) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/session-detail',
            arguments: session.sessionId),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      session.name ?? 'Shopping Session',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _statusChip(session.sessionStatus ?? 'ACTIVE'),
                ],
              ),
              if (session.location != null && session.location!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(session.location!,
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.arrow_forward_ios,
                      size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text('View Checklists',
                      style:
                          TextStyle(color: AppColors.primary, fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
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
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
