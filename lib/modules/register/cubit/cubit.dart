import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_gram/models/user_model.dart';
import 'package:mini_gram/modules/register/cubit/states.dart';
import 'package:mini_gram/services/shared/network/local/cashe_helper.dart';


class MiniGramRegisterCubit extends Cubit<MiniGramRegisterStates>
{
  MiniGramRegisterCubit() : super(MiniGramRegisterInitialStates());

  static MiniGramRegisterCubit get(context) => BlocProvider.of(context);




 void userRegister ({
  required String name,
  required String email,
  required String password,
  required String phone
}) {
  emit(MiniGramRegisterLoadingState());

  FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: email,
  password: password
).then((value) {
  String uId = value.user!.uid;  
  print("Auth success: ${value.user!.email} - $uId");

  CasheHelper.saveData(key: 'uId', value: uId);

  userCreate(
    name: name,
    email: email,
    phone: phone,
    uId: uId
  );
}).catchError((error){
  emit(MiniGramRegisterFailedState(error.toString()));
});
}

void userCreate({
  required String name,
  required String email,
  required String phone,
  required String uId,
}) {
  UserModel model = UserModel(
    name: name,
    email: email,
    phone: phone,
    uId: uId,
    isEmailVerified: false,
    image: 'https://img.freepik.com/free-vector/city-people-outdoor_24908-55059.jpg',
    coverImage: 'https://img.freepik.com/free-vector/city-people-outdoor_24908-55059.jpg',
    bio: 'Write your bio...'
  );

  FirebaseFirestore.instance
  .collection('users')
  .doc(uId)
  .set(model.toMap())
  .then((value){
    emit(MiniGramCreateUserSuccessState());
    emit(MiniGramRegisterSuccessState());

  
  }).catchError((error){
    emit(MiniGramCreateUserFailedState(error.toString()));
  });
}

  IconData suffix = Icons.visibility_off ;
  bool isPassword = true;

  void changePasswordVisibility (){
    isPassword = !isPassword;
    suffix =isPassword? Icons.visibility_off: Icons.visibility;
    emit(ChangePasswordIcon());
  }

}