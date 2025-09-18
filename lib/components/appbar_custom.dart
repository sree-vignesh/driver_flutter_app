import 'package:flutter/material.dart';
import '../core/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String statusText;

  const CustomAppBar({super.key, required this.statusText});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,

      // backgroundColor: AppColors.background,
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
            statusText,
            style: TextStyle(
              fontSize: 23,
              color: statusText == "Order Completed"
                  ? Colors.green
                  : AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.account_circle_rounded,
            color: AppColors.primary,
            size: 40,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/account');
          },
        ),
        const SizedBox(width: 24),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
