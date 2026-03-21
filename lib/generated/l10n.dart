// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Chat`
  String get chat {
    return Intl.message('Chat', name: 'chat', desc: '', args: []);
  }

  /// `Add Post`
  String get addPost {
    return Intl.message('Add Post', name: 'addPost', desc: '', args: []);
  }

  /// `likes`
  String get likes {
    return Intl.message('likes', name: 'likes', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `No chats yet`
  String get noChats {
    return Intl.message('No chats yet', name: 'noChats', desc: '', args: []);
  }

  /// `Tap to start chatting`
  String get startChatting {
    return Intl.message(
      'Tap to start chatting',
      name: 'startChatting',
      desc: '',
      args: [],
    );
  }

  /// `now`
  String get now {
    return Intl.message('now', name: 'now', desc: '', args: []);
  }

  /// `m`
  String get minutesLetter {
    return Intl.message('m', name: 'minutesLetter', desc: '', args: []);
  }

  /// `h`
  String get hoursLetter {
    return Intl.message('h', name: 'hoursLetter', desc: '', args: []);
  }

  /// `d`
  String get daysLetter {
    return Intl.message('d', name: 'daysLetter', desc: '', args: []);
  }

  /// `MiniGram User`
  String get defaultUserName {
    return Intl.message(
      'MiniGram User',
      name: 'defaultUserName',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message('Copy', name: 'copy', desc: '', args: []);
  }

  /// `Reply`
  String get reply {
    return Intl.message('Reply', name: 'reply', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Message copied`
  String get messageCopied {
    return Intl.message(
      'Message copied',
      name: 'messageCopied',
      desc: '',
      args: [],
    );
  }

  /// `Active now`
  String get activeNow {
    return Intl.message('Active now', name: 'activeNow', desc: '', args: []);
  }

  /// `Replying to`
  String get replyingTo {
    return Intl.message('Replying to', name: 'replyingTo', desc: '', args: []);
  }

  /// `Message...`
  String get typeMessage {
    return Intl.message('Message...', name: 'typeMessage', desc: '', args: []);
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message('Yesterday', name: 'yesterday', desc: '', args: []);
  }

  /// `No messages yet\nSay hi! 👋`
  String get noMessages {
    return Intl.message(
      'No messages yet\nSay hi! 👋',
      name: 'noMessages',
      desc: '',
      args: [],
    );
  }

  /// `Edit Post`
  String get editPost {
    return Intl.message('Edit Post', name: 'editPost', desc: '', args: []);
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `Edit your post...`
  String get editPostHint {
    return Intl.message(
      'Edit your post...',
      name: 'editPostHint',
      desc: '',
      args: [],
    );
  }

  /// `Post updated successfully`
  String get postUpdatedSuccess {
    return Intl.message(
      'Post updated successfully',
      name: 'postUpdatedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message('Dark', name: 'dark', desc: '', args: []);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Bio`
  String get bio {
    return Intl.message('Bio', name: 'bio', desc: '', args: []);
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `Update Profile`
  String get updateProfile {
    return Intl.message(
      'Update Profile',
      name: 'updateProfile',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Please enter`
  String get pleaseEnter {
    return Intl.message(
      'Please enter',
      name: 'pleaseEnter',
      desc: '',
      args: [],
    );
  }

  /// `Delete Post`
  String get deletePost {
    return Intl.message('Delete Post', name: 'deletePost', desc: '', args: []);
  }

  /// `Report Post`
  String get reportPost {
    return Intl.message('Report Post', name: 'reportPost', desc: '', args: []);
  }

  /// `Copy Text`
  String get copyText {
    return Intl.message('Copy Text', name: 'copyText', desc: '', args: []);
  }

  /// `Post reported`
  String get postReported {
    return Intl.message(
      'Post reported',
      name: 'postReported',
      desc: '',
      args: [],
    );
  }

  /// `Post copied to clipboard`
  String get postCopied {
    return Intl.message(
      'Post copied to clipboard',
      name: 'postCopied',
      desc: '',
      args: [],
    );
  }

  /// `View comments`
  String get viewComments {
    return Intl.message(
      'View comments',
      name: 'viewComments',
      desc: '',
      args: [],
    );
  }

  /// `Write your comment...`
  String get writeComment {
    return Intl.message(
      'Write your comment...',
      name: 'writeComment',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get user {
    return Intl.message('User', name: 'user', desc: '', args: []);
  }

  /// `Unknown date`
  String get unknownDate {
    return Intl.message(
      'Unknown date',
      name: 'unknownDate',
      desc: '',
      args: [],
    );
  }

  /// `No posts available 📝`
  String get noPostsAvailable {
    return Intl.message(
      'No posts available 📝',
      name: 'noPostsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Liked Posts`
  String get likedPosts {
    return Intl.message('Liked Posts', name: 'likedPosts', desc: '', args: []);
  }

  /// `You have not liked any posts yet.`
  String get noLikedPosts {
    return Intl.message(
      'You have not liked any posts yet.',
      name: 'noLikedPosts',
      desc: '',
      args: [],
    );
  }

  /// `LOGIN`
  String get loginHeader {
    return Intl.message('LOGIN', name: 'loginHeader', desc: '', args: []);
  }

  /// `Welcome back!`
  String get loginSubHeader {
    return Intl.message(
      'Welcome back!',
      name: 'loginSubHeader',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get emailAddress {
    return Intl.message(
      'Email Address',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `example@domain.com`
  String get emailHint {
    return Intl.message(
      'example@domain.com',
      name: 'emailHint',
      desc: '',
      args: [],
    );
  }

  /// `enter your email`
  String get emailValidation {
    return Intl.message(
      'enter your email',
      name: 'emailValidation',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `************`
  String get passwordHint {
    return Intl.message(
      '************',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `enter your password`
  String get passwordValidation {
    return Intl.message(
      'enter your password',
      name: 'passwordValidation',
      desc: '',
      args: [],
    );
  }

  /// `LOGIN`
  String get loginButton {
    return Intl.message('LOGIN', name: 'loginButton', desc: '', args: []);
  }

  /// `Login With Google`
  String get loginWithGoogle {
    return Intl.message(
      'Login With Google',
      name: 'loginWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? `
  String get noAccount {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `Register Now`
  String get registerNow {
    return Intl.message(
      'Register Now',
      name: 'registerNow',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while signing in with Google`
  String get googleError {
    return Intl.message(
      'An error occurred while signing in with Google',
      name: 'googleError',
      desc: '',
      args: [],
    );
  }

  /// `Your data is incorrect or the account does not exist`
  String get loginError {
    return Intl.message(
      'Your data is incorrect or the account does not exist',
      name: 'loginError',
      desc: '',
      args: [],
    );
  }

  /// `Post`
  String get post {
    return Intl.message('Post', name: 'post', desc: '', args: []);
  }

  /// `What is in your mind {name}...`
  String whatIsOnYourMind(String name) {
    return Intl.message(
      'What is in your mind $name...',
      name: 'whatIsOnYourMind',
      desc: '',
      args: [name],
    );
  }

  /// `Add Photo`
  String get addPhoto {
    return Intl.message('Add Photo', name: 'addPhoto', desc: '', args: []);
  }

  /// `No internet connection`
  String get noInternet {
    return Intl.message(
      'No internet connection',
      name: 'noInternet',
      desc: '',
      args: [],
    );
  }

  /// `Check your connection and try again`
  String get checkConnection {
    return Intl.message(
      'Check your connection and try again',
      name: 'checkConnection',
      desc: '',
      args: [],
    );
  }

  /// `try again!`
  String get tryAgain {
    return Intl.message('try again!', name: 'tryAgain', desc: '', args: []);
  }

  /// `Mark all read`
  String get markAllRead {
    return Intl.message(
      'Mark all read',
      name: 'markAllRead',
      desc: '',
      args: [],
    );
  }

  /// `No notifications yet`
  String get noNotifications {
    return Intl.message(
      'No notifications yet',
      name: 'noNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Just now`
  String get justNow {
    return Intl.message('Just now', name: 'justNow', desc: '', args: []);
  }

  /// `{count}m ago`
  String minutesAgo(Object count) {
    return Intl.message(
      '${count}m ago',
      name: 'minutesAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count}h ago`
  String hoursAgo(Object count) {
    return Intl.message(
      '${count}h ago',
      name: 'hoursAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count}d ago`
  String daysAgo(Object count) {
    return Intl.message(
      '${count}d ago',
      name: 'daysAgo',
      desc: '',
      args: [count],
    );
  }

  /// `Failed to load user data: {error}`
  String failedToLoadUser(String error) {
    return Intl.message(
      'Failed to load user data: $error',
      name: 'failedToLoadUser',
      desc: '',
      args: [error],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Unknown`
  String get unknownUser {
    return Intl.message('Unknown', name: 'unknownUser', desc: '', args: []);
  }

  /// `Write your bio...`
  String get defaultBio {
    return Intl.message(
      'Write your bio...',
      name: 'defaultBio',
      desc: '',
      args: [],
    );
  }

  /// `Posts`
  String get posts {
    return Intl.message('Posts', name: 'posts', desc: '', args: []);
  }

  /// `Add photos`
  String get addPhotos {
    return Intl.message('Add photos', name: 'addPhotos', desc: '', args: []);
  }

  /// `My Posts`
  String get myPosts {
    return Intl.message('My Posts', name: 'myPosts', desc: '', args: []);
  }

  /// `You have not posted anything yet.`
  String get noPostsYet {
    return Intl.message(
      'You have not posted anything yet.',
      name: 'noPostsYet',
      desc: '',
      args: [],
    );
  }

  /// `REGISTER`
  String get registerTitle {
    return Intl.message('REGISTER', name: 'registerTitle', desc: '', args: []);
  }

  /// `register now to communicate with friends `
  String get registerSubtitle {
    return Intl.message(
      'register now to communicate with friends ',
      name: 'registerSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `User Name`
  String get userName {
    return Intl.message('User Name', name: 'userName', desc: '', args: []);
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get registerButton {
    return Intl.message('Register', name: 'registerButton', desc: '', args: []);
  }

  /// `enter your name`
  String get nameValidation {
    return Intl.message(
      'enter your name',
      name: 'nameValidation',
      desc: '',
      args: [],
    );
  }

  /// `enter your phone number`
  String get phoneValidation {
    return Intl.message(
      'enter your phone number',
      name: 'phoneValidation',
      desc: '',
      args: [],
    );
  }

  /// `Search users or posts...`
  String get searchHint {
    return Intl.message(
      'Search users or posts...',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `No posts to explore yet`
  String get noPostsExplore {
    return Intl.message(
      'No posts to explore yet',
      name: 'noPostsExplore',
      desc: '',
      args: [],
    );
  }

  /// `No results found`
  String get noResultsFound {
    return Intl.message(
      'No results found',
      name: 'noResultsFound',
      desc: '',
      args: [],
    );
  }

  /// `Users`
  String get users {
    return Intl.message('Users', name: 'users', desc: '', args: []);
  }

  /// `MiniGram User`
  String get miniGramUser {
    return Intl.message(
      'MiniGram User',
      name: 'miniGramUser',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
