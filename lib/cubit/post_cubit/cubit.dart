import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_gram/cubit/post_cubit/states.dart';
import 'package:mini_gram/cubit/user_cubit/cubit.dart';
import 'package:mini_gram/models/post_model.dart';
import 'package:mini_gram/services/notification_service.dart';

class PostCubit extends Cubit<PostStates> {
  final UserCubit userCubit;

  PostCubit(this.userCubit) : super(PostInitialState());

  static PostCubit get(context) => BlocProvider.of(context);

  final notificationService = NotificationService();

  final ImagePicker picker = ImagePicker();
  File? postImage;

  List<postModel> posts = [];
  List<String> postId = [];
  Map<String, bool> userLikes = {};

  Future<void> pickPostImage() async {
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      postImage = File(pickedImage.path);
      emit(PostImagePickedSuccessState());
    } else {
      emit(PostImagePickedErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(RemovePostImageState());
  }


  void uploadPostImage({required Timestamp dateTime, required String text}) {
    if (postImage == null) return;

    emit(CreatePostLoadingState());

    FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
          value.ref
              .getDownloadURL()
              .then((url) {
                createPost(dateTime: dateTime, text: text, postImage: url);
                getPost();
              })
              .catchError((error) {
                emit(CreatePostErrorState());
              });
        })
        .catchError((error) {
          emit(CreatePostErrorState());
        });
  }

  void createPost({
    required Timestamp dateTime,
    required String text,
    String? postImage,
  }) {
    final user = userCubit.modell;
    if (user == null || user.uId == null) {
      emit(CreatePostErrorState());
      return;
    }

    postModel model = postModel(
      name: user.name ?? 'unknown',
      uId: user.uId!,
      image: user.image ?? '',
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );

    emit(CreatePostLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
          print("Post created with ID: ${value.id}");
          getPost();
          emit(CreatePostSuccessState());
        })
        .catchError((error) {
          print("Error creating post: $error");
          emit(CreatePostErrorState());
        });
  }

  void resetPosts() {
    posts = [];
    postId = [];
    userLikes = {};
  }

  Future<void> getPost() async {
    emit(GetPostLoadingState());

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('dateTime', descending: true)
          .get();

      posts = [];
      userLikes = {};

      for (var doc in snapshot.docs) {
        var data = doc.data();
        var post = postModel.fromJson(data);
        post.postId = doc.id;

        final likesSnapshot = await doc.reference.collection('likes').get();
        post.likesCount = likesSnapshot.docs.length;

        final currentUserId = userCubit.modell?.uId;
        final userLikedDoc = await doc.reference
            .collection('likes')
            .doc(currentUserId)
            .get();
        userLikes[doc.id] = userLikedDoc.exists;

        posts.add(post);
      }

      emit(GetPostSuccessState());
    } catch (error) {
      emit(GetPostErrorState(error.toString()));
    }
  }

  void toggleLike(String postId, int index) async {
    final user = userCubit.modell;
    if (user == null || user.uId == null) return;

    final likeDocRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(user.uId);

    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

    try {
      final doc = await likeDocRef.get();
      bool isLiked = doc.exists;

      if (isLiked) {
        await likeDocRef.delete();
        userLikes[postId] = false;
      } else {
        await likeDocRef.set({'like': true});
        userLikes[postId] = true;

        final postDoc = await postRef.get();
        final postData = postDoc.data()!;
        final ownerTokenDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(postData['uId'])
            .get();
        final ownerToken = ownerTokenDoc.data()?['fcmToken'];
        if (ownerToken != null) {
          await NotificationService.sendLikeNotification(
            token: ownerToken,
            likedByName: user.name ?? 'Someone',
            receiverUId: postData['uId'],
          );
        }
      }

      final likesSnapshot = await postRef.collection('likes').get();
      final likesCount = likesSnapshot.docs.length;

      posts[index].likesCount = likesCount;
      await postRef.update({'likesCount': likesCount});

      emit(GetPostLikeSuccessState());
    } catch (error) {
      emit(GetLikePostErrorState(error.toString()));
    }
  }

  void clearPosts() {
    posts.clear();
    emit(GetPostInitialState());
  }

  void deletePost(String postId) {
    emit(DeletePostLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value) {
          getPost();
          emit(DeletePostSuccessState());
        })
        .catchError((error) {
          emit(DeletePostErrorState(error.toString()));
        });
  }

  void updatePost({required postId, required String text}) {
    emit(UpdatePostLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update({'text': text})
        .then((value) {
          getPost();
          emit(UpdatePostSuccessState());
        })
        .catchError((error) {
          emit(UpdatePostErrorState(error.toString()));
        });
  }

  void copyPostText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    emit(CopyPostTextState());
  }

  Future<void> reportPost(String postId, {String? reason}) async {
    emit(ReportPostLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('reports')
          .add({
            'reporterId': userCubit.modell?.uId,
            'reason': reason ?? 'No reason',
            'dateTime': Timestamp.now(),
          });
      emit(ReportPostSuccessState());
    } catch (error) {
      emit(ReportPostErrorState(error.toString()));
    }
  }

  void addComment({required String postId, required String text}) async {
    final user = userCubit.modell;
    if (user == null) return;

    emit(AddCommentLoadingState());

    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add({
            'userId': user.uId,
            'text': text,
            'dateTime': Timestamp.now(),
            'userName': user.name,
            'userImage': user.image,
          });

      emit(AddCommentSuccessState());

      final postDoc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .get();
      final postData = postDoc.data()!;
      final ownerTokenDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(postData['uId'])
          .get();
      final ownerToken = ownerTokenDoc.data()?['fcmToken'];

      if (ownerToken != null) {
        // send notification
        NotificationService.sendCommentNotification(
          token: ownerToken,
          commenterName: user.name ?? 'Someone',
          receiverUId: postData['uId'],
        );
      }
    } catch (error) {
      emit(AddCommentErrorState(error.toString()));
    }
  }

  Stream<QuerySnapshot> getComments(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('dateTime', descending: true)
        .snapshots();
  }

  List<postModel> get myPosts {
    return posts.where((post) => post.uId == userCubit.modell?.uId).toList();
  }

  //Map<String, bool> userLikes; // postId -> true/false
}
