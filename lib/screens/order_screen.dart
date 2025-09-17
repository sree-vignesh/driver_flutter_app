import 'dart:async';
import 'package:driver_app/components/order_card.dart';
import 'package:driver_app/core/colors.dart';
import 'package:driver_app/utils/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/order.dart';
import '../state/order_state.dart';
import 'package:driver_app/components/slider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Order order = dummyOrder;
  OrderStatus status = OrderStatus.notStarted;

  Position? currentPosition;
  Timer? locationTimer;

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    locationTimer?.cancel();
    super.dispose();
  }

  void _startLocationUpdates() {
    locationTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      try {
        Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() => currentPosition = pos);
        print("Driver location: ${pos.latitude}, ${pos.longitude}");
      } catch (e) {
        print("Error getting location: $e");
      }
    });
  }

  double _distance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  bool get _canArriveRestaurant {
    if (currentPosition == null) return false;
    return _distance(
          currentPosition!.latitude,
          currentPosition!.longitude,
          order.restaurantLat,
          order.restaurantLng,
        ) <=
        50;
  }

  bool get _canArriveCustomer {
    if (currentPosition == null) return false;
    return _distance(
          currentPosition!.latitude,
          currentPosition!.longitude,
          order.customerLat,
          order.customerLng,
        ) <=
        50;
  }

  void _nextStep() {
    setState(() {
      switch (status) {
        case OrderStatus.notStarted:
          status = OrderStatus.onTheWayToRestaurant;
          break;
        case OrderStatus.onTheWayToRestaurant:
          if (_canArriveRestaurant) {
            status = OrderStatus.atRestaurant;
          } else {
            _showMessage("Move closer to restaurant");
          }
          break;
        case OrderStatus.atRestaurant:
          status = OrderStatus.pickedUp;
          break;
        case OrderStatus.pickedUp:
          if (_canArriveCustomer) {
            status = OrderStatus.atCustomer;
          } else {
            _showMessage("Move closer to customer");
          }
          break;
        case OrderStatus.atCustomer:
          status = OrderStatus.delivered;
          break;
        case OrderStatus.delivered:
          _showMessage("Order already delivered");
          break;
      }
    });
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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

  String _getStatusText() {
    switch (status) {
      case OrderStatus.notStarted:
        return "Not Yet Started";
      case OrderStatus.onTheWayToRestaurant:
        return "On the way to the Restaurant";
      case OrderStatus.atRestaurant:
        return "Waiting for pickup";
      case OrderStatus.pickedUp:
        return "On the way to customer";
      case OrderStatus.atCustomer:
        return "At delivery location";
      case OrderStatus.delivered:
        return "Order Completed";
    }
  }

  @override
  Widget build(BuildContext context) {
    double? distanceToRestaurant;
    double? distanceToCustomer;

    if (currentPosition != null) {
      distanceToRestaurant = _distance(
        currentPosition!.latitude,
        currentPosition!.longitude,
        order.restaurantLat,
        order.restaurantLng,
      );
      distanceToCustomer = _distance(
        currentPosition!.latitude,
        currentPosition!.longitude,
        order.customerLat,
        order.customerLng,
      );
    }

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(48),
            topRight: Radius.circular(48),
          ), // curved edges
          boxShadow: [
            // BoxShadow(
            //   color: AppColors.background,
            //   blurRadius: 8,
            //   offset: Offset(0, -4),
            // ),
          ],
        ),
        // color: AppColors.background,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: SliderButton(
              text: _getButtonText(),
              enabled: status != OrderStatus.delivered,
              onConfirmed: _nextStep,
            ),
          ),
        ),
      ),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hi, Captain!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 10),
            Text(
              _getStatusText(),
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: OrderCard(
          order: order,
          distanceToRestaurant: distanceToRestaurant,
          distanceToCustomer: distanceToCustomer,
        ),
      ),
    );
  }
}
