import 'package:driver_app/utils/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/order.dart';
import '../state/order_state.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Order order = dummyOrder;
  OrderStatus status = OrderStatus.notStarted;

  void _nextStep() {
    setState(() {
      switch (status) {
        case OrderStatus.notStarted:
          status = OrderStatus.onTheWayToRestaurant;
          break;
        case OrderStatus.onTheWayToRestaurant:
          status = OrderStatus.atRestaurant;
          break;
        case OrderStatus.atRestaurant:
          status = OrderStatus.pickedUp;
          break;
        case OrderStatus.pickedUp:
          status = OrderStatus.atCustomer;
          break;
        case OrderStatus.atCustomer:
          status = OrderStatus.delivered;
          break;
        case OrderStatus.delivered:
          // Already finished
          break;
      }
    });
  }

  String _getButtonText() {
    switch (status) {
      case OrderStatus.notStarted:
        return "Start Trip";
      case OrderStatus.onTheWayToRestaurant:
        return "Arrived at Restaurant";
      case OrderStatus.atRestaurant:
        return "Picked Up";
      case OrderStatus.pickedUp:
        return "Arrived at Customer";
      case OrderStatus.atCustomer:
        return "Delivered";
      case OrderStatus.delivered:
        return "Order Completed";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assigned Order")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order ID: ${order.id}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Restaurant: ${order.restaurantName}"),
            Text("Location: ${order.restaurantLat}, ${order.restaurantLng}"),
            const SizedBox(height: 8),
            Text("Customer: ${order.customerName}"),
            Text("Location: ${order.customerLat}, ${order.customerLng}"),
            const SizedBox(height: 8),
            Text(
              "Amount: ₹${order.amount}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 32),
            const Text(
              "Order Flow",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: status == OrderStatus.delivered ? null : _nextStep,
              child: Text(_getButtonText()),
            ),
            ElevatedButton(
              onPressed: () {
                NavigationHelper.openGoogleMaps(
                  order.restaurantLat,
                  order.restaurantLng,
                );
              },
              child: Text("Navigate to Restaurant"),
            ),

            ElevatedButton(
              onPressed: () {
                NavigationHelper.openGoogleMaps(
                  order.customerLat,
                  order.customerLng,
                );
              },
              child: Text("Navigate to Customer"),
            ),

            const SizedBox(height: 24),
            Text("Current Status: $status"),
          ],
        ),
      ),
    );
  }
}
