import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/logo_widget.dart';
import '../../../core/widgets/app_drawer.dart';

import '../../wishlist/controllers/wishlist_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../product/controllers/firestore_product_controller.dart';
import '../../product/models/firestore_product.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: const Color(0xFFE8F5E8), // Light green background
      body: Builder(
        builder: (context) => Obx(() {
          try {
            if (!Get.isRegistered<FirestoreProductController>())
              return const Center(child: Text('Loading...'));
            final firestoreController = Get.find<FirestoreProductController>();

            if (firestoreController.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () async {
                await firestoreController.loadProducts();
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40), // Status bar space
                    // Top Navigation
                    _buildTopNavigation(context),

                    const SizedBox(height: 24),

                    // Search Bar
                    _buildSaleBanner(context),

                    const SizedBox(height: 24),

                    // Categories
                    _buildCategories(context),

                    const SizedBox(height: 24),

                    // New Arrivals Section
                    _buildNewArrivals(context),

                    const SizedBox(height: 100), // Bottom navigation space
                  ],
                ),
              ),
            );
          } catch (e) {
            // If controller is not found, show loading and try to initialize it
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!Get.isRegistered<FirestoreProductController>()) {
                Get.put(FirestoreProductController());
              }
            });
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading...'),
                ],
              ),
            );
          }
        }),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildSaleBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🎉 SPECIAL OFFER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '20% OFF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'On All Items',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Shop Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_offer, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, FirestoreProduct product) {
    return GestureDetector(
      onTap: () {
        // Convert FirestoreProduct to Map for simple product detail view
        final productMap = {
          'id': product.id,
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'originalPrice': product.isOnSale ? product.salePrice : null,
          'image': product.images.isNotEmpty ? product.images.first : '',
          'images': product.images,
          'category': product.category,
          'brand': product.brand,
          'sizes': product.sizes,
          'colors': product.colors,
          'material': product.material,
          'fitType': product.fitType,
          'careInstructions': product.careInstructions,
          'stock': product.stock,
          'rating': product.rating,
          'reviews': product.reviewCount,
          'isFeatured': product.isFeatured,
          'isNew': product.isNew,
          'isOnSale': product.isOnSale,
          'salePrice': product.salePrice,
        };
        Get.toNamed('/simple-product', arguments: {'product': productMap});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          product.images.isNotEmpty
                              ? product.images.first
                              : 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=300&h=300&fit=crop',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Wishlist button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        _addToWishlist(product);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          size: 16,
                          color: Color(0xFFE74C3C),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Info - Fixed height to prevent overflow
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Product details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          product.formattedPrice,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: const Color(0xFF4CAF50),
                              ),
                        ),
                      ],
                    ),
                    // Add to Cart Button
                    SizedBox(
                      width: double.infinity,
                      height: 26,
                      child: Obx(() {
                        final cartController = Get.find<CartController>();
                        final isLoading = cartController.isProductLoading(
                          product.id,
                        );

                        return ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  // Add to cart functionality
                                  _addToCart(product);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isLoading
                                ? Colors.grey[400]
                                : const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 2),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Add to Cart',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              // Already on home, just refresh
              Get.offAllNamed('/home');
            },
            child: Icon(Icons.home, color: const Color(0xFF4CAF50), size: 28),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to wishlist page
              Get.toNamed('/wishlist');
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFFE74C3C),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite, color: Colors.white, size: 28),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to cart page
              Get.toNamed('/cart');
            },
            child: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.grey[600],
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Hamburger Menu - Simple and clean
          GestureDetector(
            onTap: () {
              // Open drawer or navigate to menu
              Scaffold.of(context).openDrawer();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.menu, size: 24, color: Colors.black87),
            ),
          ),

          // CORECRAFT Logo - Prominent and clean
          GestureDetector(
            onTap: () {
              // Navigate to home or refresh
              Get.offAllNamed('/home');
            },
            child: LogoWidget(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),

          // Profile Icon - Clean and simple
          GestureDetector(
            onTap: () {
              // Navigate to profile page
              Get.toNamed('/profile');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.person_outline,
                size: 24,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to all categories page
                    Get.toNamed('/categories');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Explore our clothing categories',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        SizedBox(
          height: 140,
          child: Obx(() {
            try {
              if (!Get.isRegistered<FirestoreProductController>()) {
                return const Center(child: Text('Loading...'));
              }
              final firestoreController =
                  Get.find<FirestoreProductController>();
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: firestoreController.categories.length,
                itemBuilder: (context, index) {
                  final categoryName = firestoreController.categories[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to specific category page
                      switch (categoryName.toLowerCase()) {
                        case 'streetwear':
                          Get.toNamed('/streetwear');
                          break;
                        case 'jerseys':
                          Get.toNamed('/jerseys');
                          break;
                        case 'casual shirts':
                          Get.toNamed('/casual-shirts');
                          break;
                        default:
                          Get.toNamed('/categories');
                      }
                    },
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: _getCategoryColor(categoryName),
                              borderRadius: BorderRadius.circular(35),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              _getCategoryIcon(categoryName),
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Flexible(
                            child: Text(
                              categoryName,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } catch (e) {
              return const Center(child: Text('Loading categories...'));
            }
          }),
        ),
      ],
    );
  }

  Widget _buildNewArrivals(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Arrivals',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to all products page
                    Get.toNamed('/products');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Discover the latest styles',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Obx(() {
          try {
            if (!Get.isRegistered<FirestoreProductController>())
              return const Center(child: Text('Loading...'));
            final firestoreController = Get.find<FirestoreProductController>();
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.82,
              ),
              itemCount: firestoreController.featuredProducts.length,
              itemBuilder: (context, index) {
                final product = firestoreController.featuredProducts[index];
                return _buildProductCard(context, product);
              },
            );
          } catch (e) {
            return const Center(child: Text('Loading products...'));
          }
        }),
      ],
    );
  }

  void _addToCart(FirestoreProduct product) {
    if (!Get.isRegistered<CartController>()) {
      Get.snackbar('Error', 'Cart service not available');
      return;
    }
    final cartController = Get.find<CartController>();
    final productMap = {
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'image': product.images.isNotEmpty
          ? product.images.first
          : 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=300&h=300&fit=crop',
      'images': product.images,
      'category': product.category,
      'brand': product.brand,
      'sizes': product.sizes,
      'colors': product.colors,
      'material': product.material,
      'fitType': product.fitType,
      'careInstructions': product.careInstructions,
      'stock': product.stock,
      'rating': product.rating,
      'reviewCount': product.reviewCount,
      'isFeatured': product.isFeatured,
      'isNew': product.isNew,
      'isOnSale': product.isOnSale,
      'salePrice': product.salePrice,
    };
    cartController.addToCart(productMap);
  }

  void _addToWishlist(FirestoreProduct product) {
    if (!Get.isRegistered<WishlistController>()) {
      Get.snackbar('Error', 'Wishlist service not available');
      return;
    }
    final wishlistController = Get.find<WishlistController>();
    final productMap = {
      'id': product.id,
      'name': product.name,
      'price': product.price,
      'image': product.images.isNotEmpty
          ? product.images.first
          : 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=300&h=300&fit=crop',
      'images': product.images,
      'category': product.category,
      'brand': product.brand,
      'sizes': product.sizes,
      'colors': product.colors,
      'material': product.material,
      'fitType': product.fitType,
      'careInstructions': product.careInstructions,
      'stock': product.stock,
      'rating': product.rating,
      'reviewCount': product.reviewCount,
      'isFeatured': product.isFeatured,
      'isNew': product.isNew,
      'isOnSale': product.isOnSale,
      'salePrice': product.salePrice,
    };
    wishlistController.addToWishlist(productMap);
  }

  Color _getCategoryColor(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'streetwear':
        return const Color(0xFF4CAF50);
      case 'jerseys':
        return const Color(0xFF2196F3);
      case 'casual shirts':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'streetwear':
        return Icons.streetview;
      case 'jerseys':
        return Icons.sports;
      case 'casual shirts':
        return Icons.checkroom;
      default:
        return Icons.category;
    }
  }
}
