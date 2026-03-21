import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_gram/core/component/components.dart';
import 'package:mini_gram/core/component/constant.dart';
import 'package:mini_gram/cubit/post_cubit/cubit.dart';
import 'package:mini_gram/cubit/post_cubit/states.dart';
import 'package:mini_gram/cubit/user_cubit/cubit.dart';
import 'package:mini_gram/cubit/user_cubit/states.dart';
import 'package:mini_gram/models/post_model.dart';
import 'package:mini_gram/models/user_model.dart';
import 'package:mini_gram/modules/edit_post/edit_post_screen.dart';
import 'package:mini_gram/modules/edit_profile/edit_profile_screen.dart';
import 'package:mini_gram/modules/feeds/feeds_screen.dart';
import 'package:mini_gram/modules/new_post/new_post_Screen.dart';
import 'package:mini_gram/generated/l10n.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final s = S.of(context); 
        var userCubit = UserCubit.get(context);
        var postCubit = PostCubit.get(context);

        // Loading
        if (state is UserGetUserLoadingState || userCubit.modell == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error
        if (state is UserGetUserErrorState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  s.failedToLoadUser(state.error), 
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    userCubit.getUserData();
                  },
                  child: Text(s.retry),
                ),
              ],
            ),
          );
        }

        // Success
        UserModel userModel = userCubit.modell!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Profile Header
              SizedBox(
                height: 180,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              userModel.coverImage ??
                                  'https://via.placeholder.com/400x150',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 65.0,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundImage: NetworkImage(
                          userModel.image ?? 'https://via.placeholder.com/150',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                userModel.name ?? s.unknownUser,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                userModel.bio ?? s.defaultBio,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 20.0),

              // Stats
              Row(
                children: [
                  _buildStat(s.posts, postCubit.myPosts.length.toString()),
                ],
              ),
              const SizedBox(height: 15.0),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        navigateTo(context, NewPostsScreen());
                      },
                      child: Text(s.addPhotos),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      navigateTo(context, EditProfileScreen());
                    },
                    child: const Icon(Icons.edit),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),

              const SizedBox(height: 20.0),
              // My Posts Section
              Text(s.myPosts, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10.0),

              BlocBuilder<PostCubit, PostStates>(
                builder: (context, state) {
                  var myPosts = postCubit.myPosts;

                  if (myPosts.isEmpty) {
                    return Center(
                      child: Text(s.noPostsYet),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: myPosts.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return buildPostItem(context, myPosts[index], index);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Expanded _buildStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}