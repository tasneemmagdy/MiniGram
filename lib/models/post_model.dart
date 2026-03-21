import 'package:cloud_firestore/cloud_firestore.dart';

class postModel {
  String? postId;
  String? name;
  String? uId;
  String? image;
  Timestamp? dateTime; 
  String? text;
  String? postImage;
  int? likesCount;
  String? ownerToken;

  postModel({
    this.postId,
    this.name,
    this.uId,
    this.image,
    this.dateTime,
    this.text,
    this.postImage,
    this.likesCount = 0,
    this.ownerToken,
  });

  postModel.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    name = json['name'];
    uId = json['uId'];
    image = json['image'];

    var dt = json['dateTime'];
    if (dt is Timestamp) {
      dateTime = dt;
    } else if (dt is String) {
      try {
        dateTime = Timestamp.fromDate(DateTime.parse(dt));
      } catch (e) {
        dateTime = Timestamp.now();
      }
    } else {
      dateTime = Timestamp.now();
    }

    text = json['text'];
    postImage = json['postImage'];
    likesCount = json['likesCount'] ?? 0;
    ownerToken = json['ownerToken'];
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'name': name,
      'uId': uId,
      'image': image,
      'dateTime': dateTime ?? Timestamp.now(), // Timestamp
      'text': text,
      'postImage': postImage,
      'likesCount': likesCount,
      'ownerToken':ownerToken,
    };
  }
}
