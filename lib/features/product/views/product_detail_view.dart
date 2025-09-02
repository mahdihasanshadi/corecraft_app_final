import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/routes/app_routes.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../wishlist/controllers/wishlist_controller.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView>
    with TickerProviderStateMixin {
  late final ProductController _productController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int _selectedImageIndex = 0;
  int _quantity = 1;
  bool _isFavorite = false;
  String? _selectedSize;
  String? _selectedColor;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeController();
    _loadProductData();
  }

  void _initializeController() {
    try {
      _productController = Get.find<ProductController>();
    } catch (e) {
      _productController = Get.put(ProductController());
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  void _loadProductData() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments['productId'] != null) {
      final productId = arguments['productId'] as String;
      _productController.loadProductDetails(productId);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _addToCart() {
    final product = _productController.currentProduct;
    if (product != null) {
      // Validate size and color selection
      if (_selectedSize == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select a size'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
        return;
      }

      if (_selectedColor == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select a color'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
        return;
      }

      // Add to cart using CartController
      if (!Get.isRegistered<CartController>()) {
        Get.snackbar('Error', 'Cart service not available');
        return;
      }
      final cartController = Get.find<CartController>();
      final productData = {
        'id': product.id,
        'name': product.name,
        'price': product.price,
        'salePrice': product.salePrice,
        'image': product.images.isNotEmpty ? product.images[0] : '',
        'images': product.images,
        'category': product.category,
        'brand': product.brand,
        'sizes': product.sizes,
        'colors': product.colors,
        'material': product.material,
        'fitType': product.fitType,
        'stock': product.stock,
      };

      cartController.addToCart(
        productData,
        selectedSize: _selectedSize,
        selectedColor: _selectedColor,
        quantity: _quantity,
      );
    }
  }

  void _toggleFavorite() {
    final product = _productController.currentProduct;
    if (product != null) {
      if (!Get.isRegistered<WishlistController>()) {
        Get.snackbar('Error', 'Wishlist service not available');
        return;
      }
      final wishlistController = Get.find<WishlistController>();
      final productData = {
        'id': product.id,
        'name': product.name,
        'price': product.price,
        'salePrice': product.salePrice,
        'image': product.images.isNotEmpty ? product.images[0] : '',
        'images': product.images,
        'category': product.category,
        'brand': product.brand,
        'sizes': product.sizes,
        'colors': product.colors,
        'material': product.material,
        'fitType': product.fitType,
        'stock': product.stock,
      };

      if (wishlistController.isInWishlist(product.id)) {
        wishlistController.removeFromWishlist(product.id);
        setState(() {
          _isFavorite = false;
        });
      } else {
        wishlistController.addToWishlist(productData);
        setState(() {
          _isFavorite = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Obx(() {
        final product = _productController.currentProduct;
        final isLoading = _productController.isLoading;

        if (isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (product == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Product Details'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => AppRoutes.goBack(),
              ),
            ),
            body: const Center(child: Text('Product not found')),
          );
        }

        return _buildProductDetail(product);
      }),
    );
  }

  Widget _buildProductDetail(dynamic product) {
    return Stack(
      children: [
        // Main content
        CustomScrollView(
          slivers: [
            // Image Gallery Section
            SliverToBoxAdapter(child: _buildImageGallery(product)),

            // Product Details Section
            SliverToBoxAdapter(child: _buildProductDetails(product)),
          ],
        ),

        // Top Navigation Bar
        Positioned(top: 0, left: 0, right: 0, child: _buildTopNavigation()),
      ],
    );
  }

  Widget _buildTopNavigation() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black87,
                size: 20,
              ),
              onPressed: () => AppRoutes.goBack(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),

          // Action Buttons
          Row(
            children: [
              // Heart Icon
              GestureDetector(
                onTap: _toggleFavorite,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.black87,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Shopping Cart with Badge
              GestureDetector(
                onTap: () => Get.toNamed('/cart'),
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.shopping_cart,
                        color: Colors.black87,
                        size: 20,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          '3',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(Product product) {
    final List<String> images = [
      product.images.isNotEmpty
          ? product.images.first
          : 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop',
      'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&h=400&fit=crop',
    ];

    return Container(
      height: 450,
      child: Stack(
        children: [
          // Main Image
          Container(
            width: double.infinity,
            height: double.infinity,
            child: PageView.builder(
              itemCount: images.length,
              onPageChanged: (index) {
                setState(() {
                  _selectedImageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: images[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.error),
                  ),
                );
              },
            ),
          ),

          // Navigation Arrows
          Positioned(
            left: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.chevron_left, color: Colors.black87),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.chevron_right, color: Colors.black87),
              ),
            ),
          ),

          // Image Thumbnails
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedImageIndex = index;
                    });
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _selectedImageIndex == index
                            ? Colors.white
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: _selectedImageIndex == index
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(
                        imageUrl: images[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey[200]),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.error, size: 20),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails(Product product) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Name and Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Size Selection
            _buildSizeSelection(),
            const SizedBox(height: 20),

            // Quantity Selection
            _buildQuantitySelection(),
            const SizedBox(height: 20),

            // Color Selection
            _buildColorSelection(),
            const SizedBox(height: 20),

            // Composition Selection
            _buildCompositionSelection(),
            const SizedBox(height: 30),

            // Add to Cart Button
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Size',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: ['Small', 'Medium', 'Large', 'XL'].map((size) {
            final isSelected = _selectedSize == size;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSize = size;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF4A90E2)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF4A90E2)
                        : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  size,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantitySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quantity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: GestureDetector(
                onTap: () {
                  if (_quantity > 1) {
                    setState(() {
                      _quantity--;
                    });
                  }
                },
                child: const Icon(
                  Icons.remove,
                  color: Colors.black87,
                  size: 20,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                _quantity.toString().padLeft(2, '0'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _quantity++;
                  });
                },
                child: const Icon(Icons.add, color: Colors.black87, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Color',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildColorOption('Navy Blue', const Color(0xFF1B365D), true),
            const SizedBox(width: 12),
            _buildColorOption('Black', Colors.black, false),
            const SizedBox(width: 12),
            _buildColorOption('Grey', Colors.grey, false),
          ],
        ),
      ],
    );
  }

  Widget _buildColorOption(String colorName, Color color, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = colorName;
        });
      },
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? const Color(0xFF4A90E2) : Colors.grey[300]!,
                width: isSelected ? 3 : 1,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            colorName,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? const Color(0xFF4A90E2) : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompositionSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Composition',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Silk Bamboo',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _addToCart,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A90E2),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Add',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
