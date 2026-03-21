import 'package:mini_gram/models/user_model.dart';

abstract class UserStates {}

class UserInitialState extends UserStates{}

class UserGetUserLoadingState extends UserStates{}
class UserGetUserSuccessState extends UserStates
{
  final UserModel userModel;
  UserGetUserSuccessState(this.userModel);
}
class UserGetUserErrorState extends UserStates{
  final String error;
  UserGetUserErrorState(this.error);
}

class UserUidUpdatedState extends UserStates{}

class UserLoadedSuccessState extends UserStates
{
  final UserModel userModel;
  UserLoadedSuccessState(this.userModel);
}

class UserErrorState extends UserStates{
  final String error;
  UserErrorState(this.error);
}

class UserGetUserInitialState extends UserStates{}