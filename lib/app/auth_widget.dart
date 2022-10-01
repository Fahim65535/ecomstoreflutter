/*Auth widget is responsible for building correct UIs depending
on the auth state. 
Its a key widget when building authentication systems */

import 'package:ecom_store_riv/app/providers.dart';
import 'package:ecom_store_riv/models/userdata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWidget extends ConsumerWidget {
  //these parameters will build UI
  final WidgetBuilder nonSignedInBuilder;
  final WidgetBuilder signedInBuilder;
  final WidgetBuilder adminSignedBuilder;

  final adminEmail =
      "admin@admin.com"; // todo: store it somewhere in production
  const AuthWidget({
    Key? key,
    required this.adminSignedBuilder,
    required this.signedInBuilder,
    required this.nonSignedInBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateChanges = ref.watch(authStateChangeProvider);

    // const adminEmail = "admin@admin.com"; //storing it here temporarily

    // .when builder/function provides 3 callbacks.
    return authStateChanges.when(
      data: (user) => user != null
          ? signedInHandler(context, ref, user)
          : nonSignedInBuilder(context),
      error: (_, __) => const Scaffold(
        body: Center(
          child: Text("Something went wrong!"),
        ),
      ),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  //function for user data ???
  FutureBuilder<UserData?> signedInHandler(context, WidgetRef ref, User user) {
    final database = ref.read(databaseProvider)!;
    final potentialUserFuture = database.getUser(user.uid);
    return FutureBuilder<UserData?>(
        future: potentialUserFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final potentialUser = snapshot.data;
            if (potentialUser == null) {
              database.addUser(UserData(
                  email: user.email != null ? user.email! : "",
                  uid: user
                      .uid)); // no need to await as you don't depend on that
            }
            if (user.email == adminEmail) {
              return adminSignedBuilder(context);
            }
            return signedInBuilder(context);
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
