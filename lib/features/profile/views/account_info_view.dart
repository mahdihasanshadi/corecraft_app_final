import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/logo_widget.dart';

class AccountInfoView extends StatelessWidget {
  const AccountInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Account Information',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // Personal Information Section
            _buildInfoCard(
              context,
              icon: Icons.person_outline,
              title: 'Personal Information',
              description: 'Name, email, phone number',
              onTap: () => _navigateToPersonalInfo(context),
            ),
            
            const SizedBox(height: 16),
            
            // Shipping Addresses Section
            _buildInfoCard(
              context,
              icon: Icons.location_on_outlined,
              title: 'Shipping Addresses',
              description: 'Manage your delivery addresses',
              onTap: () => _navigateToShippingAddresses(context),
            ),
            
            const SizedBox(height: 16),
            
            // Payment Methods Section
            _buildInfoCard(
              context,
              icon: Icons.credit_card_outlined,
              title: 'Payment Methods',
              description: 'Credit cards, PayPal, etc.',
              onTap: () => _navigateToPaymentMethods(context),
            ),
            
            const SizedBox(height: 40),
            
            // Additional Account Options
            _buildInfoCard(
              context,
              icon: Icons.favorite_border,
              title: 'My Wishlist',
              description: 'View your saved items',
              onTap: () => Get.toNamed('/wishlist'),
            ),
            
            const SizedBox(height: 16),
            
            _buildInfoCard(
              context,
              icon: Icons.shopping_bag_outlined,
              title: 'Order History',
              description: 'View your past orders',
              onTap: () => _navigateToOrderHistory(context),
            ),
            
            const SizedBox(height: 16),
            
            _buildInfoCard(
              context,
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              description: 'Manage your preferences',
              onTap: () => _navigateToNotifications(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
            // Icon Container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 24,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPersonalInfo(BuildContext context) {
    Get.snackbar(
      'Personal Information',
      'This feature will be implemented soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _navigateToShippingAddresses(BuildContext context) {
    Get.snackbar(
      'Shipping Addresses',
      'This feature will be implemented soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _navigateToPaymentMethods(BuildContext context) {
    Get.snackbar(
      'Payment Methods',
      'This feature will be implemented soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _navigateToOrderHistory(BuildContext context) {
    Get.snackbar(
      'Order History',
      'This feature will be implemented soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _navigateToNotifications(BuildContext context) {
    Get.snackbar(
      'Notifications',
      'This feature will be implemented soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
