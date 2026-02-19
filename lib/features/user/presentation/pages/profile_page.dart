import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartsync/features/user/presentation/providers/user_providers.dart';
import 'package:cartsync/shared/providers/app_config_providers.dart';
import 'package:cartsync/utils/app_colors.dart';
import 'package:cartsync/main.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userNotifierProvider.notifier).loadCurrentUser();
    });
  }

  Future<void> _logout() async {
    await ref.read(clearSessionProvider.notifier).clear();
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (_) => false);
  }

  void _showEditProfileSheet(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36, height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 24),
              const Text(
                'DISPLAY NAME',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: controller,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Your display name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8F8F8),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await ref.read(userNotifierProvider.notifier).updateUser(name: controller.text.trim());
                },
                child: const Text('Save Changes'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userNotifierProvider);
    final usernameAsync = ref.watch(usernameProvider);
    final user = state.user;
    final displayName = user?.name ?? '';
    final username = usernameAsync.value ?? user?.username ?? '';

    String initials = '';
    if (displayName.trim().isNotEmpty) {
      initials = displayName.trim().split(' ').take(2).map((w) => w[0].toUpperCase()).join();
    } else if (username.isNotEmpty) {
      initials = username[0].toUpperCase();
    } else {
      initials = 'U';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: state.isLoading && user == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildProfileHeader(
                    context,
                    initials: initials,
                    displayName: displayName.isNotEmpty ? displayName : username,
                    username: username,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      if (state.errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.errorLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(state.errorMessage!, style: TextStyle(color: AppColors.error, fontSize: 13)),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Account section
                      _buildSectionLabel('Account'),
                      const SizedBox(height: 8),
                      _buildCard([
                        _buildSettingsRow(
                          icon: Icons.person_outline_rounded,
                          iconBg: AppColors.primaryXLight,
                          iconColor: AppColors.primary,
                          title: 'Edit Profile',
                          subtitle: 'Change display name',
                          onTap: () => _showEditProfileSheet(context, displayName),
                        ),
                        _buildDivider(),
                        _buildSettingsRow(
                          icon: Icons.bar_chart_rounded,
                          iconBg: AppColors.primaryXLight,
                          iconColor: AppColors.primary,
                          title: 'Shopping Stats',
                          subtitle: 'View your activity history',
                          onTap: () {},
                        ),
                      ]),
                      const SizedBox(height: 20),

                      // Preferences section
                      _buildSectionLabel('Preferences'),
                      const SizedBox(height: 8),
                      _buildCard([
                        _buildSettingsRow(
                          icon: Icons.notifications_outlined,
                          iconBg: AppColors.primaryXLight,
                          iconColor: AppColors.primary,
                          title: 'Notifications',
                          subtitle: 'Item updates, session alerts',
                          trailing: _buildToggle(true),
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildSettingsRow(
                          icon: Icons.settings_outlined,
                          iconBg: AppColors.primaryXLight,
                          iconColor: AppColors.primary,
                          title: 'App Settings',
                          subtitle: 'Theme, language & more',
                          onTap: () {},
                        ),
                      ]),
                      const SizedBox(height: 20),

                      // Sign out
                      _buildCard([
                        _buildSettingsRow(
                          icon: Icons.logout_rounded,
                          iconBg: const Color(0xFFFFEBEE),
                          iconColor: AppColors.error,
                          title: 'Sign Out',
                          titleColor: AppColors.error,
                          onTap: _logout,
                          showChevron: false,
                        ),
                      ]),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context, {
    required String initials,
    required String displayName,
    required String username,
  }) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: AppColors.primaryLight.withValues(alpha: 0.5),
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _showEditProfileSheet(context, displayName),
                      child: Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: const Icon(Icons.edit_rounded, size: 14, color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                displayName.isNotEmpty ? displayName : 'User',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                username.isNotEmpty ? '@$username' : '',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1)),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 64),
      child: Divider(height: 1, color: Color(0xFFF5F5F5)),
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    String? subtitle,
    Color titleColor = AppColors.textPrimary,
    Widget? trailing,
    required VoidCallback onTap,
    bool showChevron = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: titleColor),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ],
              ),
            ),
            trailing ??
                (showChevron
                    ? const Icon(Icons.chevron_right_rounded, color: Color(0xFFBDBDBD), size: 20)
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(bool isOn) {
    return Container(
      width: 44, height: 26,
      decoration: BoxDecoration(
        color: isOn ? AppColors.primary : const Color(0xFFBDBDBD),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Align(
        alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            width: 22, height: 22,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
