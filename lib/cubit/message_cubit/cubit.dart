import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_gram/cubit/message_cubit/states.dart';
import 'package:mini_gram/cubit/user_cubit/cubit.dart';
import 'package:mini_gram/models/message_model.dart';
import 'package:mini_gram/services/notification_service.dart';

class MessageCubit extends Cubit<MessageStates> {
  final UserCubit userCubit;

  MessageCubit(this.userCubit) : super(MessageInitialState());
  static MessageCubit get(context) => BlocProvider.of(context);

  void sendMessage({
    required String receiverId,
    required String text,
    String? replyTo, 
  }) async {
    if (receiverId.isEmpty) return;

    final sender = userCubit.modell;
    if (sender == null) return;

    final senderId = sender.uId;
    final now = Timestamp.now();

    MessageModel messageModel = MessageModel(
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      dateTime: now.toDate().toIso8601String(),
      replyTo: replyTo, 
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .add(messageModel.toMap());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(senderId)
          .collection('messages')
          .add(messageModel.toMap());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('chats')
          .doc(receiverId)
          .set({
            'lastMessage': text,
            'lastMessageTime': now,
          }, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(senderId)
          .set({
            'lastMessage': text,
            'lastMessageTime': now,
          }, SetOptions(merge: true));

      emit(SendMessageSuccessState());

      final receiverDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .get();
      final receiverToken = receiverDoc.data()?['fcmToken'];

      if (receiverToken != null) {
        NotificationService.sendMessageNotification(
          token: receiverToken,
          senderName: sender.name ?? 'Someone',
          message: text,
          receiverUId: receiverId,
        );
      }
    } catch (error) {
      emit(SendMessageErrorState(error.toString()));
    }
  }

  List<MessageModel> messages = [];

  void getMessages({required String receiverId}) {
    final senderId = userCubit.modell!.uId;

    FirebaseFirestore.instance
        .collection('users')
        .doc(senderId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
          messages = [];
          for (var element in event.docs) {
            messages.add(MessageModel.fromJson(element.data()));
          }
          emit(GetMessageSuccessState());
        });
  }

  Future<void> deleteMessage({
    required String receiverId,
    required String messageText,
    required String dateTime,
  }) async {
    final senderId = userCubit.modell!.uId;

    try {
      final senderMessages = await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .where('text', isEqualTo: messageText)
          .where('dateTime', isEqualTo: dateTime)
          .get();

      for (var doc in senderMessages.docs) {
        await doc.reference.delete();
      }

      final receiverMessages = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(senderId)
          .collection('messages')
          .where('text', isEqualTo: messageText)
          .where('dateTime', isEqualTo: dateTime)
          .get();

      for (var doc in receiverMessages.docs) {
        await doc.reference.delete();
      }

      emit(DeleteMessageSuccessState());
    } catch (e) {
      emit(DeleteMessageErrorState(e.toString()));
    }
  }
}
