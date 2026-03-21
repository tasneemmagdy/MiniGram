import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_gram/core/component/components.dart';
import 'package:mini_gram/cubit/app_cubit/cubit.dart';
import 'package:mini_gram/cubit/app_cubit/states.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:mini_gram/cubit/chat_cubit/cubit.dart';
import 'package:mini_gram/cubit/user_cubit/cubit.dart';
import 'package:mini_gram/generated/l10n.dart'; 
import 'package:mini_gram/modules/chats/chats_screen.dart';
import 'package:mini_gram/modules/new_post/new_post_Screen.dart';
import 'package:mini_gram/modules/notification/notification_screen.dart';
import 'package:mini_gram/modules/search/search_screen.dart';

class MiniGramLayout extends StatelessWidget {
  const MiniGramLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is NewPostState) {
          navigateTo(context, NewPostsScreen());
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        var s = S.of(context); 

        List<String> titles = [
          s.home,
          s.chat,
          s.addPost,
          s.likes,
          s.profile,
        ];

        return Scaffold(
          appBar: AppBar(
            elevation: 12.0,
            title: Text(titles[cubit.currentIndex]),
            actions: [
              IconButton(
                onPressed: () {
                  navigateTo(context, NotificationScreen());
                },
                icon: const Icon(Icons.notifications_outlined),
                tooltip: s.notifications,
              ),
              IconButton(
                onPressed: () {
                  navigateTo(context, SearchScreen());
                },
                icon: const Icon(Icons.search),
                tooltip: s.search,
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (cubit.currentIndex == 1) {
                return BlocProvider(
                  create: (context) =>
                      ChatCubit(UserCubit.get(context))..getUsers(),
                  child: const ChatsScreen(),
                );
              }
              return cubit.screens[cubit.currentIndex];
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              cubit.changeBottomNavBar(index);
            },
            currentIndex: cubit.currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(IconlyLight.home, size: 24),
                label: s.home,
              ),
              BottomNavigationBarItem(
                icon: const Icon(IconlyLight.chat),
                label: s.chat,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.add_box_outlined),
                label: s.addPost,
              ),
              BottomNavigationBarItem(
                icon: const Icon(IconlyLight.heart),
                label: s.likes,
              ),
              BottomNavigationBarItem(
                icon: const Icon(IconlyLight.profile),
                label: s.profile,
              ),
            ],
          ),
        );
      },
    );
  }
}