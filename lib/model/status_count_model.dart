class StatusCountModel {
  int? count;
  String? status;

  StatusCountModel(
      {this.count,
        this.status});

  StatusCountModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    status = json['status'] ?? 'N/A';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['status'] = status;
    return data;
  }
}