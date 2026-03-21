import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_gram/cubit/post_cubit/cubit.dart';
import 'package:mini_gram/cubit/post_cubit/states.dart';
import 'package:mini_gram/models/post_model.dart';
import 'package:mini_gram/modules/feeds/feeds_screen.dart';
import 'package:mini_gram/generated/l10n.dart'; 

class LikedPostsScreen extends StatelessWidget {
  const LikedPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context); 

    return BlocConsumer<PostCubit, PostStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var postCubit = PostCubit.get(context);

        List<postModel> likedPosts = postCubit.posts
            .where((post) => postCubit.userLikes[post.postId] == true)
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(s.likedPosts), 
            centerTitle: true,
          ),
          body: likedPosts.isEmpty
              ? Center(
                  child: Text(s.noLikedPosts), 
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(8.0),
                  itemCount: likedPosts.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) =>
                      buildPostItem(context, likedPosts[index], index),
                ),
        );
      },
    );
  }
}