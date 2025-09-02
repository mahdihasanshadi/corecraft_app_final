import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/logo_widget.dart';
import '../../cart/controllers/cart_controller.dart';

class AllProductsView extends StatefulWidget {
  const AllProductsView({super.key});

  @override
  State<AllProductsView> createState() => _AllProductsViewState();
}

class _AllProductsViewState extends State<AllProductsView> {
  final TextEditingController _searchController = TextEditingController();
  RangeValues _priceRange = const RangeValues(0, 5000);
  String _selectedCategory = 'All';
  String _selectedSortBy = 'Name A-Z';
  bool _showFilters = false;

  final List<Map<String, dynamic>> _allProducts = [
    // Streetwear Products
    {
      'id': 'sw1',
      'name': 'Oversized Streetwear Hoodie',
      'price': 1299.00,
      'originalPrice': 1499.00,
      'category': 'Streetwear',
      'image':
          'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=400',
      'rating': 4.8,
      'reviews': 124,
      'inStock': true,
    },
    {
      'id': 'sw2',
      'name': 'Cargo Streetwear Pants',
      'price': 1499.00,
      'originalPrice': null,
      'category': 'Streetwear',
      'image':
          'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=400',
      'rating': 4.6,
      'reviews': 89,
      'inStock': true,
    },
    {
      'id': 'sw3',
      'name': 'Graphic Streetwear T-Shirt',
      'price': 699.00,
      'originalPrice': 899.00,
      'category': 'Streetwear',
      'image':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      'rating': 4.6,
      'reviews': 156,
      'inStock': true,
    },
    {
      'id': 'sw4',
      'name': 'Streetwear Denim Jacket',
      'price': 2199.00,
      'originalPrice': null,
      'category': 'Streetwear',
      'image':
          'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=400',
      'rating': 4.7,
      'reviews': 67,
      'inStock': false,
    },
    {
      'id': 'sw5',
      'name': 'Streetwear Track Pants',
      'price': 1199.00,
      'originalPrice': 1399.00,
      'category': 'Streetwear',
      'image':
          'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=400',
      'rating': 4.4,
      'reviews': 92,
      'inStock': true,
    },
    // Casual Shirts Products
    {
      'id': 'cs1',
      'name': 'Classic Oxford Casual Shirt',
      'price': 899.00,
      'originalPrice': 1099.00,
      'category': 'Casual Shirts',
      'image':
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400',
      'rating': 4.6,
      'reviews': 203,
      'inStock': true,
    },
    {
      'id': 'cs2',
      'name': 'Linen Summer Casual Shirt',
      'price': 1099.00,
      'originalPrice': null,
      'category': 'Casual Shirts',
      'image':
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
      'rating': 4.5,
      'reviews': 178,
      'inStock': true,
    },
    {
      'id': 'cs3',
      'name': 'Polo Casual Shirt',
      'price': 699.00,
      'originalPrice': 899.00,
      'category': 'Casual Shirts',
      'image':
          'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=400',
      'rating': 4.5,
      'reviews': 145,
      'inStock': true,
    },
    {
      'id': 'cs4',
      'name': 'Denim Casual Shirt',
      'price': 1199.00,
      'originalPrice': null,
      'category': 'Casual Shirts',
      'image':
          'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=400',
      'rating': 4.3,
      'reviews': 87,
      'inStock': false,
    },
    {
      'id': 'cs5',
      'name': 'Flannel Casual Shirt',
      'price': 999.00,
      'originalPrice': 1199.00,
      'category': 'Casual Shirts',
      'image':
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400',
      'rating': 4.3,
      'reviews': 134,
      'inStock': true,
    },
    // Jerseys Products
    {
      'id': 'jr1',
      'name': 'Pro Basketball Jersey',
      'price': 1199.00,
      'originalPrice': 1399.00,
      'category': 'Jerseys',
      'image':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      'rating': 4.7,
      'reviews': 267,
      'inStock': true,
    },
    {
      'id': 'jr2',
      'name': 'Soccer Team Jersey',
      'price': 999.00,
      'originalPrice': null,
      'category': 'Jerseys',
      'image':
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400',
      'rating': 4.6,
      'reviews': 189,
      'inStock': true,
    },
    {
      'id': 'jr3',
      'name': 'Football Jersey',
      'price': 1299.00,
      'originalPrice': 1499.00,
      'category': 'Jerseys',
      'image':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      'rating': 4.6,
      'reviews': 156,
      'inStock': true,
    },
    {
      'id': 'jr4',
      'name': 'Baseball Jersey',
      'price': 1099.00,
      'originalPrice': null,
      'category': 'Jerseys',
      'image':
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400',
      'rating': 4.4,
      'reviews': 98,
      'inStock': false,
    },
    {
      'id': 'jr5',
      'name': 'Hockey Jersey',
      'price': 1399.00,
      'originalPrice': 1599.00,
      'category': 'Jerseys',
      'image':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      'rating': 4.8,
      'reviews': 76,
      'inStock': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    List<Map<String, dynamic>> filtered = _allProducts.where((product) {
      // Search by name
      bool matchesSearch =
          _searchController.text.isEmpty ||
          product['name'].toString().toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );

      // Filter by category
      bool matchesCategory =
          _selectedCategory == 'All' ||
          product['category'] == _selectedCategory;

      // Filter by price range
      bool matchesPrice =
          product['price'] >= _priceRange.start &&
          product['price'] <= _priceRange.end;

      return matchesSearch && matchesCategory && matchesPrice;
    }).toList();

    // Sort products
    switch (_selectedSortBy) {
      case 'Name A-Z':
        filtered.sort((a, b) => a['name'].compareTo(b['name']));
        break;
      case 'Name Z-A':
        filtered.sort((a, b) => b['name'].compareTo(a['name']));
        break;
      case 'Price Low to High':
        filtered.sort((a, b) => a['price'].compareTo(b['price']));
        break;
      case 'Price High to Low':
        filtered.sort((a, b) => b['price'].compareTo(a['price']));
        break;
      case 'Rating High to Low':
        filtered.sort((a, b) => b['rating'].compareTo(a['rating']));
        break;
      case 'Newest First':
        // For demo, we'll keep original order
        break;
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
              child: Icon(
                _showFilters ? Icons.filter_list : Icons.filter_list_outlined,
                color: Colors.black87,
              ),
            ),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          if (_showFilters) _buildFilters(),
          _buildResultsHeader(),
          Expanded(
            child: _filteredProducts.isEmpty
                ? _buildEmptyState()
                : _buildProductsGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search products by name...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[500]),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF2C3E50), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
          Text(
            'Filters',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: const Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 20),

          // Category Filter
          Text(
            'Category',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['All', 'Streetwear', 'Casual Shirts', 'Jerseys']
                .map(
                  (category) => FilterChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: const Color(0xFF2C3E50).withOpacity(0.2),
                    checkmarkColor: const Color(0xFF2C3E50),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),

          // Price Range Filter
          Text(
            'Price Range: ৳${_priceRange.start.round()} - ৳${_priceRange.end.round()}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 5000,
            divisions: 50,
            activeColor: const Color(0xFF2C3E50),
            inactiveColor: Colors.grey[300],
            labels: RangeLabels(
              '৳${_priceRange.start.round()}',
              '৳${_priceRange.end.round()}',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _priceRange = values;
              });
            },
          ),
          const SizedBox(height: 20),

          // Sort By Filter
          Text(
            'Sort By',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedSortBy,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items:
                [
                  'Name A-Z',
                  'Name Z-A',
                  'Price Low to High',
                  'Price High to Low',
                  'Rating High to Low',
                  'Newest First',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedSortBy = newValue!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_filteredProducts.length} Products Found',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          if (_filteredProducts.isNotEmpty)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _priceRange = const RangeValues(0, 5000);
                  _selectedCategory = 'All';
                  _selectedSortBy = 'Name A-Z';
                });
              },
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Clear Filters'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2C3E50),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
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
          // Product Image
          Expanded(
            flex: 3,
            child: Container(
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
              child: Stack(
                children: [
                  // Out of Stock Overlay
                  if (!product['inStock'])
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Out of Stock',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                  // Wishlist Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border, size: 20),
                        onPressed: () => _addToWishlist(product),
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        product['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),

                      // Category and Rating in one row
                      Row(
                        children: [
                          Text(
                            product['category'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.star, size: 12, color: Colors.amber[600]),
                          const SizedBox(width: 2),
                          Text(
                            '${product['rating']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),

                      // Price
                      Text(
                        '৳${product['price'].toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Add to Cart Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton(
              onPressed: product['inStock'] ? () => _addToCart(product) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: product['inStock']
                    ? const Color(0xFF2C3E50)
                    : Colors.grey[400],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: Text(
                product['inStock'] ? 'Add to Cart' : 'Out of Stock',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
          ),
          const SizedBox(height: 24),
          Text(
            'No Products Found',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(color: Colors.grey[500], fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _priceRange = const RangeValues(0, 5000);
                _selectedCategory = 'All';
                _selectedSortBy = 'Name A-Z';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C3E50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Clear All Filters',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _addToWishlist(Map<String, dynamic> product) {
    Get.snackbar(
      'Wishlist',
      '${product['name']} added to wishlist',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _addToCart(Map<String, dynamic> product) {
    final cartController = Get.find<CartController>();
    cartController.addToCart(product);
    // The controller will handle snackbar and database sync
  }
}
