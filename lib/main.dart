import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mini_gram/core/component/theme.dart';
import 'package:mini_gram/cubit/app_cubit/cubit.dart';
import 'package:mini_gram/cubit/app_cubit/states.dart';
import 'package:mini_gram/cubit/chat_cubit/cubit.dart';
import 'package:mini_gram/cubit/message_cubit/cubit.dart';
import 'package:mini_gram/cubit/network_cubit/cubit.dart';
import 'package:mini_gram/cubit/notification_cubit/cubit.dart';
import 'package:mini_gram/cubit/post_cubit/cubit.dart';
import 'package:mini_gram/cubit/profile_cubit/cubit.dart';
import 'package:mini_gram/cubit/user_cubit/cubit.dart';
import 'package:mini_gram/generated/l10n.dart';
import 'package:mini_gram/layout/app_layout_screen.dart' hide lightTheme, darkTheme;
import 'package:mini_gram/modules/login/login_screen.dart';
import 'package:mini_gram/modules/no_internet/on_internet_screen.dart';
import 'core/component/constant.dart';
import 'services/shared/bloc_observer.dart';
import 'services/shared/network/local/cashe_helper.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('on background message');
  print(message.data.toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await flutterLocalNotificationsPlugin.initialize(
  const InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  ),
);

await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('on message: ${message.data}');
    final notification = message.notification;
    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('on message opened app: ${message.data}');
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  var token = await FirebaseMessaging.instance.getToken();
  print('FCM Token: $token');

  Bloc.observer = MyBlocObserver();
  await CasheHelper.init();

  bool isDark = CasheHelper.getData(key: 'isDark') ?? false;
  String? lang = CasheHelper.getData(key: 'lang');
  uId = CasheHelper.getData(key: 'uId');
  print(uId);

  if (uId != null && uId!.isNotEmpty && token != null) {
    await FirebaseFirestore.instance.collection('users').doc(uId).update({
      'fcmToken': token,
    });
    print('FCM token saved to Firestore');
  }

  Widget widget;
  if (uId != null && uId!.isNotEmpty) {
    widget = MiniGramLayout();
  } else {
    widget = LoginScreen();
  }

  runApp(MyApp(startWidget: widget, savedLang: lang, isDark: isDark));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  final String? savedLang;
  final bool? isDark;

  const MyApp({
    required this.startWidget,
    required this.savedLang,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit()..changeLanguage(savedLang ?? 'en'),
        ),
        BlocProvider(create: (context) => UserCubit()..getUserData(uId: uId)),
        BlocProvider(
          create: (context) => PostCubit(context.read<UserCubit>())..getPost(),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(context.read<UserCubit>()),
        ),
        BlocProvider(
          create: (context) => ChatCubit(UserCubit.get(context))..getUsers(),
        ),
        BlocProvider(create: (context) => MessageCubit(UserCubit.get(context))),
        BlocProvider(create: (context) => NetworkCubit()),
        BlocProvider(create: (context) => NotificationCubit()..getNotifications(uId ?? '')),
      ],
      child: BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) {
          return MaterialApp(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: AppCubit.get(context).isDark
                ? ThemeMode.dark
                : ThemeMode.light,
            locale: AppCubit.get(context).locale,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: BlocBuilder<NetworkCubit, bool>(
              builder: (context, isConnected) {
                return isConnected ? startWidget : const NoInternetScreen();
              },
            ),
          );
        },
      ),
    );
  }
}