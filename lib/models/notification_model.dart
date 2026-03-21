import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? id;
  String? title;
  String? body;
  String? type; // like, comment, message
  bool? isRead;
  Timestamp? dateTime;
  String? senderImage;

  NotificationModel({
    this.id,
    this.title,
    this.body,
    this.type,
    this.isRead,
    this.dateTime,
    this.senderImage,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    type = json['type'];
    isRead = json['isRead'] ?? false;
    dateTime = json['dateTime'];
    senderImage = json['senderImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'isRead': isRead ?? false,
      'dateTime': dateTime,
      'senderImage':senderImage,
    };
  }
}
