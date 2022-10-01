import 'package:ecom_store_riv/app/providers.dart';
import 'package:ecom_store_riv/models/order.dart';
import 'package:ecom_store_riv/widgets/emptybox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserOrders extends ConsumerWidget {
  const UserOrders({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: StreamBuilder<List<Order>>(
        stream: ref.read(databaseProvider)!.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.data != null) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: EmptyBox(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final orders = snapshot.data![index];
                final total = orders.products
                    .map(((e) => e.price))
                    .reduce((value, element) => value + element);
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(orders.products.map((e) => e.name).join(', ')),
                    subtitle: Text(orders.timestamp!.toDate().toString()),
                    trailing: Text('\$ $total'),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
