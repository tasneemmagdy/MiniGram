import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:mini_gram/cubit/post_cubit/cubit.dart';
import 'package:mini_gram/cubit/post_cubit/states.dart';
import 'package:mini_gram/cubit/user_cubit/cubit.dart';
import 'package:mini_gram/generated/l10n.dart'; 

class NewPostsScreen extends StatelessWidget {
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final s = S.of(context);
        var userModel = UserCubit.get(context).modell;

        if (userModel == null) {
          return Scaffold(
            appBar: AppBar(
              elevation: 15,
              title: Text(s.addPost), 
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            elevation: 10,
            title: Text(s.addPost), 
            actions: [
              TextButton(
                onPressed: () {
                  final now = Timestamp.now();
                  if (PostCubit.get(context).postImage == null) {
                    PostCubit.get(context)
                        .createPost(dateTime: now, text: textController.text);
                  } else {
                    PostCubit.get(context).uploadPostImage(
                        dateTime: now, text: textController.text);
                  }
                },
                child: Text(s.post),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (state is CreatePostLoadingState)
                    const LinearProgressIndicator(),
                  if (state is CreatePostLoadingState)
                    const SizedBox(height: 10.0),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage(
                          userModel.image ?? 'https://via.placeholder.com/150',
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: Text(userModel.name ?? 'User',
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: s.whatIsOnYourMind(userModel.name ?? 'User'),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (PostCubit.get(context).postImage != null)
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(
                              image:
                                  FileImage(PostCubit.get(context).postImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            PostCubit.get(context).removePostImage();
                          },
                          icon: const CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.white24,
                            child: Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            PostCubit.get(context).pickPostImage();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(IconlyLight.image),
                              const SizedBox(width: 5),
                              Text(s.addPhoto), 
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}