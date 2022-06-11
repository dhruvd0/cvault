// To parse this JSON data, do
//
//     final dealer = dealerFromJson(jsonString);

import 'package:cvault/models/profile_models/profile.dart';

class Dealer extends Profile {
  const Dealer({
    required this.dealerId,
    required this.active,
    required this.transactions,
    required String userType,
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
          userType: userType,
          firstName: firstName,
          uid: uid,
          phone: phone,
          lastName: lastName,
        );

  final String dealerId;

  final bool active;
  final List<String> transactions;

  factory Dealer.fromJson(String userType, Map<String, dynamic> json) => Dealer(
        uid: json["dealerId"] ?? '',
        dealerId: json["dealerId"] ?? '',
        firstName: json["firstName"] ?? '',
        lastName: json['lastName'] ?? '',
        middleName: json['middleName'] ?? '',
        userType: userType,
        phone: json["phone"] ?? '',
        email: json["email"] ?? '',
        active: json["active"] ?? false,
        referralCode: '',
        transactions: json['transactions'] == null
            ? []
            : List<String>.from(
                json["transactions"].map((x) => x.toString()),
              ),
      );

  static Dealer mock() {
    return Dealer.fromJson('dealer', const {
      "_id": "6295d8859efa452712a145b8",
      "dealerId": "4321",
      "name": "Test dealer",
      "phone": "9876543210",
      "email": "test@gmail.com",
      "active": true,
      "transactions": [],
    });
  }

  @override
  Map<String, dynamic> toJson() => {
        "dealerId": dealerId,
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "phone": phone,
        "email": email,
        'referralCode': referralCode,
      };

  Dealer copyWith({
    String? dealerId,
    bool? active,
    List<String>? transactions,
    String? firstName,
    String? middleName,
    String? lastName,
    String? email,
    String? uid,
    String? userType,
    String? referralCode,
    String? phone,
  }) {
    return Dealer(
      dealerId: dealerId ?? this.dealerId,
      active: active ?? this.active,
      transactions: transactions ?? this.transactions,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      uid: uid ?? this.uid,
      referralCode: referralCode ?? this.referralCode,
      phone: phone ?? this.phone,
    );
  }
}
