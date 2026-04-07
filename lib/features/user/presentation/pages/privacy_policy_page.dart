import 'package:flutter/material.dart';
import 'package:cartsync/utils/app_colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        children: const [
          _PolicySection(
            title: 'Last updated: April 7, 2026',
            body:
                'CartSync ("we", "our", or "us") is committed to protecting your privacy. This policy explains what information we collect, how we use it, and your rights regarding your data.',
          ),
          _PolicySection(
            title: 'Information We Collect',
            body:
                'We collect the following information when you use CartSync:\n\n'
                '• Account information: username, display name, and email address.\n'
                '• Family data: family name and membership relationships.\n'
                '• Shopping data: sessions, checklists, item names, quantities, and photos you upload.\n'
                '• Receipts: images you upload to record a shopping session.\n'
                '• Device data: authentication tokens stored securely on your device.',
          ),
          _PolicySection(
            title: 'How We Use Your Information',
            body:
                'We use your information solely to:\n\n'
                '• Provide and sync CartSync features across your family group.\n'
                '• Authenticate your account and keep your session secure.\n'
                '• Display your shopping history and statistics within the app.',
          ),
          _PolicySection(
            title: 'Data Sharing',
            body:
                'We do not sell, rent, or share your personal information with third parties for marketing purposes. Your shopping data is shared only with members of the same family group you belong to within the app.',
          ),
          _PolicySection(
            title: 'Data Storage & Security',
            body:
                'Your data is stored on our servers and transmitted over encrypted connections (HTTPS/WSS). Authentication tokens are stored in secure on-device storage. We take reasonable measures to protect your data, but no system is completely secure.',
          ),
          _PolicySection(
            title: 'Data Retention',
            body:
                'We retain your account and shopping data for as long as your account is active. You may request deletion of your account and associated data by contacting us.',
          ),
          _PolicySection(
            title: 'Your Rights',
            body:
                'You have the right to:\n\n'
                '• Access the personal data we hold about you.\n'
                '• Request correction of inaccurate data.\n'
                '• Request deletion of your account and data.\n\n'
                'To exercise any of these rights, please contact us at the address below.',
          ),
          _PolicySection(
            title: 'Children\'s Privacy',
            body:
                'CartSync is not intended for children under 13. We do not knowingly collect personal information from children under 13.',
          ),
          _PolicySection(
            title: 'Changes to This Policy',
            body:
                'We may update this privacy policy from time to time. We will notify you of significant changes by updating the date at the top of this page.',
          ),
          _PolicySection(
            title: 'Contact Us',
            body: 'If you have any questions about this privacy policy, please contact us at fareezjasmi1@gmail.com.',
          ),
        ],
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final String body;

  const _PolicySection({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1)),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(body, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.55)),
          ],
        ),
      ),
    );
  }
}
