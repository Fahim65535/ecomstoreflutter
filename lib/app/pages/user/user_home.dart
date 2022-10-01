import 'package:ecom_store_riv/app/providers.dart';
import 'package:ecom_store_riv/widgets/product_banner.dart';
import 'package:ecom_store_riv/widgets/product_display.dart';
import 'package:ecom_store_riv/widgets/user_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserHome extends ConsumerWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserTopBar(
                leadingIconButton: IconButton(
                  onPressed: () {
                    //sign out
                    ref.read(firebaseAuthProvider).signOut();
                  },
                  icon: const Icon(Icons.logout_outlined),
                ),
              ),
              const SizedBox(height: 20),
              const ProductBanner(),
              const SizedBox(height: 20),
              const Text(
                "Products",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "View all of our products",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const Flexible(
                child: ProductsDisplay(),
              ),

              /* Flexible => Using it as a parent widget above cuz
            of overflow issue, which will be fixed now.
            Flexible uses the amount of space available to it */
            ],
          ),
        ),
      ),
    );
  }
}
