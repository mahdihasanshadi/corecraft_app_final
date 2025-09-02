import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/logo_widget.dart';
import '../controllers/wishlist_controller.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.put(WishlistController());

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E8),
      appBar: AppBar(
        title: const LogoWidget(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black87,
            ),
            onPressed: () => Get.toNamed('/cart'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Wishlist',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    '${wishlistController.wishlistItems.length} items saved',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Wishlist Items
          Expanded(
            child: Obx(() {
              if (wishlistController.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF4CAF50),
                    ),
                  ),
                );
              }

              return wishlistController.wishlistItems.isEmpty
                  ? _buildEmptyWishlist(context)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: wishlistController.wishlistItems.length,
                      itemBuilder: (context, index) {
                        final item = wishlistController.wishlistItems[index];
                        return _buildWishlistItem(context, item);
                      },
                    );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWishlist(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.favorite_border,
              size: 60,
              color: Color(0xFFE74C3C),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Your wishlist is empty',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start adding items you love!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Get.offAllNamed('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Start Shopping',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistItem(BuildContext context, Map<String, dynamic> item) {
    final productId = item['id']?.toString() ?? '';
    final productName = item['name']?.toString() ?? 'Unknown Product';
    final productPrice = _parseDouble(item['price']) ?? 0.0;
    final productCategory = item['category']?.toString() ?? 'Unknown Category';
    final productImage = _getProductImage(item);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Product Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              image: DecorationImage(
                image: NetworkImage(productImage),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Product Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    productCategory,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '৳${productPrice.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: const Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons
          Column(
            children: [
              // Remove from wishlist
              IconButton(
                onPressed: () => _removeFromWishlist(item),
                icon: const Icon(
                  Icons.favorite,
                  color: Color(0xFFE74C3C),
                  size: 24,
                ),
              ),
              // Add to cart
              IconButton(
                onPressed: () => _addToCart(item),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _removeFromWishlist(Map<String, dynamic> item) {
    final wishlistController = Get.find<WishlistController>();
    final productId = item['id'] ?? '';
    if (productId.isNotEmpty) {
      wishlistController.removeFromWishlist(productId);
    }
  }

  void _addToCart(Map<String, dynamic> item) {
    final wishlistController = Get.find<WishlistController>();
    wishlistController.addToCart(item);
  }

  // Helper method to safely parse double values
  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  // Helper method to safely get product image
  String _getProductImage(Map<String, dynamic> item) {
    // Try to get image from 'image' field first
    final image = item['image'];
    if (image != null && image.toString().isNotEmpty) {
      return image.toString();
    }
    
    // Try to get from 'images' array
    final images = item['images'];
    if (images is List && images.isNotEmpty) {
      final firstImage = images.first;
      if (firstImage != null && firstImage.toString().isNotEmpty) {
        return firstImage.toString();
      }
    }
    
    // Return default image
    return 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=400';
  }
}
