import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../orders/controllers/orders_controller.dart';
import '../../auth/controllers/firebase_auth_controller.dart';

class CheckoutController extends GetxController {
  static CheckoutController get to => Get.find();

  final _isLoading = false.obs;
  final _isProcessingOrder = false.obs;
  final _error = RxnString();

  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _notesController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Payment method
  final _selectedPaymentMethod = 'cash_on_delivery'.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isProcessingOrder => _isProcessingOrder.value;
  String? get error => _error.value;
  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get addressController => _addressController;
  TextEditingController get cityController => _cityController;
  TextEditingController get postalCodeController => _postalCodeController;
  TextEditingController get notesController => _notesController;
  GlobalKey<FormState> get formKey => _formKey;
  String get selectedPaymentMethod => _selectedPaymentMethod.value;

  // Cart and pricing getters
  List<Map<String, dynamic>> get cartItems => CartController.to.cartItems;
  double get subtotal => CartController.to.subtotal;
  double get deliveryCharge => CartController.to.deliveryCharge;
  double get vat => CartController.to.vat;
  double get total => CartController.to.total;
  int get itemCount => CartController.to.itemCount;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  @override
  void onClose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _notesController.dispose();
    super.onClose();
  }

  Future<void> _loadUserData() async {
    try {
      _isLoading.value = true;

      // Check if FirebaseAuthController is available
      if (!Get.isRegistered<FirebaseAuthController>()) {
        print(
          'FirebaseAuthController not registered yet, skipping user data load',
        );
        return;
      }

      // Get current user
      final authController = Get.find<FirebaseAuthController>();
      final user = authController.currentUser;

      if (user != null) {
        // Pre-fill form with user data if available
        _emailController.text = user.email ?? '';
        _nameController.text = user.displayName ?? '';

        // You can extend this to load saved addresses from user profile
        // For now, we'll use default values
        _phoneController.text = '';
        _addressController.text = '';
        _cityController.text = 'Dhaka';
        _postalCodeController.text = '';
      }
    } catch (e) {
      print('Error loading user data: $e');
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  void setPaymentMethod(String method) {
    _selectedPaymentMethod.value = method;
  }

  Future<void> placeOrder() async {
    try {
      // Validate form
      if (!_formKey.currentState!.validate()) {
        Get.snackbar(
          'Validation Error',
          'Please fill in all required fields',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
        return;
      }

      // Check if cart is empty
      if (cartItems.isEmpty) {
        Get.snackbar(
          'Empty Cart',
          'Your cart is empty. Please add items before placing an order.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
        return;
      }

      _isProcessingOrder.value = true;

      // Prepare shipping address
      final shippingAddress = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'postalCode': _postalCodeController.text.trim(),
      };

      // Get cart items for order
      final orderItems = CartController.to.getCartItemsForCheckout();

      // Create order using OrdersController
      await OrdersController.to.createOrder(
        cartItems: orderItems,
        shippingAddress: shippingAddress,
        paymentMethod: _selectedPaymentMethod.value,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
      );

      // Clear cart after successful order
      await CartController.to.clearCart();

      // Show success message
      Get.snackbar(
        'Order Placed Successfully!',
        'আপনার অর্ডার সফলভাবে স্থাপন করা হয়েছে। আপনি শীঘ্রই একটি নিশ্চিতকরণ ইমেইল পাবেন।',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );

      // Navigate to orders page
      Get.offAllNamed('/orders');
    } catch (e) {
      print('Error placing order: $e');
      Get.snackbar(
        'Order Failed',
        'Failed to place order: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } finally {
      _isProcessingOrder.value = false;
    }
  }

  // Validation methods
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }
    if (!GetUtils.isEmail(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }
    // Basic phone validation for Bangladesh
    final phoneRegex = RegExp(r'^(\+880|0)[0-9]{10}$');
    if (!phoneRegex.hasMatch(value.trim().replaceAll(' ', ''))) {
      return 'Please enter a valid Bangladesh phone number';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your address';
    }
    if (value.trim().length < 10) {
      return 'Please enter a complete address';
    }
    return null;
  }

  String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your city';
    }
    return null;
  }

  String? validatePostalCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your postal code';
    }
    if (value.trim().length < 4) {
      return 'Please enter a valid postal code';
    }
    return null;
  }

  // Payment method options
  List<Map<String, dynamic>> get paymentMethods => [
    {
      'id': 'cash_on_delivery',
      'name': 'Cash on Delivery',
      'description': 'Pay when you receive your order',
      'icon': Icons.money,
      'available': true,
    },
    {
      'id': 'bkash',
      'name': 'bKash',
      'description': 'Pay with bKash mobile banking',
      'icon': Icons.phone_android,
      'available': false, // Not implemented yet
    },
    {
      'id': 'nagad',
      'name': 'Nagad',
      'description': 'Pay with Nagad mobile banking',
      'icon': Icons.account_balance_wallet,
      'available': false, // Not implemented yet
    },
    {
      'id': 'rocket',
      'name': 'Rocket',
      'description': 'Pay with Rocket mobile banking',
      'icon': Icons.rocket_launch,
      'available': false, // Not implemented yet
    },
  ];

  // Get available payment methods
  List<Map<String, dynamic>> get availablePaymentMethods {
    return paymentMethods
        .where((method) => method['available'] == true)
        .toList();
  }

  // Check if form is valid
  bool get isFormValid {
    return _formKey.currentState?.validate() ?? false;
  }

  // Reset form
  void resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _addressController.clear();
    _cityController.clear();
    _postalCodeController.clear();
    _notesController.clear();
    _selectedPaymentMethod.value = 'cash_on_delivery';
  }
}
