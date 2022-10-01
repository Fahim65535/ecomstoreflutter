import 'package:ecom_store_riv/app/auth_widget.dart';
import 'package:ecom_store_riv/app/pages/admin/admin_home.dart';
import 'package:ecom_store_riv/app/pages/auth/sign_in_page.dart';
import 'package:ecom_store_riv/app/pages/user/user_home.dart';
import 'package:ecom_store_riv/utils/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey = publicKey;
  Stripe.merchantIdentifier = "anyString";
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecom Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          primary: Colors.deepPurple,
          seedColor: Colors.deepPurple,
        ),
      ),
      home: AuthWidget(
        adminSignedBuilder: (context) => const AdminHome(),
        signedInBuilder: (context) => const UserHome(),
        nonSignedInBuilder: (context) => const SignInPage(),
      ),
    );
  }
}























// import 'package:ecom_store_riv/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(ProviderScope(child: MyApp())); //stores state of all providers in app
// }

// //setting provider as global variable
// final counterProvider = StateNotifierProvider((ref) {
//   return Counter();
// });

// /*
// -  Using stateNotifier as we want the state object to be immutable
//    except thru an interface. 
//  - Rebuilds automatically, no need for notify listeners.
//  - Increment method is used to add 1 to the state everytime.
//  - state is defined on super as 0 and stateNotifier has int type.
//   */
// class Counter extends StateNotifier<int> {
//   Counter() : super(0);

//   void increment() => state++;
// }

// /*
// - ConsumerWidget is just like statelessWidget.
// - Only difference, has extra parameter on build method (ref object).
// - ref object - used to access the providers and read/write from them.
//  */
// class MyApp extends ConsumerWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     /*
//     ref.watch provides count state and is used to display
//     the counter on screen using a text widget
//      */
//     final count = ref.watch(counterProvider);

//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             //ref.read reads from notifier and calls the  increment method
//             ref.read(counterProvider.notifier).increment();
//           },
//           child: const Icon(Icons.add),
//         ),
//         body: Center(
//           child: Text(
//             count.toString(), // <- ref.watch
//           ),
//         ),
//       ),
//     );
//   }
// }
