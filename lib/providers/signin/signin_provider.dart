import 'package:flutter/foundation.dart';
import 'package:sangwook_firebase_authentication_app/models/custom_error.dart';

import '../../repositories/auth_repository.dart';
import 'signin_state.dart';

class SigninProvider with ChangeNotifier {
  SigninState _state = SigninState.initial();

  SigninProvider(this.authRepository);
  SigninState get state => _state;

  final AuthRepository authRepository;

  Future<void> signin(String email, String password) async {
    _state = _state.copyWith(signinStatus: SigninStatus.submitting);
    notifyListeners();

    try {
      await authRepository.singin(email: email, password: password);
      _state = _state.copyWith(signinStatus: SigninStatus.success);
    } on CustomError catch (e) {
      _state = _state.copyWith(signinStatus: SigninStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }
}
