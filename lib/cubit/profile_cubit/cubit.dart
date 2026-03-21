import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_gram/core/component/constant.dart';
import 'package:mini_gram/cubit/profile_cubit/states.dart';
import 'package:mini_gram/cubit/user_cubit/cubit.dart';
import 'package:mini_gram/cubit/user_cubit/states.dart';
import 'package:mini_gram/models/user_model.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final UserCubit userCubit;

  ProfileCubit(this.userCubit) : super(ProfileInitialState());
  static ProfileCubit get(context) => BlocProvider.of(context);

  UserModel? modell;

  final ImagePicker picker = ImagePicker();
  File? profileImage;
  File? coverImage;

  Future<void> pickProfileImage() async {
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      profileImage = File(pickedImage.path);
      emit(ProfileImagePickedSuccessState());
    } else {
      emit(ProfileImagePickedErrorState());
    }
  }

  Future<void> pickCoverImage() async {
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      coverImage = File(pickedImage.path);
      emit(ProfileCoverImagePickedSuccessState());
    } else {
      emit(ProfileCoverImagePickedErrorState());
    }
  }

  Future<String?> uploadFile(File file, String path) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String bio,
  }) async {
    emit(ProfileUserUpdateAllLoadingState());

    final currentUser = userCubit.modell;
    if (currentUser == null) {
      emit(ProfileUserUpdateErrorState());
      return;
    }

    String? profileUrl = currentUser.image;
    String? coverUrl = currentUser.coverImage;

    if (profileImage != null) {
      final url = await uploadFile(
        profileImage!,
        'users/profile/${uId}_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      if (url != null) {
        profileUrl = url;
      } else {
        emit(ProfileUserUpdateErrorState());
        return;
      }
      profileImage = null;
    }

    if (coverImage != null) {
      final url = await uploadFile(
        coverImage!,
        'users/cover/${uId}_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      if (url != null) {
        coverUrl = url;
      } else {
        emit(ProfileUserUpdateErrorState());
        return;
      }
      coverImage = null;
    }

    final updatedModel = UserModel(
      uId: uId,
      name: name,
      email: email,
      phone: phone,
      bio: bio,
      image: profileUrl,
      coverImage: coverUrl,
      isEmailVerified: currentUser.isEmailVerified ?? false,
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .update(updatedModel.toMap());

      if (profileUrl != currentUser.image || name != currentUser.name) {
        final postsSnapshot = await FirebaseFirestore.instance
            .collection('posts')
            .where('uId', isEqualTo: uId)
            .get();

        if (postsSnapshot.docs.isNotEmpty) {
          final batch = FirebaseFirestore.instance.batch();
          for (var doc in postsSnapshot.docs) {
            batch.update(doc.reference, {
              'image': profileUrl,
              'name': name,
            });
          }
          await batch.commit();
        }
      }

      userCubit.modell = updatedModel;
      userCubit.emit(UserGetUserSuccessState(updatedModel));
      emit(ProfileUserUpdateSeccessState(updatedModel));
    } catch (error) {
      emit(ProfileUserUpdateErrorState());
    }
  }
}