// To parse this JSON data, do
//
//     final dealer = dealerFromJson(jsonString);

import 'package:cvault/models/profile_models/profile.dart';
import 'package:cvault/models/transaction/transaction.dart';

///
class Dealer extends Profile {
  ///
  Dealer({
    required this.dealerId,
    // required this.active,
    required List<Transaction> transactions,
    required String userType,
    required String firstName,
    required String middleName,
    required String lastName,
    required String email,
    required String uid,
    required String referalCode,
    required String phone,
    required bool active,
  }) : super(
          middleName: middleName,
          referalCode: referalCode,
          email: email,
          userType: userType,
          firstName: firstName,
          uid: uid,
          phone: phone,
          lastName: lastName,
          active: active,
          transactions: transactions,
        );

  ///
  final String dealerId;

  ///
  // final bool active;

  ///
  factory Dealer.fromJson(String userType, Map<String, dynamic> json) {
    return Dealer(
      uid: json["UID"] ?? '',
      dealerId: json["UID"] ?? '',
      firstName: json["firstName"] ?? '',
      lastName: json['lastName'] ?? '',
      middleName: json['middleName'] ?? '',
      userType: userType,
      phone: json["phone"] ?? '',
      email: json["email"] ?? '',
      active: json["active"] ?? true,
      referalCode: json['referalCode'] ?? '',
      transactions: json['transactions'] == null
          ? []
          : List<Transaction>.from(
              json["transactions"].map(
                (x) => Transaction.fromJson(
                  x is Map<String, dynamic> ? x : {"_id": x},
                ),
              ),
            ),
    );
  }

  ///
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
        'referalCode': referalCode,
      };

  ///
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
    String? referalCode,
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
      referalCode: referalCode ?? this.referalCode,
      phone: phone ?? this.phone,
    );
  }
}
