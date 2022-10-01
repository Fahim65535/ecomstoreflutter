import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ecom_store_riv/models/product.dart';

class Order {
  String confirmationId;
  Timestamp? timestamp;

  List<Product> products;

  Order({
    required this.confirmationId,
    this.timestamp,
    required this.products,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    //
    //
    final currentTime = Timestamp.fromMicrosecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch);
    //
    final timeStamps =
        map['timestamp'] == null ? currentTime : map['timestamp'] as Timestamp;

    return Order(
      confirmationId: map['confirmationId'],
      products: (map['products'] as List<dynamic>)
          .map((product) => Product.fromMap(product))
          .toList(),
      timestamp: timeStamps,
    );
  }
}
