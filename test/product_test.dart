import 'package:ecom_store_riv/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Product description matches the defined text', () {
    const description = 'This is a test description';
    const name = "Product";
    final product = Product(
      name: "Product",
      description: description,
      price: 12.99,
      imageUrl: "imageUrl",
    );
    expect(product.description, description);
    expect(product.name, name);
  });
  test('Product description matches the defined text', () {
    const name = "Product";
    final product = Product(
      name: "Product",
      description: "description",
      price: 12.99,
      imageUrl: "imageUrl",
    );

    expect(product.name, name);
  });
}
