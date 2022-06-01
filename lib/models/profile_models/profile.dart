import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;

  final String uid;
  final String userType;
  final String referralCode;
  final String phone;
  const Profile({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
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
      uid,
      userType,
      referralCode,
      phone,
    ];
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    throw UnimplementedError('Use either Dealer or Customer .fromMap');
  }

  Profile copyWith({
    String? firstName,
    String? middleName,
    String? lastName,
    String? email,
    String? uid,
    String? userType,
    String? referralCode,
    String? phone,
  }) {
    return Profile(
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      userType: userType ?? this.userType,
      referralCode: referralCode ?? this.referralCode,
      phone: phone ?? this.phone,
    );
  }
}

enum ProfileFields {
  firstName,
  middleName,
  lastName,
  email,

  referralCode,
}

class ProfileInitial extends Profile {
  const ProfileInitial()
      : super(
          firstName: '',
          email: '',
          middleName: '',
          lastName: '',
          referralCode: '',
          userType: '',
          uid: '',
          phone: '',
        );
}
