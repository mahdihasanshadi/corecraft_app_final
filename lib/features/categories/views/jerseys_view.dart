import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/logo_widget.dart';
import '../../wishlist/controllers/wishlist_controller.dart';
import '../../cart/controllers/cart_controller.dart';

class JerseysView extends StatefulWidget {
  const JerseysView({super.key});

  @override
  State<JerseysView> createState() => _JerseysViewState();
}

class _JerseysViewState extends State<JerseysView> {
  final List<Map<String, dynamic>> _products = [
    {
      'id': 'jr1',
      'name': 'Pro Basketball Jersey',
      'price': 1199.00,
      'originalPrice': 1399.00,
      'image':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      'rating': 4.7,
      'reviews': 198,
    },
    {
      'id': 'jr2',
      'name': 'Soccer Team Jersey',
      'price': 999.00,
      'originalPrice': null,
      'image':
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400',
      'rating': 4.3,
      'reviews': 145,
    },
    {
      'id': 'jr3',
      'name': 'Football Jersey',
      'price': 1299.00,
      'originalPrice': 1499.00,
      'image':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      'rating': 4.6,
      'reviews': 223,
    },
    {
      'id': 'jr4',
      'name': 'Baseball Jersey',
      'price': 1099.00,
      'originalPrice': null,
      'image':
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400',
      'rating': 4.4,
      'reviews': 167,
    },
    {
      'id': 'jr5',
      'name': 'Hockey Jersey',
      'price': 1399.00,
      'originalPrice': 1599.00,
      'image':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      'rating': 4.8,
      'reviews': 189,
    },
    {
      'id': 'jr6',
      'name': 'Tennis Jersey',
      'price': 899.00,
      'originalPrice': null,
      'image':
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400',
      'rating': 4.5,
      'reviews': 134,
    },
    {
      'id': 'jr7',
      'name': 'Cricket Jersey',
      'price': 999.00,
      'originalPrice': 1199.00,
      'image':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      'rating': 4.2,
      'reviews': 98,
    },
    {
      'id': 'jr8',
      'name': 'Rugby Jersey',
      'price': 1199.00,
      'originalPrice': null,
      'image':
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400',
      'rating': 4.6,
      'reviews': 156,
    },
    {
      'id': 'jr9',
      'name': 'Volleyball Jersey',
      'price': 799.00,
      'originalPrice': 999.00,
      'image':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      'rating': 4.4,
      'reviews': 112,
    },
    {
      'id': 'jr10',
      'name': 'Track Jersey',
      'price': 699.00,
      'originalPrice': null,
      'image':
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400',
      'rating': 4.7,
      'reviews': 203,
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
                  'Jerseys',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Professional sports performance',
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
