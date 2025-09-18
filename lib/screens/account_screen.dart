import 'package:driver_app/core/colors.dart';
import 'package:driver_app/models/order.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = "Captain";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        backgroundColor: AppColors.scaffoldBackgroundColor,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        children: [
          // Profile card
          Card(
            color: AppColors.background,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar + name
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade100,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "12345 67890",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Logout button (no Flexible/SizedBox conflict)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/");
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shadowColor: Colors.black.withOpacity(0.3),

                      minimumSize: const Size(70, 40),
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(120),
                      ),
                    ),
                    child: const Text("Logout", style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),

          const Text(
            "Previous Orders",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Orders list
          if (previousOrders.isEmpty)
            const Center(child: Text("No orders yet"))
          else
            ...previousOrders.map((order) {
              final timeFormatted =
                  "${order.time.hour.toString().padLeft(2, '0')}:${order.time.minute.toString().padLeft(2, '0')} "
                  "${order.time.day}/${order.time.month}/${order.time.year}";

              return Card(
                color: Colors.grey.shade50,
                elevation: 6,
                shadowColor: Colors.black.withOpacity(0.25),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("You have already completed this order."),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        // Status icon
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Restaurant + customer + time
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.restaurantName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Customer: ${order.customerName}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                timeFormatted,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Order details (ID + amount)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "#${order.id}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "₹${order.amount.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
