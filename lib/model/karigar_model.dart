class KarigarModel {
  int? id;
  String? name;
  String? phoneNumber;
  String? city;

  KarigarModel(
      {this.id,
        this.name,
        this.phoneNumber,
        this.city});

  KarigarModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'].toString();
    phoneNumber = json['phoneNumber'].toString();
    city = json['city'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['city'] = city.toString();
    return data;
  }
}