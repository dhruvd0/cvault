class NewNotification {
  List<Docs>? docs;
  int? totalDocs;
  int? limit;
  int? totalPages;
  int? page;
  int? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  Null? prevPage;
  Null? nextPage;

  NewNotification(
      {this.docs,
      this.totalDocs,
      this.limit,
      this.totalPages,
      this.page,
      this.pagingCounter,
      this.hasPrevPage,
      this.hasNextPage,
      this.prevPage,
      this.nextPage});

  NewNotification.fromJson(Map<String, dynamic> json) {
    if (json['docs'] != null) {
      docs = <Docs>[];
      json['docs'].forEach((v) {
        docs!.add(new Docs.fromJson(v));
      });
    }
    totalDocs = json['totalDocs'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    page = json['page'];
    pagingCounter = json['pagingCounter'];
    hasPrevPage = json['hasPrevPage'];
    hasNextPage = json['hasNextPage'];
    prevPage = json['prevPage'];
    nextPage = json['nextPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.docs != null) {
      data['docs'] = this.docs!.map((v) => v.toJson()).toList();
    }
    data['totalDocs'] = this.totalDocs;
    data['limit'] = this.limit;
    data['totalPages'] = this.totalPages;
    data['page'] = this.page;
    data['pagingCounter'] = this.pagingCounter;
    data['hasPrevPage'] = this.hasPrevPage;
    data['hasNextPage'] = this.hasNextPage;
    data['prevPage'] = this.prevPage;
    data['nextPage'] = this.nextPage;
    return data;
  }
}

class Docs {
  String? sId;
  String? notifiedTo;
  String? transactionId;
  String? firstName;
  String? lastName;
  int? phone;
  String? email;
  String? transactiontype;
  String? cryptoType;
  int? price;
  int? quantity;
  String? status;
  int? margin;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Docs(
      {this.sId,
      this.notifiedTo,
      this.transactionId,
      this.firstName,
      this.lastName,
      this.phone,
      this.email,
      this.transactiontype,
      this.cryptoType,
      this.price,
      this.quantity,
      this.status,
      this.margin,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Docs.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    notifiedTo = json['notifiedTo'];
    transactionId = json['transactionId'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    phone = json['Phone'];
    email = json['Email'];
    transactiontype = json['Transactiontype'];
    cryptoType = json['cryptoType'];
    price = json['Price'];
    quantity = json['Quantity'];
    status = json['Status'];
    margin = json['Margin'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['notifiedTo'] = this.notifiedTo;
    data['transactionId'] = this.transactionId;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['Phone'] = this.phone;
    data['Email'] = this.email;
    data['Transactiontype'] = this.transactiontype;
    data['cryptoType'] = this.cryptoType;
    data['Price'] = this.price;
    data['Quantity'] = this.quantity;
    data['Status'] = this.status;
    data['Margin'] = this.margin;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
