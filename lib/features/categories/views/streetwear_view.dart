import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/logo_widget.dart';
import '../../wishlist/controllers/wishlist_controller.dart';
import '../../cart/controllers/cart_controller.dart';

class StreetwearView extends StatefulWidget {
  const StreetwearView({super.key});

  @override
  State<StreetwearView> createState() => _StreetwearViewState();
}

class _StreetwearViewState extends State<StreetwearView> {
  final List<Map<String, dynamic>> _products = [
    {
      'id': 'sw1',
      'name': 'Oversized Streetwear Hoodie',
      'price': 1299.00,
      'originalPrice': 1499.00,
      'image':
          'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=400',
      'rating': 4.8,
      'reviews': 256,
    },
    {
      'id': 'sw2',
      'name': 'Cargo Streetwear Pants',
      'price': 1499.00,
      'originalPrice': null,
      'image':
          'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=400',
      'rating': 4.5,
      'reviews': 167,
    },
    {
      'id': 'sw3',
      'name': 'Graphic Streetwear T-Shirt',
      'price': 699.00,
      'originalPrice': 899.00,
      'image':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      'rating': 4.6,
      'reviews': 189,
    },
    {
      'id': 'sw4',
      'name': 'Streetwear Denim Jacket',
      'price': 2199.00,
      'originalPrice': null,
      'image':
          'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=400',
      'rating': 4.7,
      'reviews': 234,
    },
    {
      'id': 'sw5',
      'name': 'Streetwear Track Pants',
      'price': 1199.00,
      'originalPrice': 1399.00,
      'image':
          'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=400',
      'rating': 4.4,
      'reviews': 145,
    },
    {
      'id': 'sw6',
      'name': 'Streetwear Bomber Jacket',
      'price': 2599.00,
      'originalPrice': null,
      'image':
          'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',
      'rating': 4.9,
      'reviews': 312,
    },
    {
      'id': 'sw7',
      'name': 'Streetwear Crop Top',
      'price': 599.00,
      'originalPrice': 799.00,
      'image':
          'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=400',
      'rating': 4.3,
      'reviews': 98,
    },
    {
      'id': 'sw8',
      'name': 'Streetwear Oversized Shirt',
      'price': 899.00,
      'originalPrice': null,
      'image':
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
      'rating': 4.5,
      'reviews': 178,
    },
    {
      'id': 'sw9',
      'name': 'Streetwear Utility Vest',
      'price': 1399.00,
      'originalPrice': 1699.00,
      'image':
          'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=400',
      'rating': 4.6,
      'reviews': 203,
    },
    {
      'id': 'sw10',
      'name': 'Streetwear High-Top Sneakers',
      'price': 2099.00,
      'originalPrice': null,
      'image':
          'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400',
      'rating': 4.8,
      'reviews': 445,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E8),
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
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.shopping_cart, color: Colors.black87),
            ),
            onPressed: () => Get.toNamed('/cart'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Streetwear',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Urban style meets comfort',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_products.length} products',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return _buildProductCard(product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final bool isOnSale = product['originalPrice'] != null;
    final double discountPercentage = isOnSale
        ? ((product['originalPrice'] - product['price']) /
                  product['originalPrice'] *
                  100)
              .roundToDouble()
        : 0;

    return GestureDetector(
      onTap: () {
        Get.toNamed('/simple-product', arguments: {'product': product});
      },
      child: Container(
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
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(product['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (isOnSale)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '-${discountPercentage.toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // Wishlist button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _addToWishlist(product),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
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

                  // Cart button
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _addToCart(product),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C3E50),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '৳${product['price'].toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFF2C3E50),
                            ),
                      ),
                      if (isOnSale) ...[
                        const SizedBox(width: 8),
                        Text(
                          '৳${product['originalPrice'].toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[500],
                              ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber[600]),
                      const SizedBox(width: 4),
                      Text(
                        product['rating'].toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product['reviews']})',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(Map<String, dynamic> product) {
    final cartController = Get.find<CartController>();
    cartController.addToCart(product);
    // The controller will handle snackbar and database sync
  }

  void _addToWishlist(Map<String, dynamic> product) {
    final wishlistController = Get.find<WishlistController>();
    wishlistController.addToWishlist(product);
  }
}
