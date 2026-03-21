import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_gram/modules/login/cubit/states.dart';


class MiniGramLoginCubit extends Cubit<MiniGramLoginStates>
{
  MiniGramLoginCubit() : super(MiniGramLoginInitialStates());

  static MiniGramLoginCubit get(context) => BlocProvider.of(context);



  void userLogin ({
    required String email,
    required String password,
  })
  {
    emit(MiniGramLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((value){
      print(value.user!.email);
      print(value.user!.uid);
      emit(MiniGramLoginSuccessState(value.user!.uid));
    }).catchError((error){
      emit(MiniGramLoginFailedState(error.toString()));
    });
  }


  IconData suffix = Icons.visibility_off ;
  bool isPassword = true;

  void changePasswordVisibility (){
    isPassword = !isPassword;
    suffix =isPassword? Icons.visibility_off: Icons.visibility;
    emit(changePasswordIcon());
  }

  Future<void> resetPassword({
  required String email,
}) async {
  await FirebaseAuth.instance.sendPasswordResetEmail(
    email: email,
  );
}

}