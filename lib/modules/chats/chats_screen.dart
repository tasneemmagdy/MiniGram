import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_gram/core/component/components.dart';
import 'package:mini_gram/cubit/chat_cubit/cubit.dart';
import 'package:mini_gram/cubit/chat_cubit/states.dart';
import 'package:mini_gram/generated/l10n.dart';
import 'package:mini_gram/models/user_model.dart';
import 'package:mini_gram/modules/chats_details/chat_details_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  String _formatTime(BuildContext context, Timestamp timestamp) {
    final now = DateTime.now();
    final time = timestamp.toDate();
    final diff = now.difference(time);
    final s = S.of(context); 

    if (diff.inMinutes < 1) return s.now;
    if (diff.inMinutes < 60) return '${diff.inMinutes}${s.minutesLetter}';
    if (diff.inHours < 24) return '${diff.inHours}${s.hoursLetter}';
    if (diff.inDays < 7) return '${diff.inDays}${s.daysLetter}';
    return '${time.day}/${time.month}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context); 

    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ChatCubit.get(context);

        return ConditionalBuilder(
          condition: cubit.users.isNotEmpty,
          builder: (context) => RefreshIndicator(
            onRefresh: () async {
              cubit.getUsers();
            },
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: cubit.users.length,
              itemBuilder: (context, index) => _buildChatItem(
                context,
                cubit.users[index],
                theme,
                colorScheme,
              ),
            ),
          ),
          fallback: (context) => state is GetAllUsersLoadingState
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          size: 64, color: colorScheme.outline),
                      const SizedBox(height: 12),
                      Text(
                        s.noChats, 
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildChatItem(
    BuildContext context,
    UserModel model,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final s = S.of(context); 
    
    return InkWell(
      onTap: () => navigateTo(context, ChatDetailsScreen(userModel: model)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: colorScheme.surfaceVariant,
                  backgroundImage:
                      (model.image != null && model.image!.isNotEmpty)
                          ? NetworkImage(model.image!)
                          : null,
                  child: (model.image == null || model.image!.isEmpty)
                      ? Icon(Icons.person, color: colorScheme.outline)
                      : null,
                ),
                Positioned(
                  bottom: 1,
                  right: 1,
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 14),

            // Name & last message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name ?? s.defaultUserName, 
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    model.lastMessage ?? s.startChatting, 
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.outline,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Time
            Text(
              model.lastMessageTime != null
                  ? _formatTime(context, model.lastMessageTime!) 
                  : '',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.outline,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

