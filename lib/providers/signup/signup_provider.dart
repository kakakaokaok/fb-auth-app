import 'package:flutter/foundation.dart';
import 'package:sangwook_firebase_authentication_app/models/custom_error.dart';

import '../../repositories/auth_repository.dart';
import 'signup_state.dart';

class SignupProvider with ChangeNotifier {
  SignupState _state = SignupState.initial();

  SignupProvider(this.authRepository);
  SignupState get state => _state;

  final AuthRepository authRepository;

  Future<void> signup(String name, String email, String password) async {
    _state = _state.copyWith(signupStatus: SignupStatus.submitting);
    notifyListeners();

    try {
      await authRepository.signup(name: name, email: email, password: password);
      _state = _state.copyWith(signupStatus: SignupStatus.success);
    } on CustomError catch (e) {
      _state = _state.copyWith(signupStatus: SignupStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }
}
