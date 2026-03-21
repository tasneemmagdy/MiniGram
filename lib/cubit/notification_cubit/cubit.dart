import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_gram/cubit/notification_cubit/states.dart';
import 'package:mini_gram/models/notification_model.dart';

class NotificationCubit extends Cubit<NotificationStates> {
  NotificationCubit() : super(NotificationInitialState());
  static NotificationCubit get(context) => BlocProvider.of(context);

  List<NotificationModel> notifications = [];
  int unreadCount = 0;

  void getNotifications(String uId) {
    emit(NotificationLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('notifications')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((snapshot) {
      notifications = snapshot.docs.map((doc) {
        final model = NotificationModel.fromJson(doc.data());
        model.id = doc.id;
        return model;
      }).toList();

      unreadCount = notifications.where((n) => n.isRead == false).length;
      emit(NotificationSuccessState());
    });
  }

  Future<void> markAllAsRead(String uId) async {
    final batch = FirebaseFirestore.instance.batch();

    for (var n in notifications) {
      if (n.isRead == false && n.id != null) {
        final ref = FirebaseFirestore.instance
            .collection('users')
            .doc(uId)
            .collection('notifications')
            .doc(n.id);
        batch.update(ref, {'isRead': true});
      }
    }

    await batch.commit();
    unreadCount = 0;
    emit(MarkAsReadState());
  }
}