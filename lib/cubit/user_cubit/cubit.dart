import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_gram/cubit/user_cubit/states.dart';
import 'package:mini_gram/models/user_model.dart';
import 'package:mini_gram/services/shared/network/local/cashe_helper.dart';

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitialState());

  static UserCubit get(context) => BlocProvider.of(context);

  UserModel? modell;
  Map<String, dynamic>? userModel;

  void getUserData({String? uId}) {
    emit(UserGetUserLoadingState());

    String? id = uId ?? CasheHelper.getData(key: 'uId');

    print("getUserData called with uId: $uId");
    print("id to use: $id");

    if (id == null || id.isEmpty) {
      print("ERROR: id is null or empty");
      emit(UserGetUserErrorState("User ID not found"));
      return;
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((doc) {
          if (doc.exists) {
            modell = UserModel.fromJson(doc.data()!);
            emit(UserGetUserSuccessState(modell!));
          } else {
            // User not found - create new user document from Firebase Auth
            print("User not found in Firestore, creating new user document...");
            _createUserFromAuth(id);
          }
        })
        .catchError((error) {
          print("Firestore error: $error");
          emit(UserGetUserErrorState(error.toString()));
        });
  }

  // Create user document when not found in Firestore
  Future<void> _createUserFromAuth(String uId) async {
    try {
      // Get current user from Firebase Auth
      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        emit(UserGetUserErrorState("No authenticated user found"));
        return;
      }

      // Create user model with data from Firebase Auth
      UserModel newUser = UserModel(
        name: firebaseUser.displayName ?? 'New User',
        email: firebaseUser.email ?? 'unknown@email.com',
        phone: firebaseUser.phoneNumber ?? '',
        uId: uId,
        isEmailVerified: firebaseUser.emailVerified,
        image:
            firebaseUser.photoURL ??
            'https://img.freepik.com/free-vector/city-people-outdoor_24908-55059.jpg',
        coverImage:
            'https://img.freepik.com/free-vector/city-people-outdoor_24908-55059.jpg',
        bio: 'Write your bio...',
      );

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .set(newUser.toMap());

      print("New user document created successfully!");
      modell = newUser;
      emit(UserGetUserSuccessState(modell!));
    } catch (error) {
      print("Error creating user: $error");
      emit(UserGetUserErrorState(error.toString()));
    }
  }

  void clearUserData() {
    modell = null;
    userModel = null;
    emit(UserInitialState());
  }
}
