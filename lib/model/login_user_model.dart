class LoginUserModel {
  int? id;
  String? phoneNumber;
  String? email;
  String? fullName;
  String? companyName;
  String? country;
  String? state;
  String? city;
  String? role;
  int? isActive;

  LoginUserModel(
      {this.id,
        this.phoneNumber,
        this.email,
        this.fullName,
        this.companyName,
        this.country,
        this.state,
        this.city,
        this.role,
        this.isActive});

  LoginUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'].toString();
    email = json['email'].toString();
    fullName = json['full_name'].toString();
    companyName = json['company_name'].toString();
    country = json['country'].toString();
    state = json['state'].toString();
    city = json['city'].toString();
    role = json['role'].toString();
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email.toString();
    data['full_name'] = fullName;
    data['company_name'] = companyName;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['role'] = role;
    data['isActive'] = isActive;
    return data;
  }
}