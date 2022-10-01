import 'package:ecom_store_riv/app/providers.dart';
import 'package:ecom_store_riv/extensions/string_ext.dart';
import 'package:ecom_store_riv/widgets/emptybox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserBag extends ConsumerWidget {
  const UserBag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final bagViewmodel = ref.watch(bagProvider);
    return Scaffold(
      // <- SSP (foundation)
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  const Flexible(
                    child: Text(
                      "My Bag",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              bagViewmodel.productBag.isEmpty
                  ? const Center(child: EmptyBox())
                  : Flexible(
                      child: ListView.builder(
                        itemCount: bagViewmodel.totalProducts,
                        itemBuilder: (context, index) {
                          final prod = bagViewmodel.productBag[index];
                          return ListTile(
                            title: Text(prod.name.capitalize()),
                            subtitle: Text("\$${prod.price}"),
                            trailing: IconButton(
                              onPressed: () {
                                bagViewmodel.removeProduct(prod);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          );
                        },
                      ),
                    ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: \$${bagViewmodel.totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final payment = ref.read(paymentProvider);
                        final user = ref.read(authStateChangeProvider);
                        final userbag = ref.watch(bagProvider);

                        final result = await payment.initPaymentSheet(
                          user.value!,
                          userbag.totalPrice,
                        );

                        if (!result.isError) {
                          ref.read(databaseProvider)!.saveOrder(
                              result.payIntentId!, userbag.productBag);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Payment completed!'),
                            ),
                          );

                          userbag.clearBag();
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          //
                          //
                        } else {
                          //
                          //
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result.message),
                            ),
                          );
                        }
                      },
                      child: const Text("Checkout"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
