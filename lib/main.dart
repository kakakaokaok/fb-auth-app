import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sangwook_firebase_authentication_app/providers/signin/signin_provider.dart';

import 'pages/home_page.dart';
import 'pages/signin_page.dart';
import 'pages/signup_page.dart';
import 'pages/splash_page.dart';
import 'providers/auth/auth_provider.dart';
import 'providers/signup/signup_provider.dart';
import 'repositories/auth_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Something went wrong'),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              Provider<AuthRepository>(
                create: (context) => AuthRepository(
                    firebaseFirestore: FirebaseFirestore.instance,
                    firebaseAuth: fb_auth.FirebaseAuth.instance),
              ),
              StreamProvider<fb_auth.User?>(
                create: (context) => context.read<AuthRepository>().user,
                initialData: null,
              ),
              ChangeNotifierProxyProvider<fb_auth.User?, AuthProvider>(
                create: (context) =>
                    AuthProvider(context.read<AuthRepository>()),
                update: (BuildContext context, fb_auth.User? userStream,
                        AuthProvider? authProvider) =>
                    authProvider!..update(userStream),
              ),
              ChangeNotifierProvider<SigninProvider>(
                create: (context) =>
                    SigninProvider(context.read<AuthRepository>()),
              ),
              ChangeNotifierProvider<SignupProvider>(
                create: (context) =>
                    SignupProvider(context.read<AuthRepository>()),
              ),
            ],
            child: MaterialApp(
              title: 'Auth Provider',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: SplashPage(),
              routes: {
                SignupPage.routeName: (context) => SignupPage(),
                SigninPage.routeName: (context) => SigninPage(),
                HomePage.routeName: (context) => HomePage(),
              },
            ),
          );
        }
        return CupertinoActivityIndicator();
      },
    );
  }
}
