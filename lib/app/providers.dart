import 'package:ecom_store_riv/models/bagview.dart';
import 'package:ecom_store_riv/services/firestore_service.dart';
import 'package:ecom_store_riv/services/payment_service.dart';
import 'package:ecom_store_riv/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

//firebase auth provider
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

//authstate change provider
final authStateChangeProvider = StreamProvider<User?>(
  (ref) {
    return ref.watch(firebaseAuthProvider).authStateChanges();
  },
);

//database provider
final databaseProvider = Provider<FireStoreService?>(
  (ref) {
    final auth = ref.watch(authStateChangeProvider);

    String? uid = auth.asData?.value?.uid;
    if (uid != null) {
      return FireStoreService(uid: uid);
    }
    return null;
  },
);

//image provider
final addImageProvider = StateProvider<XFile?>((_) => null);

//storage provider
final storageProvider = Provider<StorageService?>(
  (ref) {
    final auth = ref.watch(authStateChangeProvider);

    String? uid = auth.asData?.value?.uid;
    if (uid != null) {
      return StorageService(uid: uid);
    }
    return null;
  },
);

//bag provider
final bagProvider = ChangeNotifierProvider<BagViewModel>(
  (ref) {
    return BagViewModel();
  },
);

//payment provider
final paymentProvider = Provider<PaymentService>(
  (ref) {
    return PaymentService();
  },
);
