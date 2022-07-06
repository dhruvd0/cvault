class AdModel {
  String? sId;
  String? imageLink;
  String? redirectLink;
  String? createdAt;
  String? updatedAt;
  int? iV;

  AdModel({
    this.sId,
    required this.imageLink,
    this.redirectLink,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  AdModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    imageLink = json['imageLink'];
    redirectLink = json['redirectLink'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['imageLink'] = imageLink;
    data['redirectLink'] = redirectLink;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
