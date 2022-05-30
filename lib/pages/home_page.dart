import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    /// 참조1: https://www.flutterclutter.dev/flutter/tutorials/prevent-back-button-from-closing-the-app/2021/14074/
    /// 참조2: https://protocoderspoint.com/flutter-double-back-press-to-exit-app/
    /// 뒤로가기 두번 눌렀을 때 앱을 종료하는 방법에 관하여
    return WillPopScope(
      onWillPop: () async => false,
      child: const Scaffold(
        body: Center(
          child: Text('Home'),
        ),
      ),
    );
  }
}
