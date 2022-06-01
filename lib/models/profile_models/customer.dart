import 'package:cvault/constants/user_types.dart';
import 'package:cvault/models/profile_models/profile.dart';

class Customer extends Profile {
  final String customerId;
  Customer({
    required this.customerId,
    required String firstName,
    required String middleName,
    required String lastName,
    required String email,
    required String uid,
    required String referralCode,
    required String phone,
  }) : super(
          middleName: middleName,
          referralCode: referralCode,
          email: email,
          userType: UserTypes.customer,
          firstName: firstName,
          uid: uid,
          phone: phone,
          lastName: lastName,
        );

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        uid: json['customerId'],
        customerId: json["customerId"],
        firstName: json["firstName"],
        middleName: json["middleName"],
        lastName: json["lastName"],
        email: json["email"],
        referralCode: '',
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "customerId": customerId,
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
      };
}
