import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/features/checklist/presentation/providers/checklist_providers.dart';
import 'package:cartsync/shared/widgets/loading_indicator.dart';
import 'package:cartsync/utils/app_colors.dart';

class CreateChecklistPage extends ConsumerStatefulWidget {
  final String sessionId;
  const CreateChecklistPage({super.key, required this.sessionId});

  @override
  ConsumerState<CreateChecklistPage> createState() => _CreateChecklistPageState();
}

class _CreateChecklistPageState extends ConsumerState<CreateChecklistPage> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static const _suggestions = [
    ('🥗', 'Produce'),
    ('🥛', 'Dairy'),
    ('🍔', 'Snacks'),
    ('🧹', 'Cleaning'),
    ('💊', 'Health'),
    ('🥩', 'Meat'),
    ('🥖', 'Bakery'),
    ('🧴', 'Personal Care'),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onCreate() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref
        .read(checklistNotifierProvider.notifier)
        .createChecklist(widget.sessionId, _nameController.text.trim());
    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(checklistNotifierProvider);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(title: const Text('New Checklist')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icon display
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: const [
                        Text('📋', style: TextStyle(fontSize: 48)),
                        SizedBox(height: 8),
                        Text(
                          'Shopping Checklist',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

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

                  _buildLabel('Checklist Name'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => state.isLoading ? null : _onCreate(),
                    decoration: const InputDecoration(hintText: 'e.g. Fresh Produce'),
                    validator: (v) => v == null || v.isEmpty ? 'Enter checklist name' : null,
                  ),
                  const SizedBox(height: 20),

                  // Suggestions
                  Text(
                    'Suggestions',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _suggestions.map(((String, String) s) {
                      return GestureDetector(
                        onTap: () => setState(() => _nameController.text = s.$2),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppColors.primaryXLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${s.$1} ${s.$2}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),

                  ElevatedButton(
                    onPressed: state.isLoading ? null : _onCreate,
                    child: const Text('Create Checklist'),
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
