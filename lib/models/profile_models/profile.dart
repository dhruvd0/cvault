import 'package:cvault/constants/user_types.dart';
import 'package:cvault/models/profile_models/customer.dart';
import 'package:cvault/models/profile_models/dealer.dart';
import 'package:equatable/equatable.dart';

/// Parent class for [Dealer] and [Customer] classes
abstract class Profile extends Equatable {
  ///
  final String firstName;

  ///
  final String middleName;

  ///
  final String lastName;

  ///
  final String email;

  /// Extended classes will have their own id params such as dealerId,customerId
  final String uid;

  /// Specifies which user type, see [UserTypes]
  ///
  /// [Dealer] object can have userType as "dealer" or "admin"
  final String userType;

  ///
  final String referalCode;

  /// Phone should always have the country code as a prefix-'+91'
  final String phone;

  ///
  const Profile({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.uid,
    required this.userType,
    required this.referalCode,
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
      referalCode,
      phone,
    ];
  }

  ///
  factory Profile.fromMap(Map<String, dynamic> map) {
    var userType = map['userType'];
    return userType == UserTypes.dealer || userType == UserTypes.admin
        ? Dealer.fromJson(userType, map)
        : Customer.fromJson(map);
  }

  ///
  Map<String, dynamic> toJson() {
    throw UnimplementedError('Use either Dealer or Customer .toJson');
  }
}

///
enum ProfileFields {
  ///
  firstName,

  ///
  middleName,

  ///
  lastName,

  ///
  email,

  ///
  phone,

  ///
  referalCode,
}

///
class ProfileInitial extends Profile {
  ///
  const ProfileInitial()
      : super(
          firstName: '',
          email: '',
          middleName: '',
          lastName: '',
          referalCode: '',
          userType: '',
          uid: '',
          phone: '',
        );
}
