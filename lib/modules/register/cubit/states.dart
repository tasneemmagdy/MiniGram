abstract class MiniGramRegisterStates{}

class MiniGramRegisterInitialStates extends MiniGramRegisterStates{}

class MiniGramRegisterLoadingState extends MiniGramRegisterStates{}

class MiniGramRegisterSuccessState extends MiniGramRegisterStates{}

class MiniGramRegisterFailedState extends MiniGramRegisterStates{
  late final String error;

  MiniGramRegisterFailedState(this.error);
}

class MiniGramCreateUserSuccessState extends MiniGramRegisterStates{}

class MiniGramCreateUserFailedState extends MiniGramRegisterStates{
  late final String error;

  MiniGramCreateUserFailedState(this.error);
}

class ChangePasswordIcon extends MiniGramRegisterStates{}