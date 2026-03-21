import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? email;
  String? phone;
  String? uId;
  bool? isEmailVerified;
  String? image;
  String? coverImage;
  String? bio;
  String? fcmToken;
  String? lastMessage;           
  Timestamp? lastMessageTime;    

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.uId,
    required this.isEmailVerified,
    required this.image,
    required this.coverImage,
    required this.bio,
    this.fcmToken,
    this.lastMessage,
    this.lastMessageTime,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    isEmailVerified = json['isEmailVerified'];
    image = json['image'];
    coverImage = json['coverImage'];
    bio = json['bio'];
    fcmToken = json['fcmToken'];
    lastMessage = json['lastMessage'];                      
    lastMessageTime = json['lastMessageTime'] as Timestamp?;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'isEmailVerified': isEmailVerified,
      'image': image,
      'coverImage': coverImage,
      'bio': bio,
      'fcmToken': fcmToken,
    };
  }
}