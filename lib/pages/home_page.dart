import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sangwook_firebase_authentication_app/pages/profile_page.dart';
import 'package:sangwook_firebase_authentication_app/providers/auth/auth_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Home'),
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthProvider>().signout();
              },
              icon: Icon(Icons.exit_to_app),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProfilePage();
                    },
                  ),
                );
              },
              icon: Icon(Icons.exit_to_app),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/flutter_favorite.png',
                    width: 100,
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Provider',
                    style: TextStyle(fontSize: 42),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Provider is an awesome\nstate management library\nfor flutter!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
