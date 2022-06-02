import 'package:state_notifier/state_notifier.dart';

import '../../models/custom_error.dart';
import '../../repositories/auth_repository.dart';
import 'signup_state.dart';

class SignupProvider extends StateNotifier<SignupState> with LocatorMixin {
  SignupProvider() : super(SignupState.initial());

  Future<void> signup(String name, String email, String password) async {
    state = state.copyWith(signupStatus: SignupStatus.submitting);

    try {
      await read<AuthRepository>()
          .signup(name: name, email: email, password: password);
      state = state.copyWith(signupStatus: SignupStatus.success);
    } on CustomError catch (e) {
      state = state.copyWith(signupStatus: SignupStatus.error, error: e);
      rethrow;
    }
  }
}
