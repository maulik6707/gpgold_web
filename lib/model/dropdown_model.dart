class DropdownModel {
  int? id;
  String? dropDownOptionName;
  int? categoryId;
  int? orderFieldId;
  int? generalFieldId;

  DropdownModel(
      {this.id,
        this.dropDownOptionName,
        this.categoryId,
        this.orderFieldId,
        this.generalFieldId});

  DropdownModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dropDownOptionName = json['dropDownOptionName'].toString();
    categoryId = json['categoryId'];
    orderFieldId = json['orderFieldId'];
    generalFieldId = json['generalFieldId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['dropDownOptionName'] = dropDownOptionName;
    data['categoryId'] = categoryId;
    data['orderFieldId'] = orderFieldId;
    data['generalFieldId'] = generalFieldId;
    return data;
  }
}