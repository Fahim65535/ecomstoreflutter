import 'dart:io';

import 'package:ecom_store_riv/app/providers.dart';
import 'package:ecom_store_riv/models/product.dart';
import 'package:ecom_store_riv/utils/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AdminAddProductPage extends ConsumerStatefulWidget {
  const AdminAddProductPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminAddProductPageState();
}

class _AdminAddProductPageState extends ConsumerState<AdminAddProductPage> {
  final titletextEditingController = TextEditingController();
  final descriptionEditingController = TextEditingController();
  final priceEditingController = TextEditingController();
  SizedBox height = const SizedBox(height: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomInputFieldFb1(
                inputController: titletextEditingController,
                hintText: "Product Name",
                labelText: "Product Name",
              ),
              height,
              CustomInputFieldFb1(
                inputController: descriptionEditingController,
                hintText: "Product Description",
                labelText: "Product Description",
              ),
              height,
              CustomInputFieldFb1(
                inputController: priceEditingController,
                hintText: "Product Price",
                labelText: "Product Price",
              ),
              height,
              Consumer(
                builder: (context, watch, child) {
                  final image = ref.watch(addImageProvider);
                  return image == null
                      ? const Text('No image selected')
                      : Image.file(
                          File(image.path),
                          height: 200,
                        );
                },
              ),
              height,
              //upload image button
              ElevatedButton(
                onPressed: () async {
                  final image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    ref.watch(addImageProvider.state).state = image;
                  }
                },
                child: const Text("Upload Image"),
              ),

              //add product button
              ElevatedButton(
                onPressed: () => _addProduct(),
                child: const Text("Add Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addProduct() async {
    final storage = ref.read(databaseProvider); //reference product data
    final fileStorage = ref.read(storageProvider); //reference file storage
    final imageFile =
        ref.read(addImageProvider.state).state; //reference image file

    if (storage == null || fileStorage == null || imageFile == null) {
      print("Error: storage, filestorage / imageFile is null");
      return;
    }

    //uploading to fireStorage
    final imageUrl = await fileStorage.uploadFile(imageFile.path);
    await storage.addProduct(
      Product(
          name: titletextEditingController.text,
          description: descriptionEditingController.text,
          price: double.parse(priceEditingController.text),
          imageUrl: imageUrl), // adding imageUrl instance to store the image
    );
    openIconSnackBar(
      context,
      "Product added successfully",
      const Icon(
        Icons.check,
        color: Colors.white,
      ),
    );
    Navigator.pop(context);
  }
}

//input fields
class CustomInputFieldFb1 extends StatelessWidget {
  final TextEditingController inputController;
  final String hintText;
  final Color primaryColor;
  final String labelText;

  const CustomInputFieldFb1(
      {Key? key,
      required this.inputController,
      required this.hintText,
      required this.labelText,
      this.primaryColor = Colors.indigo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
            color: Colors.grey.withOpacity(.1)),
      ]),
      child: TextField(
        controller: inputController,
        onChanged: (value) {
          //Do something wi
        },
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          border: UnderlineInputBorder(
            borderSide:
                BorderSide(color: primaryColor.withOpacity(.1), width: 2.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 2.0),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: primaryColor.withOpacity(.1), width: 2.0),
          ),
        ),
      ),
    );
  }
}
