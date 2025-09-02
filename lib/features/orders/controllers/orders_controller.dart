import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../../../shared/services/firestore_service.dart';
import '../../auth/controllers/firebase_auth_controller.dart';

class OrdersController extends GetxController {
  static OrdersController get to => Get.find();

  final _orders = <OrderModel>[].obs;
  final _isLoading = false.obs;
  final _error = RxnString();

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;

  @override
  void onInit() {
    super.onInit();
    loadUserOrders();
    _setupRealtimeListener();
  }

  void _setupRealtimeListener() {
    // Check if FirebaseAuthController is available
    if (!Get.isRegistered<FirebaseAuthController>()) {
      print(
        'FirebaseAuthController not registered yet, skipping realtime listener setup',
      );
      return;
    }

    // Get current user
    final authController = Get.find<FirebaseAuthController>();
    final user = authController.currentUser;

    if (user != null) {
      // Listen to orders changes in real-time
      FirestoreService.listenToUserOrders(user.uid).listen(
        (ordersData) {
          try {
            // Convert to OrderModel objects
            final orders = ordersData
                .map((orderData) => OrderModel.fromMap(orderData))
                .toList();
            _orders.value = orders;
            print('Orders updated in real-time: ${orders.length} orders');
          } catch (e) {
            print('Error processing real-time orders update: $e');
          }
        },
        onError: (error) {
          print('Error in real-time orders listener: $error');
          _error.value = error.toString();
        },
      );
    }
  }

  Future<void> loadUserOrders() async {
    try {
      _isLoading.value = true;
      _error.value = null;

      // Get current user
      final authController = Get.find<FirebaseAuthController>();
      final user = authController.currentUser;

      if (user == null) {
        _orders.clear();
        return;
      }

      // Load orders from Firestore
      final orders = await FirestoreService.getUserOrderModels(user.uid);
      _orders.value = orders;

      print('Loaded ${orders.length} orders for user ${user.uid}');
    } catch (e) {
      print('Error loading orders: $e');
      _error.value = e.toString();
      _orders.clear();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> createOrder({
    required List<Map<String, dynamic>> cartItems,
    required Map<String, dynamic> shippingAddress,
    required String paymentMethod,
    String? notes,
  }) async {
    try {
      _isLoading.value = true;

      // Get current user
      final authController = Get.find<FirebaseAuthController>();
      final user = authController.currentUser;

      if (user == null) {
        throw Exception('User not logged in');
      }

      // Calculate totals
      double subtotal = 0.0;
      final List<OrderItem> orderItems = [];

      for (var item in cartItems) {
        final price = (item['salePrice'] ?? item['price'] ?? 0.0).toDouble();
        final quantity = (item['quantity'] ?? 1).toInt();
        subtotal += price * quantity;

        orderItems.add(
          OrderItem(
            productId: item['id'] ?? '',
            productName: item['name'] ?? '',
            productImage: item['image'] ?? '',
            size: item['selectedSize'] ?? '',
            color: item['selectedColor'] ?? '',
            quantity: quantity,
            price: item['price']?.toDouble() ?? 0.0,
            salePrice: item['salePrice']?.toDouble(),
          ),
        );
      }

      const double deliveryCharge = 150.0;
      const double vatRate = 0.05;
      final double vat = subtotal * vatRate;
      final double total = subtotal + deliveryCharge + vat;

      // Create order
      final order = OrderModel(
        id: _generateOrderId(),
        userId: user.uid,
        items: orderItems,
        subtotal: subtotal,
        deliveryCharge: deliveryCharge,
        vat: vat,
        total: total,
        status: OrderStatus.pending,
        orderDate: DateTime.now(),
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod,
        notes: notes,
      );

      // Save to Firestore
      await FirestoreService.createOrderModel(order);

      // Reload orders
      await loadUserOrders();

      Get.snackbar(
        'Success',
        'Order placed successfully!',
        backgroundColor: const Color(0xFF4CAF50),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error creating order: $e');
      Get.snackbar(
        'Error',
        'Failed to place order: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      await FirestoreService.updateOrderStatus(orderId, newStatus);
      await loadUserOrders();
    } catch (e) {
      print('Error updating order status: $e');
      Get.snackbar(
        'Error',
        'Failed to update order status',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _generateOrderId() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    return 'ORD-${timestamp.toString().substring(5)}';
  }

  List<OrderModel> get deliveredOrders {
    return _orders
        .where((order) => order.status == OrderStatus.delivered)
        .toList();
  }

  List<OrderModel> get pendingOrders {
    return _orders
        .where(
          (order) =>
              order.status == OrderStatus.pending ||
              order.status == OrderStatus.confirmed ||
              order.status == OrderStatus.processing ||
              order.status == OrderStatus.shipped,
        )
        .toList();
  }

  int get totalOrders => _orders.length;
  int get deliveredCount => deliveredOrders.length;
}
