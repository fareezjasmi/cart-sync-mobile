import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/features/session/presentation/providers/session_providers.dart';
import 'package:cartsync/shared/providers/app_config_providers.dart';
import 'package:cartsync/shared/widgets/loading_indicator.dart';
import 'package:cartsync/utils/app_colors.dart';

class CreateSessionPage extends ConsumerStatefulWidget {
  const CreateSessionPage({super.key});

  @override
  ConsumerState<CreateSessionPage> createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends ConsumerState<CreateSessionPage> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static const _quickLocations = [
    'Giant Supermarket',
    'Aeon Mall',
    'Mr DIY',
    'Mydin',
    'Tesco',
    'Jaya Grocer',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _onCreate() async {
    if (!_formKey.currentState!.validate()) return;
    final familyId = await ref.read(familyIdProvider.future);
    final userId = await ref.read(userIdProvider.future);
    final success = await ref.read(sessionNotifierProvider.notifier).createSession(
          familyId: familyId ?? '',
          name: _nameController.text.trim(),
          location: _locationController.text.trim(),
          shopperUserId: userId,
        );
    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionNotifierProvider);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(title: const Text('New Session')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state.errorMessage != null) ...[
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
                            child: Text(state.errorMessage!, style: TextStyle(color: AppColors.error, fontSize: 13)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  _buildLabel('Session Name'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(hintText: 'e.g. Weekly Groceries'),
                    validator: (v) => v == null || v.isEmpty ? 'Enter session name' : null,
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      _buildLabel('📍 Location'),
                      const SizedBox(width: 4),
                      Text(
                        '(optional)',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _locationController,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => state.isLoading ? null : _onCreate(),
                    decoration: const InputDecoration(hintText: 'Store name or address'),
                  ),
                  const SizedBox(height: 14),

                  // Quick locations
                  Text(
                    'Quick Select',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _quickLocations.map((loc) => GestureDetector(
                      onTap: () => setState(() => _locationController.text = loc),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: _locationController.text == loc
                              ? AppColors.primary
                              : AppColors.primaryXLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          loc,
                          style: TextStyle(
                            color: _locationController.text == loc ? Colors.white : AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 28),

                  ElevatedButton(
                    onPressed: state.isLoading ? null : _onCreate,
                    child: const Text('Start Session'),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (state.isLoading) const LoadingIndicator(),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 0.6,
      ),
    );
  }
}
