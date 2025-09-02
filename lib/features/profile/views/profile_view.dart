import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/widgets/logo_widget.dart';
import '../../auth/controllers/firebase_auth_controller.dart';
import '../../auth/controllers/user_profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final profileController = Get.find<UserProfileController>();

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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Obx(() => _buildProfileHeader(context, user, profileController)),

            const SizedBox(height: 30),

            // Account Information
            _buildSectionTitle(context, 'Account Information'),
            const SizedBox(height: 16),
            _buildAccountInfo(context),

            const SizedBox(height: 30),

            // Preferences
            _buildSectionTitle(context, 'Preferences'),
            const SizedBox(height: 16),
            _buildPreferences(context),

            const SizedBox(height: 30),

            // Support & Legal
            _buildSectionTitle(context, 'Support & Legal'),
            const SizedBox(height: 16),
            _buildSupportLegal(context),

            const SizedBox(height: 30),

            // Logout Button
            _buildLogoutButton(context),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    User? user,
    UserProfileController profileController,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Row(
        children: [
          // Profile Picture
          GestureDetector(
            onTap: () => _showImagePickerDialog(profileController),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.grey[200],
                image: profileController.profileImageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(profileController.profileImageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: profileController.profileImageUrl == null
                  ? Center(
                      child: Text(
                        profileController.initials,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 20),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileController.displayName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? 'user@example.com',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Premium Member',
                    style: TextStyle(
                      color: const Color(0xFF4CAF50),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Edit Button
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.edit, size: 20, color: Colors.black87),
            ),
            onPressed: () {
              Get.toNamed('/edit-profile');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  Widget _buildAccountInfo(BuildContext context) {
    return Container(
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
        children: [
          _buildProfileItem(
            icon: Icons.person_outline,
            title: 'Account Information',
            subtitle: 'Manage your account details',
            onTap: () {
              Get.toNamed('/account-info');
            },
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.location_on_outlined,
            title: 'Shipping Addresses',
            subtitle: 'Manage your delivery addresses',
            onTap: () {
              Get.snackbar(
                'Shipping Addresses',
                'Address management coming soon!',
                snackPosition: SnackPosition.TOP,
                backgroundColor: const Color(0xFF4CAF50),
                colorText: Colors.white,
              );
            },
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.payment_outlined,
            title: 'Payment Methods',
            subtitle: 'Credit cards, PayPal, etc.',
            onTap: () {
              Get.snackbar(
                'Payment Methods',
                'Payment settings coming soon!',
                snackPosition: SnackPosition.TOP,
                backgroundColor: const Color(0xFF4CAF50),
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreferences(BuildContext context) {
    return Container(
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
        children: [
          _buildProfileItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Email, push notifications',
            trailing: Switch(
              value: true,
              onChanged: (value) {
                Get.snackbar(
                  'Notifications',
                  'Notification settings updated!',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: const Color(0xFF4CAF50),
                  colorText: Colors.white,
                );
              },
              activeColor: const Color(0xFF4CAF50),
            ),
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: 'English (US)',
            onTap: () {
              Get.snackbar(
                'Language',
                'Language selection coming soon!',
                snackPosition: SnackPosition.TOP,
                backgroundColor: const Color(0xFF4CAF50),
                colorText: Colors.white,
              );
            },
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: 'Switch to dark theme',
            trailing: Switch(
              value: false,
              onChanged: (value) {
                Get.snackbar(
                  'Dark Mode',
                  'Dark mode coming soon!',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: const Color(0xFF4CAF50),
                  colorText: Colors.white,
                );
              },
              activeColor: const Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportLegal(BuildContext context) {
    return Container(
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
        children: [
          _buildProfileItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'FAQ, contact us',
            onTap: () {
              Get.toNamed('/help');
            },
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'How we protect your data',
            onTap: () {
              Get.snackbar(
                'Privacy Policy',
                'Privacy policy page coming soon!',
                snackPosition: SnackPosition.TOP,
                backgroundColor: const Color(0xFF4CAF50),
                colorText: Colors.white,
              );
            },
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            subtitle: 'Our terms and conditions',
            onTap: () {
              Get.snackbar(
                'Terms of Service',
                'Terms of service page coming soon!',
                snackPosition: SnackPosition.TOP,
                backgroundColor: const Color(0xFF4CAF50),
                colorText: Colors.white,
              );
            },
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'App version 1.0.0',
            onTap: () {
              Get.snackbar(
                'About',
                'About page coming soon!',
                snackPosition: SnackPosition.TOP,
                backgroundColor: const Color(0xFF4CAF50),
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
      trailing:
          trailing ??
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey[200],
      indent: 60,
      endIndent: 20,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Get.dialog(
            AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Get.back();
                    final authController = Get.find<FirebaseAuthController>();
                    await authController.signOut();
                    Get.offAllNamed('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Logout',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showImagePickerDialog(UserProfileController profileController) {
    Get.dialog(
      AlertDialog(
        title: const Text('Update Profile Photo'),
        content: const Text('Choose how you want to update your profile photo'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              profileController.uploadProfileImage();
            },
            child: const Text('Choose from Gallery'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              profileController.takeProfilePhoto();
            },
            child: const Text('Take Photo'),
          ),
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ],
      ),
    );
  }
}
