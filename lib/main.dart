import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:sangwook_firebase_authentication_app/providers/profile/profile_state.dart';
import 'package:sangwook_firebase_authentication_app/providers/signin/signin_state.dart';
import 'package:sangwook_firebase_authentication_app/providers/signup/signup_state.dart';

import 'pages/home_page.dart';
import 'pages/signin_page.dart';
import 'pages/signup_page.dart';
import 'pages/splash_page.dart';
import 'providers/auth/auth_provider.dart';
import 'providers/auth/auth_state.dart';
import 'providers/profile/profile_provider.dart';
import 'providers/signin/signin_provider.dart';
import 'providers/signup/signup_provider.dart';
import 'repositories/auth_repository.dart';
import 'repositories/profile_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
              firebaseFirestore: FirebaseFirestore.instance,
              firebaseAuth: fb_auth.FirebaseAuth.instance),
        ),
        Provider<ProfileRepository>(
          create: (context) => ProfileRepository(FirebaseFirestore.instance),
        ),
        StreamProvider<fb_auth.User?>(
          create: (context) => context.read<AuthRepository>().user,
          initialData: null,
        ),
        StateNotifierProvider<AuthProvider, AuthState>(
          create: (context) => AuthProvider(),
        ),

        /// StateNotifier의 타입 뿐만 아니라
        /// StateNotifier에서 handling하는 state 타입도 지정
        StateNotifierProvider<SigninProvider, SigninState>(
          create: (context) => SigninProvider(),
        ),
        StateNotifierProvider<SignupProvider, SignupState>(
          create: (context) => SignupProvider(),
        ),
        StateNotifierProvider<ProfileProvider, ProfileState>(
          create: (context) => ProfileProvider(),
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
}
