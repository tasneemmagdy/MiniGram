// services/notification_service.dart
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static const String _serverKey = 'YOUR_SERVER_KEY_HERE';

  static Future<void> sendNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$_serverKey',
        },
        body: jsonEncode({
          'to': token,
          'notification': {'title': title, 'body': body, 'sound': 'default'},
          'android': {
            'priority': 'high',
            'notification': {
              'sound': 'default',
              'channel_id': 'high_importance_channel',
            },
          },
          'data': {'click_action': 'FLUTTER_NOTIFICATION_CLICK'},
        }),
      );
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  
  static Future<void> saveNotificationToFirestore({
    required String receiverUId,
    required String title,
    required String body,
    required String type,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverUId)
        .collection('notifications')
        .add({
      'title': title,
      'body': body,
      'type': type,
      'isRead': false,
      'dateTime': Timestamp.now(),
    });
  }

  static Future<void> sendLikeNotification({
    required String token,
    required String likedByName,
    required String receiverUId, 
  }) async {
    const title = '❤️ New Like';
    final body = '$likedByName liked your post!';
    await sendNotification(token: token, title: title, body: body);
    await saveNotificationToFirestore(
      receiverUId: receiverUId,
      title: title,
      body: body,
      type: 'like',
    );
  }

  static Future<void> sendCommentNotification({
    required String token,
    required String commenterName,
    required String receiverUId,
  }) async {
    const title = '💬 New Comment';
    final body = '$commenterName commented on your post!';
    await sendNotification(token: token, title: title, body: body);
    await saveNotificationToFirestore(
      receiverUId: receiverUId,
      title: title,
      body: body,
      type: 'comment',
    );
  }

  static Future<void> sendMessageNotification({
    required String token,
    required String senderName,
    required String message,
    required String receiverUId,
  }) async {
    await sendNotification(token: token, title: senderName, body: message);
    await saveNotificationToFirestore(
      receiverUId: receiverUId,
      title: senderName,
      body: message,
      type: 'message',
    );
  }
}