class nonAcceptdealer {
  String? sId;
  String? uID;
  String? firstName;
  String? middleName;
  String? lastName;
  String? phone;
  String? email;
  bool? status;
  String? userType;
  String? token;
  String? referalCode;
  List<String>? transactions;
  int? iV;
  bool? active;
  double? margin;
  List<String>? notifications;
  bool? dealerAcceptance;

  nonAcceptdealer(
      {this.sId,
      this.uID,
      this.firstName,
      this.middleName,
      this.lastName,
      this.phone,
      this.email,
      this.status,
      this.userType,
      this.token,
      this.referalCode,
      this.transactions,
      this.iV,
      this.active,
      this.margin,
      this.notifications,
      this.dealerAcceptance});

  nonAcceptdealer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    uID = json['UID'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    phone = json['phone'];
    email = json['email'];
    status = json['status'];
    userType = json['userType'];
    token = json['token'];
    referalCode = json['referalCode'];
    transactions = json['transactions'].cast<String>();
    iV = json['__v'];
    active = json['active'];
    margin = json['margin'].toDouble() ?? "";
    notifications = json['notifications'].cast<String>();
    dealerAcceptance = json['dealerAcceptance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['UID'] = this.uID;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['status'] = this.status;
    data['userType'] = this.userType;
    data['token'] = this.token;
    data['referalCode'] = this.referalCode;
    data['transactions'] = this.transactions;
    data['__v'] = this.iV;
    data['active'] = this.active;
    data['margin'] = this.margin;
    data['notifications'] = this.notifications;
    data['dealerAcceptance'] = this.dealerAcceptance;
    return data;
  }
}
