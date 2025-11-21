class OrderModel {
  String? order_no;
  String? client_name;
  String? orderDate;
  String? deliveryDate;
  int? quantity;
  String? categoryId;
  int? dueIn;
  String? priority;
  String? category;
  String? status;
  String? remarks;
  int? karigarId;
  int? clientId;
  String? img1;
  String? img2;
  String? img3;
  String? img4;
  String? img5;
  OrderClientModel? client;
  OrderKarigarModel? karigar;
  List<OrderFieldModel>? extraGeneralFields;
  List<OrderFieldModel>? extraOrdersFields;

  OrderModel(
      {this.orderDate,
        this.order_no,
        this.client_name,
        this.deliveryDate,
        this.quantity,
        this.categoryId,
        this.category,
        this.dueIn,
        this.priority,
        this.client,
        this.karigar,
        this.status,
        this.remarks,
        this.karigarId,
        this.clientId,
        this.img1,
        this.img2,
        this.img3,
        this.img4,
        this.img5,
        this.extraGeneralFields,
        this.extraOrdersFields});

  OrderModel.fromJson(Map<String, dynamic> json) {
    order_no = json['order_no'];
    client_name = json['client_name'];
    orderDate = json['orderDate'];
    deliveryDate = json['deliveryDate'].toString();
    quantity = json['quantity'];
    categoryId = json['categoryId'].toString();
    dueIn = json['dueIn'];
    category = json['category'];
    priority = json['priority'].toString();
    client = json['client'] != null ? OrderClientModel.fromJson(json['client']) : null;
    karigar = json['karigar'] != null ? OrderKarigarModel.fromJson(json['karigar']) : null;
    status = json['status'].toString();
    remarks = json['remarks'].toString();
    karigarId = json['karigarId'];
    clientId = json['clientId'];
    img1 = json['img1'].toString();
    img2 = json['img2'].toString();
    img3 = json['img3'].toString();
    img4 = json['img4'].toString();
    img5 = json['img5'].toString();
    if (json['extraGeneralFields'] != null) {
      extraGeneralFields = <OrderFieldModel>[];
      json['extraGeneralFields'].forEach((v) {
        extraGeneralFields!.add(OrderFieldModel.fromJson(v));
      });
    }
    if (json['extraOrdersFields'] != null) {
      extraOrdersFields = <OrderFieldModel>[];
      json['extraOrdersFields'].forEach((v) {
        extraOrdersFields!.add(OrderFieldModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_no'] = order_no;
    data['client_name'] = client_name;
    data['orderDate'] = orderDate;
    data['deliveryDate'] = deliveryDate;
    data['quantity'] = quantity.toString();
    data['categoryId'] = categoryId;
    data['dueIn'] = dueIn;
    data['priority'] = priority;
    data['client'] = client;
    data['karigar'] = karigar;
    data['remarks'] = remarks;
    data['karigarId'] = karigarId;
    data['clientId'] = clientId;
    data['img1'] = img1;
    data['img2'] = img2;
    data['img3'] = img3;
    data['img4'] = img4;
    data['img5'] = img5;
    data['category'] = category;
    data['status'] = status;
    data['extraGeneralFields'] = extraGeneralFields;
    data['extraOrdersFields'] = extraOrdersFields;
    return data;
  }
}

class OrderFieldModel{
  String? name;
  String? value;

  OrderFieldModel({this.name, this.value});

  OrderFieldModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    value = json['value'];
  }
}

class OrderClientModel{
  int? id;
  String? full_name;
  String? company_name;
  String? email;
  String? phone;
  String? token;

  OrderClientModel({
    this.id,
    this.full_name,
    this.company_name,
    this.email,
    this.phone,
    this.token
  });

  OrderClientModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    full_name = json['full_name'];
    company_name = json['company_name'] ?? 'N/A';
    email = json['email'];
    phone = json['phone'];
    token = json['token'];
  }
}

class OrderKarigarModel{
  int? id;
  String? name;
  String? email;
  String? phone;
  String? city;

  OrderKarigarModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.city
  });

  OrderKarigarModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    city = json['city'];
  }
}