class CategoryModel {
  int? id;
  String? name;
  String? remark;

  CategoryModel(
      {this.id,
        this.name,
        this.remark});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'].toString();
    remark = json['remark'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['remark'] = remark.toString();
    return data;
  }
}