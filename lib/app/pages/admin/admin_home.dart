import 'package:ecom_store_riv/app/pages/admin/admin_add_product.dart';
import 'package:ecom_store_riv/app/providers.dart';
import 'package:ecom_store_riv/models/product.dart';
import 'package:ecom_store_riv/utils/snackbars.dart';
import 'package:ecom_store_riv/widgets/project_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class AdminHome extends ConsumerWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Home"),
        actions: [
          IconButton(
            onPressed: () => ref.read(firebaseAuthProvider).signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminAddProductPage(),
          ),
        ),
      ),
      body: StreamBuilder<List<Product>>(
        stream: ref.read(databaseProvider)!.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.data != null) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "No products yet...",
                      style: TextStyle(fontSize: 20),
                    ),
                    Lottie.asset("assets/anim/emptypurp.json",
                        width: 280, repeat: false),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ProductListTile(
                    // <- widget/project_list_tile
                    product: product,
                    onDelete: () async {
                      openIconSnackBar(
                          context,
                          "Deleting item..",
                          const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ));
                      await ref
                          .read(databaseProvider)!
                          .deleteProduct(product.id!);
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
