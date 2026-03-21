import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_gram/cubit/app_cubit/states.dart';
import 'package:mini_gram/cubit/chat_cubit/cubit.dart';
import 'package:mini_gram/modules/chats/chats_screen.dart';
import 'package:mini_gram/modules/feeds/feeds_screen.dart';
import 'package:mini_gram/modules/new_post/new_post_Screen.dart';
import 'package:mini_gram/modules/profile/profile_screen.dart';
import 'package:mini_gram/modules/liked_posts/liked_posts_screen.dart';
import 'package:mini_gram/services/shared/network/local/cashe_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostsScreen(),
    LikedPostsScreen(),
    ProfileScreen(),
  ];

  void changeBottomNavBar(int index) {
    if (index == 2) {
      emit(NewPostState());
    } else {
      currentIndex = index;
      emit(ChangeBottomNavState());
    }
  }

  List<String> titles = ['Home', 'Chats', 'Post', 'Likes', 'Profile'];

  Locale locale = const Locale('en');

  void changeLanguage(String langCode) {
    locale = Locale(langCode);

    CasheHelper.saveData(key: 'lang', value: langCode);

    emit(AppChangeLanguageState());
  }

  bool isDark = false;
  ThemeMode appMode = ThemeMode.dark;
  void changeAppMode(bool? fromShared) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(changeAppModeState());
    } else {
      isDark = !isDark;
      CasheHelper.saveData(key: 'isDark', value: isDark).then((value) {
        emit(changeAppModeState());
      });
    }
  }
}