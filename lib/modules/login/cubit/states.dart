abstract class MiniGramLoginStates{}

class MiniGramLoginInitialStates extends MiniGramLoginStates{}

class MiniGramLoginLoadingState extends MiniGramLoginStates{}

class MiniGramLoginSuccessState extends MiniGramLoginStates{
  final String uId;

  MiniGramLoginSuccessState(this.uId);

}


class MiniGramLoginFailedState extends MiniGramLoginStates{
  late final String error;

  MiniGramLoginFailedState(this.error);
}

class changePasswordIcon extends MiniGramLoginStates{}