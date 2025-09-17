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
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Order Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      order.id,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
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

              // if(distanceToRestaurant < 1000)
              subtitle:
                  (distanceToRestaurant != null && distanceToRestaurant! < 1000)
                  ? "You are ${distanceToRestaurant} m away."
                  : "You are too far, get closer.",

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
                  (distanceToCustomer != null && distanceToCustomer! < 1000)
                  ? "You are ${distanceToRestaurant} m away."
                  : "You are too far, get closer.",
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
      trailing: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 47,
          child: IconButton(
            onPressed: onTap,
            icon: const Icon(
              Icons.navigation_sharp,
              color: AppColors.primary,
              // color: Colors.white,
              size: 24,
            ),
            // label: const SizedBox.shrink(),
            style: TextButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 1.5),
              backgroundColor: Colors.orange.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
