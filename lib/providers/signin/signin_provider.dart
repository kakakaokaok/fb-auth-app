import 'package:sangwook_firebase_authentication_app/models/custom_error.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../repositories/auth_repository.dart';
import 'signin_state.dart';

class SigninProvider extends StateNotifier<SigninState> with LocatorMixin {
  /// AuthRepository를 필요로 하기 때문에 LocatorMixin과 mixin

  SigninProvider() : super(SigninState.initial());

  Future<void> signin(String email, String password) async {
    state = state.copyWith(signinStatus: SigninStatus.submitting);

    try {
      await read<AuthRepository>().signin(email: email, password: password);
      state = state.copyWith(signinStatus: SigninStatus.success);
    } on CustomError catch (e) {
      state = state.copyWith(signinStatus: SigninStatus.error, error: e);
      rethrow;
    }
  }
}
