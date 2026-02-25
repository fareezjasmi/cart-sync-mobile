import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cartsync/features/item/data/models/item_model.dart';
import 'package:cartsync/features/item/presentation/providers/item_providers.dart';
import 'package:cartsync/shared/widgets/loading_indicator.dart';
import 'package:cartsync/utils/app_colors.dart';

class UpdateItemPage extends ConsumerStatefulWidget {
  final ItemModel item;
  const UpdateItemPage({super.key, required this.item});

  @override
  ConsumerState<UpdateItemPage> createState() => _UpdateItemPageState();
}

class _UpdateItemPageState extends ConsumerState<UpdateItemPage> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  bool _imageRemoved = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.item.name ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        _imageRemoved = false;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _imageRemoved = true;
    });
  }

  Future<void> _onUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    // If user removed the existing image and didn't pick a new one, pass null image
    final existingImage = _imageRemoved ? null : widget.item.image;
    final updatedItem = widget.item.copyWith(
      name: _nameController.text.trim(),
      image: existingImage,
    );

    final success = await ref
        .read(itemNotifierProvider.notifier)
        .updateItem(updatedItem, imageFile: _selectedImage);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(itemNotifierProvider);

    // Determine what image to show in the preview
    final hasNewImage = _selectedImage != null;
    final hasExistingImage = !_imageRemoved && widget.item.image != null;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(title: const Text('Edit Item')),
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

                  _buildLabel('Item Name'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.sentences,
                    onFieldSubmitted: (_) => state.isLoading ? null : _onUpdate(),
                    decoration: const InputDecoration(hintText: 'e.g. Broccoli, Milk, Eggs'),
                    validator: (v) => v == null || v.isEmpty ? 'Enter item name' : null,
                  ),
                  const SizedBox(height: 20),

                  // Photo section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildLabel('Photo'),
                          const SizedBox(width: 6),
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
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE0E0E0),
                            width: 1.5,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          children: [
                            if (hasNewImage) ...[
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      _selectedImage!,
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _removeImage,
                                    child: Container(
                                      margin: const EdgeInsets.all(6),
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close, color: Colors.white, size: 16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                            ] else if (hasExistingImage) ...[
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      widget.item.image!,
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => Container(
                                        height: 160,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryXLight,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(Icons.broken_image_outlined, color: AppColors.primary, size: 40),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _removeImage,
                                    child: Container(
                                      margin: const EdgeInsets.all(6),
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close, color: Colors.white, size: 16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                            ] else ...[
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryXLight,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: AppColors.primary,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Add a photo',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Take or choose from gallery',
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 14),
                            ],
                            Row(
                              children: [
                                Expanded(
                                  child: _buildPhotoBtn(
                                    icon: Icons.camera_alt_outlined,
                                    label: 'Camera',
                                    onTap: () => _pickImage(ImageSource.camera),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildPhotoBtn(
                                    icon: Icons.photo_library_outlined,
                                    label: 'Gallery',
                                    onTap: () => _pickImage(ImageSource.gallery),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  ElevatedButton(
                    onPressed: state.isLoading ? null : _onUpdate,
                    child: const Text('Save Changes'),
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

  Widget _buildPhotoBtn({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryXLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
