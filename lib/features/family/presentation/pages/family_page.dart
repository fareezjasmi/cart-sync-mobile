import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/features/family/presentation/providers/family_providers.dart';
import 'package:cartsync/shared/providers/app_config_providers.dart';
import 'package:cartsync/shared/widgets/base_screen_wrapper.dart';
import 'package:cartsync/utils/app_colors.dart';

class FamilyPage extends ConsumerStatefulWidget {
  const FamilyPage({super.key});

  @override
  ConsumerState<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends ConsumerState<FamilyPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFamily());
  }

  Future<void> _loadFamily() async {
    final familyId = await ref.read(familyIdProvider.future);
    if (familyId != null && familyId.isNotEmpty) {
      ref.read(familyNotifierProvider.notifier).loadFamily(familyId);
      ref.read(familyNotifierProvider.notifier).loadMembers(familyId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(familyNotifierProvider);
    return BaseScreenWrapper(
      title: 'Family',
      isLoading: state.isLoading,
      hasBack: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          if (state.family != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.family_restroom, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          state.family!.name ?? 'My Family',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('ID: ${state.family!.familyId ?? '-'}',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Members',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            if (state.members.isEmpty)
              Text('No members yet.',
                  style: TextStyle(color: AppColors.textSecondary))
            else
              ...state.members.map((m) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryLight,
                      child: Icon(Icons.person, color: AppColors.primary),
                    ),
                    title: Text(m.userId ?? '-'),
                    subtitle: Text('Family: ${m.familyId ?? '-'}'),
                  )),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showAddMemberDialog(context),
                icon: const Icon(Icons.person_add),
                label: const Text('Add Member'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ] else ...[
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Icon(Icons.family_restroom,
                      size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text('No family yet',
                      style: TextStyle(
                          fontSize: 18, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text('Create or join a family to get started.',
                      style: TextStyle(color: AppColors.textSecondary),
                      textAlign: TextAlign.center),
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

  void _showAddMemberDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Member'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'User ID',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final familyId = await ref.read(familyIdProvider.future);
              if (familyId != null && controller.text.isNotEmpty) {
                Navigator.pop(ctx);
                await ref
                    .read(familyNotifierProvider.notifier)
                    .addMember(familyId, controller.text.trim());
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
