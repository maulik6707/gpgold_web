class ClientModel {
  int? id;
  String? phoneNumber;
  String? email;
  String? full_name;
  String? company_name;
  String? country;
  String? state;
  String? city;
  String? role;
  String? isActive;
  String? pincode;
  String? dob;
  String? anniversarydate;
  String? remark;
  String? gst;
  String? address;

  ClientModel(
      {this.id,
        this.phoneNumber,
        this.email,
        this.full_name,
        this.company_name,
        this.country,
        this.state,
        this.city,
        this.role,
        this.isActive,
        this.pincode,
        this.dob,
        this.anniversarydate,
        this.remark,
        this.gst,
        this.address});

  ClientModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'].toString();
    email = json['email'].toString();
    full_name = json['full_name'].toString();
    company_name = json['company_name'].toString();
    country = json['country'].toString();
    state = json['state'].toString();
    city = json['city'].toString();
    role = json['role'].toString();
    isActive = json['isActive'];
    pincode = json['pincode'].toString();
    dob = json['dob'].toString();
    anniversarydate = json['anniversarydate'].toString();
    remark = json['remark'].toString();
    gst = json['gst'].toString();
    address = json['address'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email.toString();
    data['full_name'] = full_name;
    data['company_name'] = company_name;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['role'] = role;
    data['isActive'] = isActive;
    data['pincode'] = pincode;
    data['dob'] = dob;
    data['anniversarydate'] = anniversarydate;
    data['remark'] = remark;
    data['gst'] = gst;
    data['address'] = address;
    return data;
  }
}