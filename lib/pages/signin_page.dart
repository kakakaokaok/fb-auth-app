import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sangwook_firebase_authentication_app/models/custom_error.dart';
import 'package:sangwook_firebase_authentication_app/pages/signup_page.dart';
import 'package:sangwook_firebase_authentication_app/providers/signin/signin_state.dart';
import 'package:validators/validators.dart';
import 'package:provider/provider.dart';

import '../providers/signin/signin_provider.dart';
import '../utils/error_dialog.dart';
import '../utils/logger.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);
  static const routeName = '/signin';
  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _email, _password;

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    logger.d('singin_page.dart\nemail: $_email, password: $_password');
    try {
      await context.read<SigninProvider>().signin(_email!, _password!);
    } on CustomError catch (e) {
      errorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final signinState = context.watch<SigninProvider>().state;

    /// 참조1: https://www.flutterclutter.dev/flutter/tutorials/prevent-back-button-from-closing-the-app/2021/14074/
    /// 참조2: https://protocoderspoint.com/flutter-double-back-press-to-exit-app/
    /// 뒤로가기 두번 눌렀을 때 앱을 종료하는 방법에 관하여
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Image.asset(
                      'assets/images/flutter_logo.png',
                      width: 250,
                      height: 250,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email required';
                        }
                        if (!isEmail(value.trim())) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _email = value;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password requried';
                        }
                        if (value.trim().length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _password = value;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed:
                          signinState.signinStatus == SigninStatus.submitting
                              ? null
                              : _submit,
                      child: signinState.signinStatus == SigninStatus.submitting
                          ? CupertinoActivityIndicator()
                          : Text('Sign In'),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed:
                          signinState.signinStatus == SigninStatus.submitting
                              ? null
                              : () => Navigator.pushNamed(
                                  context, SignupPage.routeName),
                      child: Text('Not a memeber? Sign up!'),
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
