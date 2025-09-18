import 'dart:async';
import 'package:driver_app/components/appbar_custom.dart';
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

  /// Track permission status
  bool locationPermissionDenied = false;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermission();
  }

  @override
  void dispose() {
    locationTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        locationPermissionDenied = true;
      });
    } else {
      setState(() {
        locationPermissionDenied = false;
      });
      _startLocationUpdates();
    }
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
    if (locationPermissionDenied) {
      _showMessage("Location permission required to continue");
      return;
    }

    setState(() {
      switch (status) {
        case OrderStatus.notStarted:
          status = OrderStatus.onTheWayToRestaurant;
          break;
        case OrderStatus.onTheWayToRestaurant:
          if (_canArriveRestaurant) {
            status = OrderStatus.atRestaurant;
          } else {
            _showMessage("Move closer to restaurant and try again.");
          }
          break;
        case OrderStatus.atRestaurant:
          status = OrderStatus.pickedUp;
          break;
        case OrderStatus.pickedUp:
          if (_canArriveCustomer) {
            status = OrderStatus.atCustomer;
          } else {
            _showMessage("Move closer to customer and try again.");
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        // margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
      ),
    );
  }

  String _getButtonText() {
    if (locationPermissionDenied) return "Enable Location Permission";
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
    if (locationPermissionDenied) {
      return "Please enable Location";
    }
    switch (status) {
      case OrderStatus.notStarted:
        return "Not Yet Started";
      case OrderStatus.onTheWayToRestaurant:
        return "On the way to pickup";
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: locationPermissionDenied
          ? FloatingActionButton.extended(
              onPressed: _checkAndRequestPermission,
              label: const Text("Tap to enable Location"),
              icon: const Icon(Icons.location_disabled),
            )
          : SizedBox(
              width:
                  MediaQuery.of(context).size.width -
                  48, // full width minus padding
              height: 80,
              child: SliderButton(
                text: _getButtonText(),
                enabled: status != OrderStatus.delivered,
                onConfirmed: _nextStep,
              ),
            ),
      appBar: CustomAppBar(statusText: _getStatusText()),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(0),
              child: OrderCard(
                order: order,
                distanceToRestaurant: distanceToRestaurant,
                distanceToCustomer: distanceToCustomer,
                locationPermissionDenied: locationPermissionDenied,
              ),
            ),
          ),
          // Bottom info when permission granted
          if (!locationPermissionDenied)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  if (currentPosition != null)
                    Text(
                      "Your coords: ${currentPosition!.latitude}, ${currentPosition!.longitude}",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    "Slide to proceed",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),

          const SizedBox(height: 140),
        ],
      ),
    );
  }
}
