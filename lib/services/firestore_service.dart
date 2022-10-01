import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_store_riv/models/order.dart';
import 'package:ecom_store_riv/models/product.dart';
import 'package:ecom_store_riv/models/userdata.dart';

class FireStoreService {
  final String uid;
  FireStoreService({required this.uid});

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //function to ADD product to database via firestore service with the product model to update UI
  Future<void> addProduct(
    Product product,
  ) async {
    final docId = firestore.collection("products").doc().id;
    await firestore.collection("products").doc(docId).set(product.toMap(docId));

    // (before generating doc Id)
    // await firestore
    //     .collection("products")
    //     .add(product.toMap())
    //     .then((value) => print(value))
    //     .catchError((onError) => print("Errrrror"));
  }

  //function to DISPLAY the list of products from database via firestore service with the product model as a stream onto the admin home (UI)
  Stream<List<Product>> getProducts() {
    return firestore
        .collection("products")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return Product.fromMap(data);
            }).toList());
  }

/* EXPLAINATION (display) =>

 - Stream<QuerySnapshot<Map<String, dynamic>>> which is definitely not a List<Product>. 
 - What we can do is try to loop through all the snapshots inside this collection using the .map function and loop through all the documents contained in the snapshots using the .map function. 
 - Once we are at the document level we can use doc.data() to get the document’s data and then we use our Product.fromMap we created earlier on to convert from JSON to Product and build a list out of it. 
 - The last thing to do is to convert the mapping into an actual List using the .toList() method.

 */

  //function to DELETE product from the database and the admin screen (UI) via firebase service with the doc id
  Future<void> deleteProduct(String id) async {
    return await firestore.collection("products").doc(id).delete();
  }

  //function to ADD userdata to the database via firestore service with the userdata model to update UI for user
  Future<void> addUser(
    UserData user,
  ) async {
    await firestore.collection("users").doc(user.uid).set(user.toMap());
  }

  //function to GET userdata from database via firestore service with the user data model (null)
  Future<UserData?> getUser(String uid) async {
    final doc = await firestore.collection("users").doc(uid).get();
    return doc.exists ? UserData.fromMap(doc.data()!) : null;
  }

  //function to SAVE order
  Future<void> saveOrder(String confirmationId, List<Product> products) async {
    //
    //
    // Save the order in the orders collection of the user
    await firestore.collection("users").doc(uid).collection("orders").add(
      {
        'confirmationId': confirmationId,
        'products':
            products.map((product) => product.toMap(product.id!)).toList(),
        'timestamp': FieldValue.serverTimestamp(),
      },
    );
    //
    //
    // Save the order on an outer collection for the admin / user depending on your design decision.
    await firestore.collection("orders").doc(confirmationId).set(
      {
        'confirmationId': confirmationId,
        'products':
            products.map((product) => product.toMap(product.id!)).toList(),
        'timestamp': FieldValue.serverTimestamp(),
      },
    );
  }

  Stream<List<Order>> getOrders() {
    return firestore
        .collection("users")
        .doc(uid)
        .collection("orders")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(
            (doc) {
              final d = doc.data();
              return Order.fromMap(d);
            },
          ).toList(),
        );
  }
}
