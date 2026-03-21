import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_gram/cubit/post_cubit/cubit.dart';
import 'package:mini_gram/cubit/post_cubit/states.dart';
import 'package:mini_gram/generated/l10n.dart';
import 'package:mini_gram/models/post_model.dart';

class EditPostScreen extends StatelessWidget {
  final postModel model; 

  EditPostScreen({super.key, required this.model});
  
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    textController.text = model.text ?? '';
    final s = S.of(context);

    return BlocConsumer<PostCubit, PostStates>(
      listener: (context, state) {
        if (state is UpdatePostSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(s.postUpdatedSuccess)),
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(s.editPost),
            actions: [
              if (state is UpdatePostLoadingState)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else
                TextButton(
                  onPressed: () {
                    PostCubit.get(context).updatePost(
                      postId: model.postId!,
                      text: textController.text,
                    );
                  },
                  child: Text(
                    s.update,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
            ],
          ),
          body: SingleChildScrollView( 
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: textController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: s.editPostHint,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (model.postImage != null && model.postImage!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        model.postImage!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}