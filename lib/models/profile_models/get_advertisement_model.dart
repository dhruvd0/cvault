class AdModel {
  String? sId;
  String? imageLink;
  String? redirectLink;
  String? createdAt;
  String? updatedAt;
  int? iV;

  AdModel(
      {this.sId,
      required this.imageLink,
      this.redirectLink,
      this.createdAt,
      this.updatedAt,
      this.iV});

  AdModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    imageLink = json['imageLink'];
    redirectLink = json['redirectLink'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['imageLink'] = this.imageLink;
    data['redirectLink'] = this.redirectLink;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
