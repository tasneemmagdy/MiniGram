import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_gram/cubit/post_cubit/cubit.dart';
import 'package:mini_gram/cubit/post_cubit/states.dart';
import 'package:mini_gram/cubit/user_cubit/cubit.dart';
import 'package:mini_gram/cubit/user_cubit/states.dart';
import 'package:mini_gram/models/post_model.dart';
import 'package:mini_gram/modules/edit_post/edit_post_screen.dart';
import 'package:mini_gram/generated/l10n.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserCubit, UserStates>(
          listener: (context, state) {
            if (state is UserGetUserSuccessState) {
              PostCubit.get(context).resetPosts();
              PostCubit.get(context).getPost();
            }
          },
        ),
      ],
      child: BlocConsumer<PostCubit, PostStates>(
  listener: (context, state) {},
  builder: (context, state) {
    var postCubit = PostCubit.get(context);

    return RefreshIndicator(
      onRefresh: () async {
        postCubit.resetPosts();
        await postCubit.getPost();
      },
      child: ConditionalBuilder(
        condition: postCubit.posts.isNotEmpty,
        builder: (context) => ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: postCubit.posts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) =>
              buildPostItem(context, postCubit.posts[index], index),
        ),
        fallback: (context) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 300),
            Center(
              child: Text(
                S.of(context).noPostsAvailable,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  },
),
    
    );
  }
}

String _formatPostDate(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  final h = date.hour.toString().padLeft(2, '0');
  final m = date.minute.toString().padLeft(2, '0');
  return '${date.day}/${date.month}/${date.year} $h:$m';
}

Widget buildPostItem(BuildContext context, postModel model, int index) {
  var postCubit = PostCubit.get(context);
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final s = S.of(context);
  TextEditingController commentController = TextEditingController();

  return Card(
    color: theme.cardColor,
    elevation: 2,
    margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ← Header
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 8, 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: colorScheme.surfaceVariant,
                backgroundImage:
                    (model.image != null && model.image!.isNotEmpty)
                    ? NetworkImage(model.image!)
                    : null,
                child: (model.image == null || model.image!.isEmpty)
                    ? Text(
                        (model.name ?? 'U')[0].toUpperCase(),
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name ?? s.user,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          model.dateTime != null
                              ? _formatPostDate(model.dateTime!.toDate())
                              : s.unknownDate,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.outline,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.public,
                          size: 11,
                          color: colorScheme.outline,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: Icon(
                  Icons.more_horiz,
                  size: 20,
                  color: colorScheme.outline,
                ),
                itemBuilder: (context) {
                  if (postCubit.userCubit.modell?.uId == model.uId) {
                    return [
                      PopupMenuItem(value: 'edit', child: Text(s.editPost)),
                      PopupMenuItem(value: 'delete', child: Text(s.deletePost)),
                    ];
                  } else {
                    return [
                      PopupMenuItem(value: 'report', child: Text(s.reportPost)),
                      PopupMenuItem(value: 'copy', child: Text(s.copyText)),
                    ];
                  }
                },
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditPostScreen(model: model),
                        ),
                      );
                      break;
                    case 'delete':
                      postCubit.deletePost(model.postId!);
                      break;
                    case 'report':
                      postCubit.reportPost(model.postId!);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(s.postReported)));
                      break;
                    case 'copy':
                      postCubit.copyPostText(model.text ?? '');
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(s.postCopied)));
                      break;
                  }
                },
              ),
            ],
          ),
        ),

        // ← Post text
        if (model.text != null && model.text!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: Text(
              model.text!,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ),

        // ← Post image
        if (model.postImage != null && model.postImage!.isNotEmpty)
          ClipRRect(
            child: Image.network(
              model.postImage!,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 250,
                  color: colorScheme.surfaceVariant,
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                height: 150,
                color: colorScheme.surfaceVariant,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: colorScheme.outline,
                ),
              ),
            ),
          ),

        // ← Likes count row
        if ((model.likesCount ?? 0) > 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    size: 10,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${model.likesCount}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),

        const Divider(height: 16, indent: 12, endIndent: 12),

        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Row(
            children: [
              // Like
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => postCubit.toggleLike(model.postId!, index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          postCubit.userLikes[model.postId] == true
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: postCubit.userLikes[model.postId] == true
                              ? Colors.red
                              : colorScheme.outline,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          s.likes,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: postCubit.userLikes[model.postId] == true
                                ? Colors.red
                                : colorScheme.outline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Comment
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _showComments(
                    context,
                    model,
                    postCubit,
                    commentController,
                    theme,
                    colorScheme,
                    s,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 20,
                          color: colorScheme.outline,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          s.viewComments,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.outline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

void _showComments(
  BuildContext context,
  postModel model,
  PostCubit postCubit,
  TextEditingController commentController,
  ThemeData theme,
  ColorScheme colorScheme,
  S s,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (modalContext) {
      return Theme(
        data: theme,
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Text(
                  s.viewComments,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: StreamBuilder(
                    stream: postCubit.getComments(model.postId!),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      var comments = snapshot.data!.docs;
                      if (comments.isEmpty) {
                        return Center(
                          child: Text(
                            'No comments yet 💬',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.outline,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          var c = comments[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: colorScheme.surfaceVariant,
                                  backgroundImage:
                                      (c['userImage'] ?? '').isNotEmpty
                                      ? NetworkImage(c['userImage'])
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme.surfaceVariant,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          c['userName'] ?? s.user,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          c['text'] ?? '',
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom > 0
                        ? MediaQuery.of(context).viewInsets.bottom + 8
                        : MediaQuery.of(context).padding.bottom + 12,
                    left: 12,
                    right: 12,
                    top: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                          decoration: InputDecoration(
                            hintText: s.writeComment,
                            filled: true,
                            fillColor: colorScheme.surfaceVariant,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: colorScheme.primary,
                        child: IconButton(
                          icon: Icon(
                            Icons.send,
                            size: 18,
                            color: colorScheme.onPrimary,
                          ),
                          onPressed: () {
                            if (commentController.text.trim().isEmpty) return;
                            postCubit.addComment(
                              postId: model.postId!,
                              text: commentController.text.trim(),
                            );
                            commentController.clear();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
