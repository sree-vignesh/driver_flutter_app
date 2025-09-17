class Order {
  final String id;
  final String restaurantName;
  final double restaurantLat;
  final double restaurantLng;
  final String customerName;
  final double customerLat;
  final double customerLng;
  final double amount;

  const Order({
    required this.id,
    required this.restaurantName,
    required this.restaurantLat,
    required this.restaurantLng,
    required this.customerName,
    required this.customerLat,
    required this.customerLng,
    required this.amount,
  });
}

// Dummy assigned order
const dummyOrder = Order(
  id: "ORD123",
  restaurantName: "Pizza Palace",
  restaurantLat: 12.9716, // Example: Bangalore coords
  restaurantLng: 77.5946,
  customerName: "John Doe",
  customerLat: 12.9352,
  customerLng: 77.6245,
  amount: 450.0,
);
