class NotificationModel {
  String? notificationId;
  String? orderID;
  String? message;
  bool? isRead;

  NotificationModel(
      {this.notificationId,
        this.orderID,
        this.message,
        this.isRead});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['notificationId'];
    orderID = json['orderID'];
    message = json['message'].toString();
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notificationId'] = notificationId;
    data['orderID'] = orderID;
    data['message'] = message.toString();
    data['isRead'] = isRead;
    return data;
  }
}