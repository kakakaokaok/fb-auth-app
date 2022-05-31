// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../constants/db_constants.dart';
import '../models/custom_error.dart';
import '../utils/logger.dart';

class AuthRepository {
  final FirebaseFirestore firebaseFirestore;
  final fb_auth.FirebaseAuth firebaseAuth;
  AuthRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  /// user 상태를 stream으로 알려주는 userChanges()
  Stream<fb_auth.User?> get user => firebaseAuth.userChanges();

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final fb_auth.UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      /// 성공했기 때문에 !. 실패했다면 exception이 뜨겠지
      final signedInUser = userCredential.user!;

      /// users collection을 만든다?
      /// 여기서 안만들어지는건가
      /// 왜 안만들어지지?
      await usersRef.doc(signedInUser.uid).set({
        'name': name,
        'email': email,
        'profileImageUrl':
            'https://dg.imgix.net/submit-your-felt-reality-to-god-8b6tqc8z-en/landscape/submit-your-felt-reality-to-god-8b6tqc8z-b915a1b3aede8f2481deee45bb25c517.jpg?ts=1650998977&ixlib=rails-4.2.0&auto=format%2Ccompress&fit=min&w=700&h=394&dpr=2&ch=Width%2CDPR',
        'point': 0,

        /// Enum to Json
        /// https://stackoverflow.com/questions/53035817/how-to-manage-serialize-deserialize-an-enum-property-with-dart-flutter-to-fi
        'rank': 'bronze',
      }).onError((error, stackTrace) =>
          logger.d('collection wasn\'t created: $error'));
    } on fb_auth.FirebaseAuthException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error\nauth_repository.dart',
      );
    }
  }

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on fb_auth.FirebaseAuthException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<void> signout() async {
    await firebaseAuth.signOut();
  }
}
