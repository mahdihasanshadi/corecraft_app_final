import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/logo_widget.dart';

class TermsOfServiceView extends StatelessWidget {
  const TermsOfServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
          onPressed: () => Get.back(),
        ),
        title: const LogoWidget(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildContent(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF2C3E50),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(Icons.description, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            'Terms of Service',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: const Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'আমাদের সেবার শর্তাবলী',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Terms and conditions for using our services',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Text(
              'Last updated: January 2024',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Acceptance of Terms',
            'By accessing and using CORECRAFT mobile application and services, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
            Icons.check_circle_outline,
            Colors.green,
          ),
          _buildSection(
            'Use License',
            'Permission is granted to temporarily download one copy of CORECRAFT mobile application for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not modify or copy the materials.',
            Icons.description,
            Colors.blue,
          ),
          _buildSection(
            'User Accounts',
            'When you create an account with us, you must provide information that is accurate, complete, and current at all times. You are responsible for safeguarding the password and for all activities that occur under your account.',
            Icons.account_circle,
            Colors.purple,
          ),
          _buildSection(
            'Product Information',
            'We strive to provide accurate product descriptions, images, and pricing. However, we do not warrant that product descriptions or other content is accurate, complete, reliable, current, or error-free.',
            Icons.shopping_bag,
            Colors.orange,
          ),
          _buildSection(
            'Payment Terms',
            'All payments are processed securely. We accept various payment methods including cash on delivery. Prices are subject to change without notice. All prices are in Bangladeshi Taka (৳) unless otherwise specified.',
            Icons.payment,
            Colors.teal,
          ),
          _buildSection(
            'Shipping and Delivery',
            'We provide shipping services within Bangladesh. Delivery times may vary depending on location. We are not responsible for delays caused by shipping carriers or circumstances beyond our control.',
            Icons.local_shipping,
            Colors.indigo,
          ),
          _buildSection(
            'Returns and Refunds',
            'We offer returns and refunds in accordance with our return policy. Items must be returned in original condition within the specified timeframe. Refunds will be processed according to the original payment method.',
            Icons.undo,
            Colors.red,
          ),
          _buildSection(
            'Prohibited Uses',
            'You may not use our service for any unlawful purpose or to solicit others to perform unlawful acts. You may not violate any international, federal, provincial, or state regulations, rules, laws, or local ordinances.',
            Icons.block,
            Colors.deepOrange,
          ),
          _buildSection(
            'Intellectual Property',
            'The service and its original content, features, and functionality are and will remain the exclusive property of CORECRAFT and its licensors. The service is protected by copyright, trademark, and other laws.',
            Icons.copyright,
            Colors.brown,
          ),
          _buildSection(
            'Privacy Policy',
            'Your privacy is important to us. Please review our Privacy Policy, which also governs your use of the service, to understand our practices.',
            Icons.privacy_tip,
            Colors.cyan,
          ),
          _buildSection(
            'Termination',
            'We may terminate or suspend your account and bar access to the service immediately, without prior notice or liability, under our sole discretion, for any reason whatsoever and without limitation.',
            Icons.exit_to_app,
            Colors.pink,
          ),
          _buildSection(
            'Disclaimer',
            'The information on this service is provided on an "as is" basis. To the fullest extent permitted by law, this Company excludes all representations, warranties, conditions and terms relating to our service.',
            Icons.warning,
            Colors.amber,
          ),
          _buildSection(
            'Governing Law',
            'These terms shall be interpreted and governed by the laws of Bangladesh, without regard to its conflict of law provisions. Our failure to enforce any right or provision of these terms will not be considered a waiver of those rights.',
            Icons.gavel,
            Colors.grey,
          ),
          _buildSection(
            'Changes to Terms',
            'We reserve the right, at our sole discretion, to modify or replace these terms at any time. If a revision is material, we will provide at least 30 days notice prior to any new terms taking effect.',
            Icons.update,
            Colors.lightBlue,
          ),
          _buildSection(
            'Contact Information',
            'If you have any questions about these Terms of Service, please contact us at support@corecraft.bd or call our customer service at 01812-345678.',
            Icons.contact_support,
            Colors.deepPurple,
          ),
          const SizedBox(height: 20),
          _buildContactCard(),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: const Color(0xFF2C3E50),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.description_outlined, size: 48, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            'Questions About Terms?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Our legal team is here to help you understand our terms of service and answer any questions you may have.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _contactLegalTeam(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Contact Us',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _downloadTerms(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2C3E50),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Download PDF',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _contactLegalTeam() {
    Get.snackbar(
      'Legal Team',
      'Contacting legal team...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF2C3E50),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _downloadTerms() {
    Get.snackbar(
      'Download',
      'Downloading Terms of Service PDF...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
