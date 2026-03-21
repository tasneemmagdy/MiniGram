import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mini_gram/core/component/constant.dart';
import 'package:mini_gram/cubit/chat_cubit/cubit.dart';
import 'package:mini_gram/cubit/post_cubit/cubit.dart';
import 'package:mini_gram/cubit/user_cubit/cubit.dart';
import 'package:mini_gram/layout/app_layout_screen.dart';
import 'package:mini_gram/modules/register/register_screen.dart';
import 'package:mini_gram/modules/login/cubit/cubit.dart';
import 'package:mini_gram/modules/login/cubit/states.dart';
import 'package:mini_gram/services/shared/network/local/cashe_helper.dart';
import 'package:mini_gram/generated/l10n.dart'; 
import '../../core/component/components.dart';

class LoginScreen extends StatelessWidget {
  var formkey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future signInWithGoogle(BuildContext context) async {
    final s = S.of(context);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final newUId = userCredential.user!.uid;

      UserCubit.get(context).clearUserData();
      PostCubit.get(context).clearPosts();
      ChatCubit.get(context).clearChats();

      uId = newUId;
      await CasheHelper.saveData(key: 'uId', value: newUId);

      UserCubit.get(context).getUserData(uId: newUId);
      PostCubit.get(context).getPost();
      ChatCubit.get(context).getUsers();

      navigateAndFinish(context, MiniGramLayout());
    } catch (e) {
      print("Google sign in error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.googleError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MiniGramLoginCubit(),
      child: BlocConsumer<MiniGramLoginCubit, MiniGramLoginStates>(
        listener: (context, state) {
          final s = S.of(context);
          if (state is MiniGramLoginSuccessState) {
            final newUId = state.uId;

            UserCubit.get(context).clearUserData();
            PostCubit.get(context).clearPosts();
            ChatCubit.get(context).clearChats();

            uId = newUId;
            CasheHelper.saveData(key: 'uId', value: newUId).then((_) {
              UserCubit.get(context).getUserData(uId: newUId);
              PostCubit.get(context).getPost();
              ChatCubit.get(context).getUsers();

              navigateAndFinish(context, MiniGramLayout());
            });
          } else if (state is MiniGramLoginFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(s.loginError),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final s = S.of(context);
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.loginHeader,
  style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          s.loginSubHeader,
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: s.emailAddress,
                            hintText: s.emailHint,
                            prefixIcon: const Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return s.emailValidation;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: s.password,
                            hintText: s.passwordHint,
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () {
                                MiniGramLoginCubit.get(context)
                                    .changePasswordVisibility();
                              },
                              icon: Icon(MiniGramLoginCubit.get(context).suffix),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return s.passwordValidation;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          onFieldSubmitted: (value) {
                            if (formkey.currentState!.validate()) {
                              MiniGramLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          obscureText: MiniGramLoginCubit.get(context).isPassword,
                        ),
                        Align(
  alignment: Alignment.centerRight,
  child: TextButton(
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) {
          var emailController = TextEditingController();

          return AlertDialog(
            title: Text("Reset Password"),
            content: TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Enter your email",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(
                          email: emailController.text);

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Reset link sent to your email",
                      ),
                    ),
                  );
                },
                child: Text("Send"),
              )
            ],
          );
        },
      );
    },
    child: Text("Forgot Password?" ,
    style: TextStyle(
      color:Colors.black
    ),),
  ),
),
                        const SizedBox(height: 30.0),
                        ConditionalBuilder(
                          condition: state is! MiniGramLoginLoadingState,
                          builder: (context) => SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  MiniGramLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                              ),
                              child: Text(s.loginButton),
                            ),
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(height: 5),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 240, 93, 93),
                          ),
                          onPressed: () {
                            signInWithGoogle(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                s.loginWithGoogle,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(s.noAccount),
                            TextButton(
                              onPressed: () {
                                navigateTo(context, RegisterScreen());
                              },
                              child: Text(s.registerNow),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}