import 'package:flutter/material.dart';

class Order {
  final String id;
  final String restaurantName;
  final double restaurantLat;
  final double restaurantLng;
  final String customerName;
  final double customerLat;
  final double customerLng;
  final double amount;
  final DateTime time; // 👈 new field

  const Order({
    required this.id,
    required this.restaurantName,
    required this.restaurantLat,
    required this.restaurantLng,
    required this.customerName,
    required this.customerLat,
    required this.customerLng,
    required this.amount,
    required this.time, // 👈
  });
}

var dummyOrder = Order(
  id: "ORD123",
  restaurantName: "The Briyani Shop",
  restaurantLat: 12.9715,
  restaurantLng: 77.5946,
  customerName: "Kishore",
  customerLat: 12.9717,
  customerLng: 77.5947,
  amount: 450.0,
  time: DateTime(2025, 9, 17, 18, 45),
);

var previousOrders = [
  Order(
    id: "ORD122",
    restaurantName: "The Laddu Shop",
    restaurantLat: 12.9720,
    restaurantLng: 77.5950,
    customerName: "Shravanya",
    customerLat: 12.9730,
    customerLng: 77.5960,
    amount: 320.0,
    time: DateTime(2025, 9, 17, 18, 45), // 6:45 PM
  ),
  Order(
    id: "ORD121",
    restaurantName: "The Momos Shop",
    restaurantLat: 12.9750,
    restaurantLng: 77.5980,
    customerName: "Dinesh",
    customerLat: 12.9760,
    customerLng: 77.5990,
    amount: 890.0,
    time: DateTime(2025, 9, 17, 14, 10), // 2:10 PM
  ),
  Order(
    id: "ORD120",
    restaurantName: "The Bakery",
    restaurantLat: 12.9750,
    restaurantLng: 77.5980,
    customerName: "Rama",
    customerLat: 12.9760,
    customerLng: 77.5990,
    amount: 230.0,
    time: DateTime(2025, 9, 16, 20, 5), // 8:05 PM
  ),
];
