// To parse this JSON data, do
//
//     final dealer = dealerFromJson(jsonString);

import 'package:cvault/constants/user_types.dart';
import 'package:cvault/models/profile_models/profile.dart';
import 'package:cvault/models/transaction.dart';

class Dealer extends Profile {
  Dealer({
    required this.dealerId,
    required this.active,
    required this.transactions,
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
          userType: UserTypes.dealer,
          firstName: firstName,
          uid: uid,
          phone: phone,
          lastName: lastName,
        );

  final String dealerId;

  final bool active;
  final List<Transaction> transactions;

  factory Dealer.fromJson(Map<String, dynamic> json) => Dealer(
        uid: json["dealerId"] ?? '',
        dealerId: json["dealerId"] ?? '',
        firstName: json["name"] ?? '',
        lastName: json['name'] ?? '',
        middleName: json['name'] ?? '',
        phone: json["phone"] ?? '',
        email: json["email"] ?? '',
        active: json["active"] ?? false,
        referralCode: '',
        transactions: json['transactions'] == null
            ? []
            : List<Transaction>.from(
                json["transactions"].map((x) => Transaction.fromJson(x)),
              ),
      );

  static Dealer mock() {
    return Dealer.fromJson({
      "_id": "6295d8859efa452712a145b8",
      "dealerId": "4321",
      "name": "Test dealer",
      "phone": "9876543210",
      "email": "test@gmail.com",
      "active": true,
      "transactions": [],
    });
  }

  Map<String, dynamic> toJson() => {
        "dealerId": dealerId,
        "name": firstName,
        "phone": phone,
        "email": email,
        "active": active,
      };

  Dealer copyWith({
    String? dealerId,
    bool? active,
    List<Transaction>? transactions,
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
      uid: uid ?? this.uid,
      referralCode: referralCode ?? this.referralCode,
      phone: phone ?? this.phone,
    );
  }
}
