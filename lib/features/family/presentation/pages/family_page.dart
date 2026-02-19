import 'package:cartsync/utils/secure_storage_service.dart';
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
    final userId = await ref.read(userIdProvider.future);
    if (userId != null && userId.isNotEmpty) {
      ref.read(familyNotifierProvider.notifier).loadFamily(userId);
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
              decoration: BoxDecoration(color: AppColors.errorLight, borderRadius: BorderRadius.circular(8)),
              child: Text(state.errorMessage!, style: TextStyle(color: AppColors.error)),
            ),
          if (state.familyList != null && state.familyList!.isNotEmpty) ...[
            ...state.familyList!.map(
              (family) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.family_restroom, color: AppColors.primary),
                  ),
                  title: Text(
                    family.name ?? 'Unnamed Family',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  subtitle: Text(
                    'ID: ${family.familyId ?? '-'}',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
                  onTap: () {
                    Navigator.pushNamed(context, '/family-detail', arguments: family);
                    StorageService.instance.writeData('familyId', family.familyId ?? '');
                  },
                ),
              ),
            ),
          ] else ...[
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Icon(Icons.family_restroom, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text('No family yet', style: TextStyle(fontSize: 18, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text(
                    'Create or join a family to get started.',
                    style: TextStyle(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/create-family'),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Family'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
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
