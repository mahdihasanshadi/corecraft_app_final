import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/firestore_product.dart';
import '../../../shared/services/firestore_service.dart';

class FirestoreProductController extends GetxController {
  static FirestoreProductController get to => Get.find();

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _products = <FirestoreProduct>[].obs;
  List<FirestoreProduct> get products => _products;

  final _featuredProducts = <FirestoreProduct>[].obs;
  List<FirestoreProduct> get featuredProducts => _featuredProducts;

  final _currentProduct = Rxn<FirestoreProduct>();
  FirestoreProduct? get currentProduct => _currentProduct.value;

  final _searchQuery = ''.obs;
  String get searchQuery => _searchQuery.value;

  final _selectedCategory = ''.obs;
  String get selectedCategory => _selectedCategory.value;

  final _categories = <String>[].obs;
  List<String> get categories => _categories;

  // Stream subscriptions for real-time updates
  StreamSubscription<QuerySnapshot>? _productsSubscription;
  StreamSubscription<QuerySnapshot>? _categoriesSubscription;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
    _setupRealtimeListeners();
  }

  @override
  void onClose() {
    _productsSubscription?.cancel();
    _categoriesSubscription?.cancel();
    super.onClose();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      loadProducts(),
      loadFeaturedProducts(),
      loadCategories(),
    ]);
  }

  void _setupRealtimeListeners() {
    try {
      // Listen to products collection changes
      _productsSubscription = FirebaseFirestore.instance
          .collection('products')
          .snapshots()
          .listen((snapshot) {
            try {
              final products = snapshot.docs
                  .map((doc) => FirestoreProduct.fromFirestore(doc))
                  .toList();
              _products.value = products;

              // Update featured products
              _featuredProducts.value = products
                  .where((p) => p.isFeatured)
                  .toList();
            } catch (e) {
              print('Error processing products snapshot: $e');
            }
          });

      // Listen to categories collection changes
      _categoriesSubscription = FirebaseFirestore.instance
          .collection('categories')
          .snapshots()
          .listen((snapshot) {
            try {
              final categories = snapshot.docs
                  .map((doc) => doc.data()['name'] as String)
                  .toList();
              _categories.value = categories;
            } catch (e) {
              print('Error processing categories snapshot: $e');
            }
          });

      print('✅ Real-time listeners set up successfully');
    } catch (e) {
      print('❌ Error setting up real-time listeners: $e');
    }
  }

  Future<void> loadProducts() async {
    try {
      _isLoading.value = true;
      final products = await FirestoreService.getProducts();
      _products.value = products;
    } catch (e) {
      print('Error loading products: $e');
      Get.snackbar('Error', 'Failed to load products');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadFeaturedProducts() async {
    try {
      final featuredProducts = await FirestoreService.getFeaturedProducts();
      _featuredProducts.value = featuredProducts;
    } catch (e) {
      print('Error loading featured products: $e');
    }
  }

  Future<void> loadCategories() async {
    try {
      final categoriesData = await FirestoreService.getCategories();
      _categories.value = categoriesData
          .map((cat) => cat['name'] as String)
          .toList();
    } catch (e) {
      print('Error loading categories: $e');
      // Fallback to hardcoded categories
      _categories.value = ['Streetwear', 'Jerseys', 'Casual Shirts'];
    }
  }

  Future<void> loadProductById(String productId) async {
    try {
      _isLoading.value = true;
      final product = await FirestoreService.getProductById(productId);
      _currentProduct.value = product;
    } catch (e) {
      print('Error loading product: $e');
      Get.snackbar('Error', 'Failed to load product details');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadProductsByCategory(String category) async {
    try {
      _isLoading.value = true;
      _selectedCategory.value = category;
      final products = await FirestoreService.getProductsByCategory(category);
      _products.value = products;
    } catch (e) {
      print('Error loading products by category: $e');
      Get.snackbar('Error', 'Failed to load products');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> searchProducts(String query) async {
    try {
      _isLoading.value = true;
      _searchQuery.value = query;

      if (query.isEmpty) {
        await loadProducts();
      } else {
        final products = await FirestoreService.searchProducts(query);
        _products.value = products;
      }
    } catch (e) {
      print('Error searching products: $e');
      Get.snackbar('Error', 'Search failed');
    } finally {
      _isLoading.value = false;
    }
  }

  void clearFilters() {
    _searchQuery.value = '';
    _selectedCategory.value = '';
    loadProducts();
  }

  List<FirestoreProduct> getProductsByCategoryLocal(String category) {
    return _products
        .where(
          (product) => product.category.toLowerCase() == category.toLowerCase(),
        )
        .toList();
  }

  List<FirestoreProduct> getTopRatedProducts({int limit = 5}) {
    final sortedProducts = List<FirestoreProduct>.from(_products);
    sortedProducts.sort((a, b) => b.rating.compareTo(a.rating));
    return sortedProducts.take(limit).toList();
  }

  List<FirestoreProduct> getOnSaleProducts() {
    return _products.where((product) => product.isOnSale).toList();
  }

  List<FirestoreProduct> getNewProducts() {
    return _products.where((product) => product.isNew).toList();
  }

  // Filter products by price range
  List<FirestoreProduct> getProductsByPriceRange(
    double minPrice,
    double maxPrice,
  ) {
    return _products
        .where(
          (product) =>
              product.displayPrice >= minPrice &&
              product.displayPrice <= maxPrice,
        )
        .toList();
  }

  // Filter products by size
  List<FirestoreProduct> getProductsBySize(String size) {
    return _products.where((product) => product.sizes.contains(size)).toList();
  }

  // Filter products by color
  List<FirestoreProduct> getProductsByColor(String color) {
    return _products
        .where((product) => product.colors.contains(color))
        .toList();
  }

  // Get all available sizes
  List<String> getAllSizes() {
    final sizes = <String>{};
    for (var product in _products) {
      sizes.addAll(product.sizes);
    }
    return sizes.toList()..sort();
  }

  // Get all available colors
  List<String> getAllColors() {
    final colors = <String>{};
    for (var product in _products) {
      colors.addAll(product.colors);
    }
    return colors.toList()..sort();
  }

  // Get price range
  Map<String, double> getPriceRange() {
    if (_products.isEmpty) return {'min': 0.0, 'max': 0.0};

    final prices = _products.map((p) => p.displayPrice).toList();
    prices.sort();

    return {'min': prices.first, 'max': prices.last};
  }
}
