abstract class MessageStates {}

class MessageInitialState extends MessageStates {}

class SendMessageSuccessState extends MessageStates {}

class SendMessageErrorState extends MessageStates {
  final String error;
  SendMessageErrorState(this.error);
}

class GetMessageSuccessState extends MessageStates {}

class DeleteMessageSuccessState extends MessageStates {}

class DeleteMessageErrorState extends MessageStates {
  final String error;
  DeleteMessageErrorState(this.error);
}
