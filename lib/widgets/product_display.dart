import 'package:ecom_store_riv/app/providers.dart';
import 'package:ecom_store_riv/models/product.dart';
import 'package:ecom_store_riv/widgets/emptybox.dart';
import 'package:ecom_store_riv/widgets/product_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsDisplay extends ConsumerWidget {
  const ProductsDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<Product>>(
      stream: ref.read(databaseProvider)!.getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.data != null) {
          if (snapshot.data!.isEmpty) {
            return const EmptyBox();
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return ProductGridView(product: product);
              },
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
