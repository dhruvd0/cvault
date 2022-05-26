import 'dart:convert';

import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String fullName;
  final String middleName;
  final String lastName;
  final String email;
  final String code;
  final String uid;
  final String userType;
  final String referralCode;
  const ProfileState({
    required this.fullName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.code,
    required this.uid,
    required this.userType,
    required this.referralCode,
  });
  @override
  List<Object> get props {
    return [
      fullName,
      middleName,
      lastName,
      email,
      code,
      uid,
      userType,
      referralCode,
    ];
  }

  @override
  String toString() {
    return 'ProfileState(fullName: $fullName, middleName: $middleName, lastName: $lastName, email: $email, code: $code, uid: $uid, userType: $userType, referralCode: $referralCode)';
  }

  ProfileState copyWith({
    String? fullName,
    String? middleName,
    String? lastName,
    String? email,
    String? code,
    String? uid,
    String? userType,
    String? referralCode,
  }) {
    return ProfileState(
      fullName: fullName ?? this.fullName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      code: code ?? this.code,
      uid: uid ?? this.uid,
      userType: userType ?? this.userType,
      referralCode: referralCode ?? this.referralCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'code': code,
      'uid': uid,
      'userType': userType,
      'referralCode': referralCode,
    };
  }

  factory ProfileState.fromMap(Map<String, dynamic> map) {
    return ProfileState(
      fullName: map['fullName'] ?? '',
      middleName: map['middleName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      code: map['code'] ?? '',
      uid: map['uid'] ?? '',
      userType: map['userType'] ?? '',
      referralCode: map['referralCode'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
}

enum ProfileFields {
  fullName,
  middleName,
  lastName,
  email,
  code,
  referralCode,
}

class ProfileInitial extends ProfileState {
  const ProfileInitial()
      : super(
          fullName: '',
          email: '',
          middleName: '',
          code: '',
          lastName: '',
          referralCode: '',
          userType: 'admin',
          uid: '',
        );
}

class NewProfile extends ProfileState {
  const NewProfile({required String userType, required String uid})
      : super(
          fullName: '',
          email: '',
          middleName: '',
          code: '',
          lastName: '',
          referralCode: '',
          userType: userType,
          uid: uid,
        );
}
