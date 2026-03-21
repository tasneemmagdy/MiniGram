// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(count) => "${count}d ago";

  static String m1(error) => "Failed to load user data: ${error}";

  static String m2(count) => "${count}h ago";

  static String m3(count) => "${count}m ago";

  static String m4(name) => "What is in your mind ${name}...";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "activeNow": MessageLookupByLibrary.simpleMessage("Active now"),
    "addPhoto": MessageLookupByLibrary.simpleMessage("Add Photo"),
    "addPhotos": MessageLookupByLibrary.simpleMessage("Add photos"),
    "addPost": MessageLookupByLibrary.simpleMessage("Add Post"),
    "bio": MessageLookupByLibrary.simpleMessage("Bio"),
    "chat": MessageLookupByLibrary.simpleMessage("Chat"),
    "checkConnection": MessageLookupByLibrary.simpleMessage(
      "Check your connection and try again",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("Copy"),
    "copyText": MessageLookupByLibrary.simpleMessage("Copy Text"),
    "dark": MessageLookupByLibrary.simpleMessage("Dark"),
    "daysAgo": m0,
    "daysLetter": MessageLookupByLibrary.simpleMessage("d"),
    "defaultBio": MessageLookupByLibrary.simpleMessage("Write your bio..."),
    "defaultUserName": MessageLookupByLibrary.simpleMessage("MiniGram User"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deletePost": MessageLookupByLibrary.simpleMessage("Delete Post"),
    "editPost": MessageLookupByLibrary.simpleMessage("Edit Post"),
    "editPostHint": MessageLookupByLibrary.simpleMessage("Edit your post..."),
    "editProfile": MessageLookupByLibrary.simpleMessage("Edit Profile"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "emailAddress": MessageLookupByLibrary.simpleMessage("Email Address"),
    "emailHint": MessageLookupByLibrary.simpleMessage("example@domain.com"),
    "emailValidation": MessageLookupByLibrary.simpleMessage("enter your email"),
    "failedToLoadUser": m1,
    "googleError": MessageLookupByLibrary.simpleMessage(
      "An error occurred while signing in with Google",
    ),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "hoursAgo": m2,
    "hoursLetter": MessageLookupByLibrary.simpleMessage("h"),
    "justNow": MessageLookupByLibrary.simpleMessage("Just now"),
    "likedPosts": MessageLookupByLibrary.simpleMessage("Liked Posts"),
    "likes": MessageLookupByLibrary.simpleMessage("likes"),
    "loginButton": MessageLookupByLibrary.simpleMessage("LOGIN"),
    "loginError": MessageLookupByLibrary.simpleMessage(
      "Your data is incorrect or the account does not exist",
    ),
    "loginHeader": MessageLookupByLibrary.simpleMessage("LOGIN"),
    "loginSubHeader": MessageLookupByLibrary.simpleMessage("Welcome back!"),
    "loginWithGoogle": MessageLookupByLibrary.simpleMessage(
      "Login With Google",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "markAllRead": MessageLookupByLibrary.simpleMessage("Mark all read"),
    "messageCopied": MessageLookupByLibrary.simpleMessage("Message copied"),
    "miniGramUser": MessageLookupByLibrary.simpleMessage("MiniGram User"),
    "minutesAgo": m3,
    "minutesLetter": MessageLookupByLibrary.simpleMessage("m"),
    "myPosts": MessageLookupByLibrary.simpleMessage("My Posts"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "nameValidation": MessageLookupByLibrary.simpleMessage("enter your name"),
    "noAccount": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account? ",
    ),
    "noChats": MessageLookupByLibrary.simpleMessage("No chats yet"),
    "noInternet": MessageLookupByLibrary.simpleMessage(
      "No internet connection",
    ),
    "noLikedPosts": MessageLookupByLibrary.simpleMessage(
      "You have not liked any posts yet.",
    ),
    "noMessages": MessageLookupByLibrary.simpleMessage(
      "No messages yet\nSay hi! 👋",
    ),
    "noNotifications": MessageLookupByLibrary.simpleMessage(
      "No notifications yet",
    ),
    "noPostsAvailable": MessageLookupByLibrary.simpleMessage(
      "No posts available 📝",
    ),
    "noPostsExplore": MessageLookupByLibrary.simpleMessage(
      "No posts to explore yet",
    ),
    "noPostsYet": MessageLookupByLibrary.simpleMessage(
      "You have not posted anything yet.",
    ),
    "noResultsFound": MessageLookupByLibrary.simpleMessage("No results found"),
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "now": MessageLookupByLibrary.simpleMessage("now"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordHint": MessageLookupByLibrary.simpleMessage("************"),
    "passwordValidation": MessageLookupByLibrary.simpleMessage(
      "enter your password",
    ),
    "phone": MessageLookupByLibrary.simpleMessage("Phone"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone Number"),
    "phoneValidation": MessageLookupByLibrary.simpleMessage(
      "enter your phone number",
    ),
    "pleaseEnter": MessageLookupByLibrary.simpleMessage("Please enter"),
    "post": MessageLookupByLibrary.simpleMessage("Post"),
    "postCopied": MessageLookupByLibrary.simpleMessage(
      "Post copied to clipboard",
    ),
    "postReported": MessageLookupByLibrary.simpleMessage("Post reported"),
    "postUpdatedSuccess": MessageLookupByLibrary.simpleMessage(
      "Post updated successfully",
    ),
    "posts": MessageLookupByLibrary.simpleMessage("Posts"),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "registerButton": MessageLookupByLibrary.simpleMessage("Register"),
    "registerNow": MessageLookupByLibrary.simpleMessage("Register Now"),
    "registerSubtitle": MessageLookupByLibrary.simpleMessage(
      "register now to communicate with friends ",
    ),
    "registerTitle": MessageLookupByLibrary.simpleMessage("REGISTER"),
    "reply": MessageLookupByLibrary.simpleMessage("Reply"),
    "replyingTo": MessageLookupByLibrary.simpleMessage("Replying to"),
    "reportPost": MessageLookupByLibrary.simpleMessage("Report Post"),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "searchHint": MessageLookupByLibrary.simpleMessage(
      "Search users or posts...",
    ),
    "startChatting": MessageLookupByLibrary.simpleMessage(
      "Tap to start chatting",
    ),
    "today": MessageLookupByLibrary.simpleMessage("Today"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("try again!"),
    "typeMessage": MessageLookupByLibrary.simpleMessage("Message..."),
    "unknownDate": MessageLookupByLibrary.simpleMessage("Unknown date"),
    "unknownUser": MessageLookupByLibrary.simpleMessage("Unknown"),
    "update": MessageLookupByLibrary.simpleMessage("Update"),
    "updateProfile": MessageLookupByLibrary.simpleMessage("Update Profile"),
    "user": MessageLookupByLibrary.simpleMessage("User"),
    "userName": MessageLookupByLibrary.simpleMessage("User Name"),
    "users": MessageLookupByLibrary.simpleMessage("Users"),
    "viewComments": MessageLookupByLibrary.simpleMessage("View comments"),
    "whatIsOnYourMind": m4,
    "writeComment": MessageLookupByLibrary.simpleMessage(
      "Write your comment...",
    ),
    "yesterday": MessageLookupByLibrary.simpleMessage("Yesterday"),
  };
}
