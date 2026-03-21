import 'package:mini_gram/models/user_model.dart';

abstract class ProfileStates {}

class ProfileInitialState extends ProfileStates{}

class ProfileCoverImagePickedSuccessState extends ProfileStates {}
class ProfileCoverImagePickedErrorState extends ProfileStates {}

class ProfileImagePickedSuccessState extends ProfileStates {}
class ProfileImagePickedErrorState extends ProfileStates {}

class ProfileUploadCoverImageSuccessState extends ProfileStates {}
class ProfileUploadCoverImageErrorState extends ProfileStates {}

class ProfileUploadProfileImageSuccessState extends ProfileStates {}
class ProfileUploadProfileImageErrorState extends ProfileStates {}


class ProfileUserUpdateLoadingState extends ProfileStates{}
class ProfileUserUpdateSeccessState extends ProfileStates
{
  late final UserModel userModel;  
  ProfileUserUpdateSeccessState(this.userModel);
}
class ProfileUserUpdateErrorState extends ProfileStates{}

class ProfileUserUpdateAllLoadingState extends ProfileStates{}
