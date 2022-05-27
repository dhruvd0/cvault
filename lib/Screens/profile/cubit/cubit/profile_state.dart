import 'dart:convert';

import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String code;
  final String uid;
  final String userType;
  final String referralCode;
  final String phone;
  const ProfileState({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.code,
    required this.uid,
    required this.userType,
    required this.referralCode,
    required this.phone,
  });
  @override
  List<Object> get props {
    return [
      firstName,
      middleName,
      lastName,
      email,
      code,
      uid,
      userType,
      referralCode,
      phone,
    ];
  }

  @override
  String toString() {
    return 'ProfileState(firstName: $firstName, middleName: $middleName, lastName: $lastName, email: $email, code: $code, uid: $uid, userType: $userType, referralCode: $referralCode, phone: $phone)';
  }

  ProfileState copyWith({
    String? firstName,
    String? middleName,
    String? lastName,
    String? email,
    String? code,
    String? uid,
    String? userType,
    String? referralCode,
    String? phone,
  }) {
    return ProfileState(
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      code: code ?? this.code,
      uid: uid ?? this.uid,
      userType: userType ?? this.userType,
      referralCode: referralCode ?? this.referralCode,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'code': code,
      'uid': uid,
      'userType': userType,
      'referralCode': referralCode,
      'phone': phone,
    };
  }

  factory ProfileState.fromMap(Map<String, dynamic> map) {
    return ProfileState(
      firstName: map['firstName'] ?? '',
      middleName: map['middleName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      code: map['code'] ?? '',
      uid: map['uid'] ?? '',
      userType: map['userType'] ?? '',
      referralCode: map['referralCode'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
}

enum ProfileFields {
  firstName,
  middleName,
  lastName,
  email,
  code,
  referralCode,
}

class ProfileInitial extends ProfileState {
  const ProfileInitial()
      : super(
          firstName: '',
          email: '',
          middleName: '',
          code: '',
          lastName: '',
          referralCode: '',
          userType: 'admin',
          uid: '',
          phone: '',
        );
}

class NewProfile extends ProfileState {
  const NewProfile({required String userType, required String uid,required String phone})
      : super(
          firstName: '',
          email: '',
          middleName: '',
          code: '',
          lastName: '',
          referralCode: '',
          userType: userType,
          uid: uid,
          phone: phone
        );
}
