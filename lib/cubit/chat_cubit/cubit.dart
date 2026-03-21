import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_gram/cubit/chat_cubit/states.dart';
import 'package:mini_gram/cubit/user_cubit/cubit.dart';
import 'package:mini_gram/models/user_model.dart';

class ChatCubit extends Cubit<ChatStates> {
    final UserCubit userCubit;   

  ChatCubit(this.userCubit) : super(ChatInitialState());
  static ChatCubit get(context) => BlocProvider.of(context);

  List<UserModel> users = [];

 getUsers() {
  emit(GetAllUsersLoadingState());
  users = [];

  FirebaseFirestore.instance
      .collection('users')
      .get()
      .then((value) async {
    for (var element in value.docs) {
      if (element.data()['uId'] != userCubit.modell?.uId) {
        
        final chatDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCubit.modell?.uId)
            .collection('chats')
            .doc(element.data()['uId'])
            .get();

        final lastMessage = chatDoc.data()?['lastMessage'] as String?;
        final lastMessageTime = chatDoc.data()?['lastMessageTime'] as Timestamp?;

        users.add(UserModel.fromJson({
          ...element.data(),
          'lastMessage': lastMessage,
          'lastMessageTime': lastMessageTime,
        }));
      }
    }
    emit(GetAllUsersSuccessState());
  }).catchError((error) {
    emit(GetAllUsersFailedState(error.toString()));
  });
}

void clearChats() {
    users.clear();
    emit(ChatInitialState());
  }
}
