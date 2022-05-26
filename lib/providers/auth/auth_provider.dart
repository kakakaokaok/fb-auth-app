import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../../repositories/auth_repository.dart';
import '../../utils/logger.dart';
import 'auth_state.dart';

class AuthProvider with ChangeNotifier {
  AuthState _state = AuthState.unknown();
  AuthState get state => _state;

  final AuthRepository authRepository;
  AuthProvider(this.authRepository);

  void update(fb_auth.User? user) {
    if (user != null) {
      _state = _state.copyWith(
        authStatus: AuthStatus.authenticated,
        user: user,
      );
    } else {
      _state = _state.copyWith(authStatus: AuthStatus.unauthenticated);
    }
    logger.d('auth_provider.dart ${StackTrace.current}\nauthState: $_state');
    notifyListeners();
  }

  void signout() async {
    await authRepository.signout();
  }
}
