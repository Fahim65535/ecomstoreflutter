import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final String uid;
  StorageService({required this.uid});

  FirebaseStorage storage = FirebaseStorage.instance;

  //function which returns image URL location (filepath)
  Future<String> uploadFile(String filePath) async {
    try {
      final dateTime = DateTime.now().toIso8601String();
      final ref = storage.ref("$uid/$dateTime"); // to specify storage location
      final uploadtask = await ref.putFile(File(filePath)); //uploading file
      return await uploadtask.ref.getDownloadURL();
    } catch (e) {
      print('errrrrorr');
    }
    return "";
  }
}
