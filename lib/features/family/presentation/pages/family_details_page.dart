import 'package:cartsync/features/family/data/models/family_model.dart';
import 'package:cartsync/features/session/presentation/providers/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/shared/providers/app_config_providers.dart';
import 'package:cartsync/shared/widgets/base_screen_wrapper.dart';
import 'package:cartsync/utils/app_colors.dart';

class FamilyDetailsPage extends ConsumerStatefulWidget {
  final FamilyModel familyModel;
  const FamilyDetailsPage({super.key, required this.familyModel});

  @override
  ConsumerState<FamilyDetailsPage> createState() => _FamilyDetailsPageState();
}

class _FamilyDetailsPageState extends ConsumerState<FamilyDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSessions());
  }

  Future<void> _loadSessions() async {
    final userId = await ref.read(userIdProvider.future);
    if (userId != null && userId.isNotEmpty) {
      ref
          .read(sessionNotifierProvider.notifier)
          .loadAllSessions(widget.familyModel.familyId ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionNotifierProvider);
    return BaseScreenWrapper(
      title: widget.familyModel.name ?? 'Family Details',
      isLoading: state.isLoading,
      hasBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                state.errorMessage!,
                style: TextStyle(color: AppColors.error),
              ),
            ),
          if (state.allSession != null && state.allSession!.isNotEmpty) ...[
            ...state.allSession!.map(
              (session) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(
                      Icons.family_restroom,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    session.name ?? 'Unnamed session',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'ID: ${session.sessionId ?? '-'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/session-detail',
                      arguments: session.sessionId,
                    );
                  },
                ),
              ),
            ),
          ] else ...[
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Icon(
                    Icons.family_restroom,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Session yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create or join a family to get started.',
                    style: TextStyle(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/create-family'),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Family'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
