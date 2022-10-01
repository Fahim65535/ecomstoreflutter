import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyBox extends StatelessWidget {
  final String text;
  const EmptyBox({
    Key? key,
    this.text = "No products yet",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(
          "assets/anim/emptypurp.json",
          width: 250,
          repeat: false,
        ),
      ],
    );
  }
}
