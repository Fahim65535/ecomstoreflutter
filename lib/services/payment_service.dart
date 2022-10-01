import 'dart:convert';
import 'package:ecom_store_riv/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:http/http.dart' as http;

class PaymentHandler {
  final String? payIntentId;
  final bool isError;
  final String message;

  PaymentHandler({
    this.payIntentId,
    required this.isError,
    required this.message,
  });
}

class PaymentService {
  PaymentService();

  Future<PaymentHandler> initPaymentSheet(User user, double totalAmount) async {
    try {
// 1. create payment intent on the server
      final response = await http.post(
          // sends information to the server and receives a response
          Uri.parse(cloudFunction),
          body: {
            'email': user.email,
            'amount': (totalAmount * 100).toString(),
          });
      // print(response.body);
      final jsonResponse = jsonDecode(response.body);

      //2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: jsonResponse['paymentIntent'],
          merchantDisplayName: 'Flutter Stripe Store Demo',
          customerId: jsonResponse['customer'],
          customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
          style: ThemeMode.light,
        ),
      );

      //presenting to user and await for the result
      await Stripe.instance.presentPaymentSheet();
      return PaymentHandler(
        isError: false,
        message: 'Success',
        payIntentId: jsonResponse['paymentIntent'],
      );
    } catch (error) {
      if (error is StripeException) {
        return PaymentHandler(isError: true, message: 'Payment cancelled');
      } else {
        return PaymentHandler(isError: true, message: 'Error: $error');
      }
    }
  }
}
