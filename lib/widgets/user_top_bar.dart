import 'package:ecom_store_riv/app/pages/user/user_bag.dart';
import 'package:ecom_store_riv/app/pages/user/user_order.dart';
import 'package:flutter/material.dart';

class UserTopBar extends StatelessWidget {
  final IconButton leadingIconButton;
  const UserTopBar({
    Key? key,
    required this.leadingIconButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        leadingIconButton,
        const Spacer(),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserOrders(),
              ),
            );
          },
          icon: const Icon(Icons.menu),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserBag(),
              ),
            );
          },
          icon: const Icon(Icons.shopping_bag),
        ),
      ],
    );
  }
}
