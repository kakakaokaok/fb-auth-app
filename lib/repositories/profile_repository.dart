import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sangwook_firebase_authentication_app/constants/db_constants.dart';
import 'package:sangwook_firebase_authentication_app/models/custom_error.dart';

import '../models/user_model.dart';
import '../utils/logger.dart';

class ProfileRepository {
  final FirebaseFirestore firebaseFirestore;
  ProfileRepository(this.firebaseFirestore);

  Future<User> getProfile(String uid) async {
    try {
      final DocumentSnapshot userDoc = await usersRef.doc(uid).get();
      final User currentUser = User.fromDoc(userDoc);
      logger.d(currentUser);

      return currentUser;
    } on FirebaseException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error\n(profile_repository.dart)',
      );
    }
  }
}
