import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'logo_widget.dart';
import '../../features/auth/controllers/firebase_auth_controller.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            // Header with logo
            Container(
              padding: const EdgeInsets.only(
                top: 60,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                ),
              ),
              child: Column(
                children: [
                  // Logo
                  LogoWidget(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Premium Clothing Brand',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuItem(
                    icon: Icons.home_outlined,
                    title: 'Home',
                    onTap: () {
                      Navigator.pop(context);
                      Get.offAllNamed('/home');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.category_outlined,
                    title: 'Categories',
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed('/categories');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.shopping_bag_outlined,
                    title: 'All Products',
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed('/all-products');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.favorite_outline,
                    title: 'Wishlist',
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed('/wishlist');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.shopping_cart_outlined,
                    title: 'Cart',
                    badge: '3',
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed('/cart');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.receipt_long_outlined,
                    title: 'Orders',
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed('/orders');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'Profile',
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed('/profile');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed('/help');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed('/privacy-policy');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.admin_panel_settings_outlined,
                    title: 'Admin Panel',
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed('/admin-panel');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed('/terms-of-service');
                    },
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!, width: 1),
                ),
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    textColor: Colors.red,
                    onTap: () async {
                      Navigator.pop(context);
                      final authController = Get.find<FirebaseAuthController>();
                      await authController.signOut();
                      Get.offAllNamed('/login');
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? badge,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: textColor ?? Colors.black87),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
