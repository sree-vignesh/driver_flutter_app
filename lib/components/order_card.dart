import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../models/order.dart';
import '../utils/navigation_helper.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final double? distanceToRestaurant;
  final double? distanceToCustomer;

  const OrderCard({
    super.key,
    required this.order,
    required this.distanceToRestaurant,
    required this.distanceToCustomer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Order Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(
                    "₹${order.amount.toStringAsFixed(0)}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 26),

            // Restaurant tile
            _locationTile(
              icon: Icons.store,
              title: order.restaurantName,
              subtitle:
                  "Distance: ${distanceToRestaurant?.toStringAsFixed(0) ?? '--'} m",
              onTap: () => NavigationHelper.openGoogleMaps(
                order.restaurantLat,
                order.restaurantLng,
                label: "${order.restaurantName} (Restaurant)",
              ),
            ),

            const Divider(),

            // Customer tile
            _locationTile(
              icon: Icons.location_pin,
              title: order.customerName,
              subtitle:
                  "Distance: ${distanceToCustomer?.toStringAsFixed(0) ?? '--'} m",
              onTap: () => NavigationHelper.openGoogleMaps(
                order.customerLat,
                order.customerLng,
                label: "${order.customerName} (Customer)",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: TextButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.navigation, color: AppColors.primary, size: 28),
        label: const SizedBox.shrink(),
        style: TextButton.styleFrom(
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
