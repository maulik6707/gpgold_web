class GeneralOrderFieldModel {
  int? id;
  String? name;
  String? type;
  int? isShow;
  int? required;
  List<dynamic>? dropDownOptions;

  GeneralOrderFieldModel(
      {this.id,
        this.name,
        this.type,
        this.isShow,
        this.required,
        this.dropDownOptions});

  GeneralOrderFieldModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'].toString();
    type = json['type'].toString();
    isShow = json['isShow'];
    required = json['required'];
    dropDownOptions = json['dropDownOptions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type.toString();
    data['isShow'] = isShow;
    data['required'] = required;
    data['dropDownOptions'] = dropDownOptions;
    return data;
  }
}