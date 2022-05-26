// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus authStatus;
  final fb_auth.User? user;

  const AuthState(this.authStatus, [this.user]);

  factory AuthState.unknown() {
    return const AuthState(AuthStatus.unknown);
  }
  @override
  List<Object?> get props => [authStatus, user];

  @override
  bool get stringify => true;

  AuthState copyWith({
    AuthStatus? authStatus,
    fb_auth.User? user,
  }) {
    return AuthState(
      authStatus ?? this.authStatus,
      user ?? this.user,
    );
  }
}
