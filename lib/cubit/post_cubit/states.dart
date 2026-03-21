abstract class PostStates {}

class PostInitialState extends PostStates{}


class CreatePostLoadingState extends PostStates{}
class CreatePostSuccessState extends PostStates{}
class CreatePostErrorState extends PostStates{}


class PostImagePickedSuccessState extends PostStates {}
class PostImagePickedErrorState extends PostStates {}


class RemovePostImageState extends PostStates{}

class GetPostLoadingState extends PostStates{}
class GetPostSuccessState extends PostStates{}
class GetPostErrorState extends PostStates{
  final String error;
  GetPostErrorState(this.error);
}

class GetLikePostLoadingState extends PostStates{}
class GetPostLikeSuccessState extends PostStates{}
class GetLikePostErrorState extends PostStates{
  final String error;
  GetLikePostErrorState(this.error);
}

class GetPostInitialState extends PostStates{}

class DeletePostLoadingState extends PostStates{}
class DeletePostSuccessState extends PostStates{}
class DeletePostErrorState extends PostStates{
  final String error;
  DeletePostErrorState(this.error);
}


class UpdatePostLoadingState extends PostStates{}
class UpdatePostSuccessState extends PostStates{}
class UpdatePostErrorState extends PostStates{
  final String error;
  UpdatePostErrorState(this.error);
}

class CopyPostTextState extends PostStates{}

class ReportPostLoadingState extends PostStates{}
class ReportPostSuccessState extends PostStates{}
class ReportPostErrorState extends PostStates{
   final String error;
  ReportPostErrorState(this.error);
}


class AddCommentLoadingState extends PostStates{}
class AddCommentSuccessState extends PostStates{}
class AddCommentErrorState extends PostStates{
   final String error;
  AddCommentErrorState(this.error);
}

class PostLoadingState extends PostStates{}