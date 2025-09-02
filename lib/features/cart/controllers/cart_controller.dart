import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/services/firestore_service.dart';
import '../../auth/controllers/firebase_auth_controller.dart';

class CartController extends GetxController {
  static CartController get to => Get.find();

  final _cartItems = <Map<String, dynamic>>[].obs;
  final _isLoading = false.obs;
  final _error = RxnString();
  final _isProcessing = false.obs;
  final _loadingProducts =
      <String>{}.obs; // Track which products are being added

  List<Map<String, dynamic>> get cartItems => _cartItems;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  bool get isProcessing => _isProcessing.value;

  // Check if a specific product is being added to cart
  bool isProductLoading(String productId) =>
      _loadingProducts.contains(productId);

  // Method to manually trigger cart loading (called when auth is complete)
  Future<void> loadCartIfAuthenticated() async {
    try {
      if (!Get.isRegistered<FirebaseAuthController>()) {
        print('❌ FirebaseAuthController not registered, cannot load cart');
        return;
      }

      final authController = Get.find<FirebaseAuthController>();
      if (authController.isLoggedIn) {
        print('✅ Auth complete, loading cart...');
        await _loadCartItems();
        _setupRealtimeListener();
      }
    } catch (e) {
      print('❌ Error in loadCartIfAuthenticated: $e');
    }
  }

  // Computed properties
  int get itemCount =>
      _cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int? ?? 1));
  double get subtotal => _cartItems.fold(0.0, (sum, item) {
    final price =
        (item['salePrice'] as double? ?? item['price'] as double? ?? 0.0);
    final quantity = (item['quantity'] as int? ?? 1);
    return sum + (price * quantity);
  });
  double get deliveryCharge => 150.0; // Fixed delivery charge in BDT
  double get vat => subtotal * 0.05; // 5% VAT
  double get total => subtotal + deliveryCharge + vat;

  @override
  void onInit() {
    super.onInit();
    // Wait for auth controller to be ready and user to be authenticated
    Future.delayed(const Duration(milliseconds: 1000), () {
      _waitForAuthAndLoadCart();
    });
  }

  Future<void> _waitForAuthAndLoadCart() async {
    try {
      // Wait for FirebaseAuthController to be registered and initialized
      if (!Get.isRegistered<FirebaseAuthController>()) {
        print('⏳ Waiting for FirebaseAuthController to be registered...');
        await Future.delayed(const Duration(milliseconds: 500));
        if (!Get.isRegistered<FirebaseAuthController>()) {
          print(
            '❌ FirebaseAuthController still not registered, skipping cart load',
          );
          return;
        }
      }

      final authController = Get.find<FirebaseAuthController>();

      // Wait for auth controller to finish initializing
      if (authController.isLoading) {
        print('⏳ Waiting for FirebaseAuthController to finish initializing...');
        await Future.delayed(const Duration(milliseconds: 1000));
      }

      // Now check if user is authenticated
      if (authController.isLoggedIn) {
        print('✅ User is authenticated, loading cart...');
        await _loadCartItems();
        _setupRealtimeListener();
      } else {
        print('ℹ️ User not authenticated, skipping cart load');
      }
    } catch (e) {
      print('❌ Error in _waitForAuthAndLoadCart: $e');
    }
  }

  void _setupRealtimeListener() {
    // DISABLED - Real-time listeners are causing conflicts
    // We'll use manual refresh instead
    print('Real-time listener setup skipped to prevent conflicts');
  }

  Future<void> _loadCartItems() async {
    try {
      _isLoading.value = true;
      _error.value = null;

      print('=== DEBUG: Loading cart items ===');

      // Check if FirebaseAuthController is available
      if (!Get.isRegistered<FirebaseAuthController>()) {
        print(
          '❌ FirebaseAuthController not registered yet, skipping cart load',
        );
        _cartItems.clear();
        return;
      }

      // Get current user
      final authController = Get.find<FirebaseAuthController>();
      final user = authController.currentUser;

      print('🔍 Current user: ${user?.uid ?? "NULL"}');
      print('🔍 User email: ${user?.email ?? "NULL"}');

      if (user != null) {
        print('✅ User authenticated, loading cart from Firestore...');

        // Load cart from Firestore
        final cartData = await FirestoreService.getCartItems(user.uid);
        print('📦 Raw cart data from Firestore: ${cartData.length} items');
        print('📦 Cart data details: $cartData');

        // Validate and clean the data
        final cleanedData = cartData
            .map((item) => _cleanCartItem(item))
            .toList();
        _cartItems.value = cleanedData;

        print('✅ Loaded ${cartData.length} cart items for user ${user.uid}');
        print('✅ Cleaned cart items: ${_cartItems.length}');
      } else {
        print('❌ User not logged in, clearing cart');
        _cartItems.clear();
      }
    } catch (e) {
      print('❌ Error loading cart: $e');
      _error.value = e.toString();
      _cartItems.clear();
    } finally {
      _isLoading.value = false;
      print('=== DEBUG: Cart loading complete ===');
    }
  }

  // Clean and validate cart item data
  Map<String, dynamic> _cleanCartItem(Map<String, dynamic> item) {
    // Handle both Map and FirestoreProduct types for the product field
    dynamic product = item['product'];

    // Extract product data based on type
    String name;
    double price;
    double? salePrice;
    String image;
    List<dynamic> images;
    String category;
    String brand;
    List<dynamic> sizes;
    List<dynamic> colors;
    String material;
    String fitType;
    int stock;

    if (product is Map<String, dynamic>) {
      // Product is a Map (from addToCart)
      name = product['name']?.toString() ?? 'Unknown Product';
      price = _parseDouble(product['price']) ?? 0.0;
      salePrice = _parseDouble(product['salePrice']);
      image = product['images']?[0]?.toString() ?? '';
      images = (product['images'] is List) ? (product['images'] as List) : [];
      category = product['category']?.toString() ?? 'Unknown Category';
      brand = product['brand']?.toString() ?? '';
      sizes = (product['sizes'] is List) ? (product['sizes'] as List) : [];
      colors = (product['colors'] is List) ? (product['colors'] as List) : [];
      material = product['material']?.toString() ?? '';
      fitType = product['fitType']?.toString() ?? '';
      stock = _parseInt(product['stock']) ?? 0;
    } else {
      // Product is a FirestoreProduct object (from getCartItems)
      // Import the FirestoreProduct class to access its properties
      try {
        // Use dynamic access for now, but we should import the proper class
        name = product.name?.toString() ?? 'Unknown Product';
        price = product.price ?? 0.0;
        salePrice = product.salePrice;
        image = product.images.isNotEmpty ? product.images.first : '';
        images = product.images;
        category = product.category ?? 'Unknown Category';
        brand = product.brand ?? '';
        sizes = product.sizes;
        colors = product.colors;
        material = product.material ?? '';
        fitType = product.fitType ?? '';
        stock = product.stock ?? 0;
      } catch (e) {
        print('❌ Error accessing FirestoreProduct properties: $e');
        // Fallback to default values
        name = 'Unknown Product';
        price = 0.0;
        salePrice = null;
        image = '';
        images = [];
        category = 'Unknown Category';
        brand = '';
        sizes = [];
        colors = [];
        material = '';
        fitType = '';
        stock = 0;
      }
    }

    return {
      'id': item['id']?.toString() ?? '',
      'productId':
          item['productId']?.toString() ?? item['id']?.toString() ?? '',
      'name': name,
      'price': price,
      'salePrice': salePrice,
      'image': image,
      'images': images,
      'category': category,
      'brand': brand,
      'sizes': sizes,
      'colors': colors,
      'material': material,
      'fitType': fitType,
      'stock': stock,
      'quantity': _parseInt(item['quantity']) ?? 1,
      'selectedSize': item['selectedSize']?.toString() ?? '',
      'selectedColor': item['selectedColor']?.toString() ?? '',
      'addedAt': item['addedAt'],
    };
  }

  // Helper methods for safe type conversion
  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Future<void> addToCart(
    Map<String, dynamic> product, {
    String? selectedSize,
    String? selectedColor,
    int quantity = 1,
  }) async {
    final productId = product['id']?.toString() ?? '';

    // Check if already loading this product
    if (_loadingProducts.contains(productId)) {
      print('⚠️ Product $productId is already being added to cart');
      return;
    }

    try {
      // Set loading state for this product
      _loadingProducts.add(productId);

      print('=== DEBUG: Adding to cart ===');
      print('📦 Product: ${product['name'] ?? 'Unknown'}');
      print('📦 Product ID: $productId');

      // Get current user
      final authController = Get.find<FirebaseAuthController>();
      final user = authController.currentUser;

      print('🔍 Current user: ${user?.uid ?? "NULL"}');
      print('🔍 User email: ${user?.email ?? "NULL"}');

      if (user == null) {
        print('❌ User not authenticated, showing login required message');
        Get.snackbar(
          'Login Required',
          'Please login to add items to cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
        return;
      }

      print('✅ User authenticated, product ID: $productId');

      // Check if item already exists in cart
      final existingIndex = _cartItems.indexWhere(
        (item) =>
            item['productId'] == productId &&
            item['selectedSize'] == selectedSize &&
            item['selectedColor'] == selectedColor,
      );

      if (existingIndex != -1) {
        print('🔄 Item already exists, updating quantity...');
        // Update quantity of existing item
        await updateQuantity(
          existingIndex,
          _cartItems[existingIndex]['quantity'] + quantity,
        );
      } else {
        print('➕ Adding new item to cart...');

        // Add to local list FIRST
        final cleanedProduct = _cleanCartItem({
          'id': productId,
          'productId': productId,
          'product': product,
          'quantity': quantity,
          'selectedSize': selectedSize ?? '',
          'selectedColor': selectedColor ?? '',
          'addedAt': DateTime.now().toIso8601String(),
        });

        _cartItems.add(cleanedProduct);
        print('✅ Added to cart locally: ${cleanedProduct['name']}');
        print('✅ Cart items count: ${_cartItems.length}');

        // Then add to Firestore
        print('💾 Attempting to save to Firestore...');
        final success = await FirestoreService.addToCart(
          user.uid,
          productId,
          quantity,
        );
        print('💾 Firestore save result: $success');

        if (!success) {
          // If Firestore fails, remove from local list
          _cartItems.removeWhere((item) => item['productId'] == productId);
          print('Removed from local cart due to Firestore failure');
          throw Exception('Failed to save to database');
        }

        // Reload cart from Firestore to ensure UI is up to date
        await _loadCartItems();

        Get.snackbar(
          'Added to Cart',
          '${product['name'] ?? 'Product'} has been added to your cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
      }
    } catch (e) {
      print('Error adding to cart: $e');
      Get.snackbar(
        'Error',
        'Failed to add item to cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } finally {
      // Always remove loading state for this product
      _loadingProducts.remove(productId);
    }
  }

  Future<void> updateQuantity(int index, int newQuantity) async {
    try {
      _isProcessing.value = true;

      if (newQuantity <= 0) {
        await removeFromCart(index);
        return;
      }

      final item = _cartItems[index];
      final productId = item['productId'];

      // Get current user
      final authController = Get.find<FirebaseAuthController>();
      final user = authController.currentUser;

      if (user != null) {
        // Update in Firestore
        await FirestoreService.updateCartQuantity(
          user.uid,
          productId,
          newQuantity,
        );
      }

      // Update local list
      _cartItems[index]['quantity'] = newQuantity;
      _cartItems.refresh();
    } catch (e) {
      print('Error updating quantity: $e');
      Get.snackbar(
        'Error',
        'Failed to update quantity',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } finally {
      _isProcessing.value = false;
    }
  }

  Future<void> removeFromCart(int index) async {
    try {
      _isProcessing.value = true;

      final item = _cartItems[index];
      final productId = item['productId'];

      // Get current user
      final authController = Get.find<FirebaseAuthController>();
      final user = authController.currentUser;

      if (user != null) {
        // Remove from Firestore
        await FirestoreService.removeFromCart(user.uid, productId);
      }

      // Remove from local list
      _cartItems.removeAt(index);
      // Force reload from Firestore to ensure UI is up to date
      await _loadCartItems();

      Get.snackbar(
        'Removed from Cart',
        '${item['name'] ?? 'Product'} has been removed from your cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey[800],
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } catch (e) {
      print('Error removing from cart: $e');
      Get.snackbar(
        'Error',
        'Failed to remove item from cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
  }

  Future<void> clearCart() async {
    try {
      // Get current user
      final authController = Get.find<FirebaseAuthController>();
      final user = authController.currentUser;

      if (user != null) {
        // Clear from Firestore
        await FirestoreService.clearCart(user.uid);
      }

      // Clear local list
      _cartItems.clear();

      Get.snackbar(
        'Cart Cleared',
        'All items have been removed from your cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey[800],
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } catch (e) {
      print('Error clearing cart: $e');
      Get.snackbar(
        'Error',
        'Failed to clear cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } finally {
      _isProcessing.value = false;
    }
  }

  bool isInCart(String productId, {String? size, String? color}) {
    return _cartItems.any(
      (item) =>
          item['productId'] == productId &&
          item['selectedSize'] == (size ?? '') &&
          item['selectedColor'] == (color ?? ''),
    );
  }

  int getCartQuantity(String productId, {String? size, String? color}) {
    final item = _cartItems.firstWhereOrNull(
      (item) =>
          item['productId'] == productId &&
          item['selectedSize'] == (size ?? '') &&
          item['selectedColor'] == (color ?? ''),
    );
    return item?['quantity'] ?? 0;
  }

  // Refresh cart data from database
  Future<void> refreshCart() async {
    await _loadCartItems();
  }

  // Get cart items for checkout
  List<Map<String, dynamic>> getCartItemsForCheckout() {
    return _cartItems
        .map(
          (item) => {
            'id': item['productId'],
            'name': item['name'],
            'price': item['price'],
            'salePrice': item['salePrice'],
            'quantity': item['quantity'],
            'selectedSize': item['selectedSize'],
            'selectedColor': item['selectedColor'],
            'image': item['image'],
          },
        )
        .toList();
  }
}
