class CategoryOrderFieldModel {
  int? id;
  String? name;
  String? type;
  int? isShow;
  int? required;
  int? categoryId;
  List<dynamic>? dropDownOptions;

  CategoryOrderFieldModel(
      {this.id,
        this.name,
        this.type,
        this.isShow,
        this.required,
        this.dropDownOptions,
        this.categoryId});

  CategoryOrderFieldModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'].toString();
    type = json['type'].toString();
    isShow = json['isShow'];
    required = json['required'];
    categoryId = json['categoryId'];
    dropDownOptions = json['dropDownOptions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type.toString();
    data['isShow'] = isShow;
    data['required'] = required;
    data['categoryId'] = categoryId;
    data['dropDownOptions'] = dropDownOptions;
    return data;
  }
}