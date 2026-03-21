import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_gram/core/component/components.dart';
import 'package:mini_gram/cubit/post_cubit/cubit.dart';
import 'package:mini_gram/cubit/user_cubit/cubit.dart';
import 'package:mini_gram/modules/login/login_screen.dart';
import 'package:mini_gram/services/shared/network/local/cashe_helper.dart';

String? uId;

Future<void> signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    await CasheHelper.removeData(key: 'uId');

    uId = null;

    UserCubit.get(context).clearUserData();
    PostCubit.get(context).clearPosts();

    navigateAndFinish(context, LoginScreen());
  } catch (e) {
    print("error happened: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("حدث خطأ أثناء تسجيل الخروج")),
    );
  }
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}