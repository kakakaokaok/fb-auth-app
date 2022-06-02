import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sangwook_firebase_authentication_app/pages/signin_page.dart';

import '../providers/auth/auth_provider.dart';
import '../providers/auth/auth_state.dart';
import 'home_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    /// StateNotifier를 사용하기 때문에 state에 access 할때는
    /// State 타입을 extension method에 준다.
    /// 그 자체가 state이기 때문에 state getter가 없다.
    final authState = context.watch<AuthState>();

    if (authState.authStatus == AuthStatus.authenticated) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushNamed(context, HomePage.routeName);
      });
    } else if (authState.authStatus == AuthStatus.unauthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushNamed(context, SigninPage.routeName);
      });
    }
    return const Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
