import 'package:state_notifier/state_notifier.dart';

import '../../models/custom_error.dart';
import '../../models/user_model.dart';
import '../../repositories/profile_repository.dart';
import 'profile_state.dart';

/// ProfileRepository를 필요로 하기 때문에 LocatorMixin과 mixin.
class ProfileProvider extends StateNotifier<ProfileState> with LocatorMixin {
  ProfileProvider() : super(ProfileState.initial());

  Future<void> getProfile(String uid) async {
    state = state.copyWith(profileStatus: ProfileStatus.loading);

    try {
      final User user = await read<ProfileRepository>().getProfile(uid);

      state = state.copyWith(profileStatus: ProfileStatus.loaded, user: user);
    } on CustomError catch (e) {
      state = state.copyWith(profileStatus: ProfileStatus.error, error: e);
    }
  }
}
