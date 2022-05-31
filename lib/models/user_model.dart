// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

enum Rank {
  @JsonValue('bronze')
  bronze,
  @JsonValue('silver')
  silver,
  @JsonValue('gold')
  gold,
  @JsonValue('initial')
  initial,
}

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String profileImageUrl;
  final int point;
  final Rank rank;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImageUrl,
    required this.point,
    required this.rank,
  });

  factory User.fromDoc(DocumentSnapshot userDoc) {
    final userData = userDoc.data() as Map<String, dynamic>?;

    return User(
      id: userDoc.id,
      name: userData!['name'],
      email: userData['email'],
      profileImageUrl: userData['profileImageUrl'],
      point: userData['point'],
      rank: userData['rank'],
    );
  }
  factory User.initialUser() {
    return User(
      id: '',
      name: '',
      email: '',
      profileImageUrl: '',
      point: -1,
      rank: Rank.initial,
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      email,
      profileImageUrl,
      point,
      rank,
    ];
  }

  @override
  bool get stringify => true;
}
