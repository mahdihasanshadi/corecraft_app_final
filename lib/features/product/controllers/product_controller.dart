import 'package:get/get.dart';
import '../models/product.dart';
import '../models/firestore_product.dart';
import '../../../shared/services/firestore_service.dart';

class ProductController extends GetxController {
  static ProductController get to => Get.find();

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _currentProduct = Rxn<FirestoreProduct>();
  FirestoreProduct? get currentProduct => _currentProduct.value;

  final _relatedProducts = <FirestoreProduct>[].obs;
  List<FirestoreProduct> get relatedProducts => _relatedProducts;

  final _searchQuery = ''.obs;
  String get searchQuery => _searchQuery.value;

  final _selectedCategory = ''.obs;
  String get selectedCategory => _selectedCategory.value;

  @override
  void onInit() {
    super.onInit();
    _loadRelatedProducts();
  }

  Future<void> _loadRelatedProducts() async {
    try {
      // Load related products from Firestore
      final products = await FirestoreService.getProducts();
      _relatedProducts.value = products.take(6).toList();
    } catch (e) {
      print('Error loading related products: $e');
    }
  }

  Future<void> loadProductDetails(String productId) async {
    try {
      _isLoading.value = true;

      // Load product from Firestore
      final product = await FirestoreService.getProductById(productId);
      if (product != null) {
        _currentProduct.value = product;
      } else {
        Get.snackbar('Error', 'Product not found');
      }
    } catch (e) {
      print('Error loading product details: $e');
      Get.snackbar('Error', 'Failed to load product details');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> searchProducts(String query) async {
    try {
      _isLoading.value = true;
      _searchQuery.value = query;

      if (query.isEmpty) {
        _relatedProducts.value = await FirestoreService.getProducts();
      } else {
        _relatedProducts.value = await FirestoreService.searchProducts(query);
      }
    } catch (e) {
      print('Error searching products: $e');
      Get.snackbar('Error', 'Failed to search products');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> filterByCategory(String category) async {
    try {
      _isLoading.value = true;
      _selectedCategory.value = category;

      if (category.isEmpty) {
        _relatedProducts.value = await FirestoreService.getProducts();
      } else {
        _relatedProducts.value = await FirestoreService.getProductsByCategory(
          category,
        );
      }
    } catch (e) {
      print('Error filtering by category: $e');
      Get.snackbar('Error', 'Failed to filter products');
    } finally {
      _isLoading.value = false;
    }
  }

  void clearFilters() {
    _searchQuery.value = '';
    _selectedCategory.value = '';
    _loadRelatedProducts();
  }
}
