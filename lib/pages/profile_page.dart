import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../providers/profile/profile_provider.dart';
import '../providers/profile/profile_state.dart';
import '../utils/error_dialog.dart';
import '../utils/logger.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileProvider profileProv;

  /// addListner에 return value를 저장할
  late final void Function() _removeListener;

  @override
  void initState() {
    super.initState();
    logger.d('initState');

    /// initState에서 context 사용 가능???? 안된다고 했던것 같은데
    profileProv = context.read<ProfileProvider>();
    _removeListener =
        profileProv.addListener(errorDialogListner, fireImmediately: false);
    _getProfile();
  }

  void _getProfile() {
    final String uid = context.read<fb_auth.User?>()!.uid;
    logger.d('profile_page.dart\nuid: $uid');

    /// initState에서 async 함수를 호출하는 건 UI에 inconsistency를 야기시킬 수 있기 때문에
    /// 현재 프레임이 끝나고 호출될 수 있도록 아래와 같이
    /// addPostFrameCallback 내에서 실행함
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProfileProvider>().getProfile('uid');
    });
  }

  void errorDialogListner(ProfileState state) {
    if (state.profileStatus == ProfileStatus.error) {
      logger.d('errorDialog');
      errorDialog(context, state.error);
    }
  }

  @override
  void dispose() {
    logger.d('dispose');
    // profileProv.removeListener(errorDialogListner);
    _removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('build');
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: _buildProfile(),
    );
  }

  Widget _buildProfile() {
    final profileState = context.watch<ProfileState>();

    // if (profileState.profileStatus == ProfileStatus.initial) {
    //   return Container();
    // } else if (profileState.profileStatus == ProfileStatus.loading) {
    //   return Center(child: CupertinoActivityIndicator());
    // } else if (profileState.profileStatus == ProfileStatus.error) {
    //   return _errorWidget();
    // }
    // return _userProfile(profileState);

    switch (profileState.profileStatus) {
      case ProfileStatus.initial:
        return Container();
      case ProfileStatus.loading:
        return Center(child: CupertinoActivityIndicator());
      case ProfileStatus.loaded:
        return _userProfile(profileState);
      case ProfileStatus.error:
        return _errorWidget();
    }
  }

  Card _userProfile(ProfileState profileState) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInImage.assetNetwork(
            placeholder: 'assets/images/loading.gif',
            image: profileState.user.profileImageUrl,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '- ID: ${profileState.user.id}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  '- Name: ${profileState.user.name}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  '- Email: ${profileState.user.email}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  '- Point: ${profileState.user.point}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  '- Rank: ${profileState.user.rank}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorWidget() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/error.png',
            width: 75,
            height: 75,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 20),
          Text(
            'Ooops!\nTry again',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
