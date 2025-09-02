import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/base_controller.dart';
import '../models/category_model.dart';
import '../../product/controllers/firestore_product_controller.dart';
import '../../product/models/firestore_product.dart';
import '../../../shared/services/firestore_service.dart';

class HomeController extends BaseController {
  // Categories
  final _categories = <CategoryModel>[].obs;
  List<CategoryModel> get categories => _categories;

  // Featured Products - Now using FirestoreProduct
  final _featuredProducts = <FirestoreProduct>[].obs;
  List<FirestoreProduct> get featuredProducts => _featuredProducts;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([_loadCategories(), _loadFeaturedProducts()]);
  }

  Future<void> _loadCategories() async {
    try {
      // Load categories from Firestore
      final categoriesData = await FirestoreService.getCategories();
      _categories.value = categoriesData
          .map(
            (data) => CategoryModel(
              id: data['id'] ?? '',
              name: data['name'] ?? '',
              icon: _getCategoryIcon(data['name'] ?? ''),
            ),
          )
          .toList();
    } catch (e) {
      setError('Failed to load categories: $e');
    }
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'streetwear':
        return Icons.style;
      case 'casual shirts':
        return Icons.checkroom;
      case 'jerseys':
        return Icons.sports_soccer;
      default:
        return Icons.category;
    }
  }

  Future<void> _loadFeaturedProducts() async {
    try {
      // Get featured products from FirestoreProductController
      final firestoreController = Get.find<FirestoreProductController>();
      _featuredProducts.value = firestoreController.featuredProducts;
    } catch (e) {
      setError('Failed to load featured products: $e');
    }
  }

  Future<void> refreshData() async {
    await _loadInitialData();
  }

  void viewAllProducts() {
    // Navigate to product list
    Get.toNamed('/products');
  }

  void viewProduct(String productId) {
    // Navigate to product detail
    Get.toNamed('/product-detail', arguments: {'productId': productId});
  }

  void viewCategory(String categoryId) {
    // Navigate to category products
    Get.toNamed('/products', arguments: {'categoryId': categoryId});
  }
}
