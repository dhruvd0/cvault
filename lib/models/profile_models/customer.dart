import 'package:cvault/constants/user_types.dart';
import 'package:cvault/models/profile_models/profile.dart';

/// Customer Model
class Customer extends Profile {
  ///
  final String customerId;

  ///
  const Customer({
    required this.customerId,
    required String firstName,
    required String middleName,
    required String lastName,
    required String email,
    required String uid,
    required String referalCode,
    required String phone,
  }) : super(
          middleName: middleName,
          referalCode: referalCode,
          email: email,
          userType: UserTypes.customer,
          firstName: firstName,
          uid: uid,
          phone: phone,
          lastName: lastName,
        );

  ///
  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        uid: json['customerId'] ?? '',
        customerId: json["customerId"] ?? '',
        firstName: json["firstName"] ?? '',
        middleName: json["middleName"] ?? '',
        lastName: json["lastName"] ?? '',
        email: json["email"] ?? '',
        referalCode: '',
        phone: json["phone"] ?? '',
      );

  @override
  Map<String, dynamic> toJson() => {
        "customerId": customerId,
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "phone": phone,
        "email": email,
      };

  ///
  Customer copyWith({
    String? customerId,
    String? firstName,
    String? middleName,
    String? lastName,
    String? email,
    String? uid,
    String? userType,
    String? referalCode,
    String? phone,
  }) {
    return Customer(
      customerId: customerId ?? this.customerId,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      referalCode: referalCode ?? this.referalCode,
      phone: phone ?? this.phone,
    );
  }

  ///
  static Customer mock() {
    return Customer.fromJson(const {
      "_id": "6295d8859efa452712a145b8",
      "customerId": "4321",
      "name": "Test dealer",
      "phone": "9876543210",
      "email": "test@gmail.com",
      "active": true,
      "transactions": [],
    });
  }
}
