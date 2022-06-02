import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:state_notifier/state_notifier.dart';

import '../../repositories/auth_repository.dart';
import '../../utils/logger.dart';
import 'auth_state.dart';

class AuthProvider extends StateNotifier<AuthState> with LocatorMixin {
  /// LocatorMixin을 통해 다른 Provider에 쉽게 접근이 가능함
  AuthProvider() : super(AuthState.unknown());

  @override
  void update(Locator watch) {
    /// watch가 뭐지?
    final user = watch<fb_auth.User?>();
    if (user != null) {
      state = state.copyWith(
        authStatus: AuthStatus.authenticated,
        user: user,
      );
    } else {
      state = state.copyWith(authStatus: AuthStatus.unauthenticated);
    }
    logger.d('auth_provider.dart\nauthState: $state');
    super.update(watch);
  }

  void signout() async {
    await read<AuthRepository>().signout();
  }
}
