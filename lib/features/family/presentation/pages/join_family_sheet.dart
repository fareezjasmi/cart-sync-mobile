import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/features/family/presentation/providers/family_providers.dart';
import 'package:cartsync/shared/providers/app_config_providers.dart';
import 'package:cartsync/utils/app_colors.dart';

class JoinFamilySheet extends ConsumerStatefulWidget {
  final VoidCallback? onJoined;

  const JoinFamilySheet({super.key, this.onJoined});

  @override
  ConsumerState<JoinFamilySheet> createState() => _JoinFamilySheetState();
}

class _JoinFamilySheetState extends ConsumerState<JoinFamilySheet> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _join() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _error = null);

    final userId = await ref.read(userIdProvider.future);
    if (userId == null || userId.isEmpty) {
      setState(() => _error = 'Could not determine user. Please log in again.');
      return;
    }

    final success = await ref
        .read(familyNotifierProvider.notifier)
        .joinFamily(_codeController.text.trim(), userId);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      widget.onJoined?.call();
    } else {
      final errMsg = ref.read(familyNotifierProvider).errorMessage;
      setState(() => _error = errMsg ?? 'Invalid or expired invite code.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(familyNotifierProvider).isLoading;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Header
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryXLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Icon(Icons.group_add_rounded, color: AppColors.primary, size: 22),
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Join a Family',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Enter the invite code shared by your family admin',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Error banner
            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: AppColors.error, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(_error!, style: TextStyle(color: AppColors.error, fontSize: 13)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Invite code field
            Text(
              'INVITE CODE',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _codeController,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => isLoading ? null : _join(),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 15, letterSpacing: 0.5),
              decoration: const InputDecoration(
                hintText: 'Paste invite code here',
                prefixIcon: Icon(Icons.vpn_key_rounded, size: 18, color: AppColors.textSecondary),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter the invite code' : null,
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: isLoading ? null : _join,
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.login_rounded, size: 20),
              label: Text(isLoading ? 'Joining...' : 'Join Family'),
            ),
          ],
        ),
      ),
    );
  }
}
