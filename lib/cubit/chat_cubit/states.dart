abstract class ChatStates {}

class ChatInitialState extends ChatStates {}

class GetAllUsersLoadingState extends ChatStates {}

class GetAllUsersSuccessState extends ChatStates {}

class GetAllUsersFailedState extends ChatStates 
{
  final String error;
  GetAllUsersFailedState(this.error);
}
