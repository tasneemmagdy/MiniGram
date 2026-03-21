import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:mini_gram/cubit/message_cubit/cubit.dart';
import 'package:mini_gram/cubit/message_cubit/states.dart';
import 'package:mini_gram/generated/l10n.dart'; 
import 'package:mini_gram/models/message_model.dart';
import 'package:mini_gram/models/user_model.dart';

class ChatDetailsScreen extends StatefulWidget {
  final UserModel userModel;
  const ChatDetailsScreen({super.key, required this.userModel});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  MessageModel? _replyMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MessageCubit.get(context).getMessages(receiverId: widget.userModel.uId!);
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatMessageTime(String? dateTime) {
    if (dateTime == null) return '';
    try {
      final time = DateTime.parse(dateTime);
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } catch (_) {
      return '';
    }
  }

  void _showMessageOptions(
      BuildContext context, MessageModel message, bool isMe) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = MessageCubit.get(context);
    final s = S.of(context); 

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message.text ?? '',
                    style: theme.textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(IconlyLight.paperDownload),
                  title: Text(s.copy), 
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: message.text ?? ''));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(s.messageCopied), 
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(IconlyLight.send),
                  title: Text(s.reply), 
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _replyMessage = message);
                    messageController.selection = TextSelection.fromPosition(
                      TextPosition(offset: messageController.text.length),
                    );
                  },
                ),
                if (isMe)
                  ListTile(
                    leading: const Icon(
                      IconlyLight.delete,
                      color: Colors.red,
                    ),
                    title: Text(
                      s.delete, 
                      style: const TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      cubit.deleteMessage(
                        receiverId: widget.userModel.uId!,
                        messageText: message.text ?? '',
                        dateTime: message.dateTime ?? '',
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context); 
    var cubit = MessageCubit.get(context);

    return Scaffold(
        extendBodyBehindAppBar: false,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: colorScheme.surfaceVariant,
                  backgroundImage: (widget.userModel.image != null &&
                          widget.userModel.image!.isNotEmpty)
                      ? NetworkImage(widget.userModel.image!)
                      : null,
                  child: (widget.userModel.image == null ||
                          widget.userModel.image!.isEmpty)
                      ? Icon(Icons.person, color: colorScheme.outline)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 11,
                    height: 11,
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
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userModel.name ?? s.defaultUserName, 
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  s.activeNow, 
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<MessageCubit, MessageStates>(
          listener: (context, state) {
            if (state is GetMessageSuccessState) {
              _scrollToBottom();
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: cubit.messages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.chat_bubble_outline,
                                  size: 64, color: colorScheme.outline),
                              const SizedBox(height: 12),
                              Text(
                                s.noMessages, 
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.outline,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          itemCount: cubit.messages.length,
                          itemBuilder: (context, index) {
                            final message = cubit.messages[index];
                            final isMe = message.senderId ==
                                cubit.userCubit.modell!.uId;
                            final time = _formatMessageTime(message.dateTime);
                            final showDate = index == 0 ||
                                _isDifferentDay(
                                  cubit.messages[index - 1].dateTime,
                                  message.dateTime,
                                );
        
                            return Column(
                              children: [
                                if (showDate)
                                  _buildDateSeparator(context, message.dateTime),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onLongPress: () => _showMessageOptions(
                                      context, message, isMe),
                                  child: isMe
                                      ? _buildMyMessage(context, message, time)
                                      : _buildReceiverMessage(
                                          context, message, time),
                                ),
                                const SizedBox(height: 4),
                              ],
                            );
                          },
                        ),
                ),
                if (_replyMessage != null)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        left: BorderSide(
                          color: colorScheme.primary,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.replyingTo, 
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _replyMessage!.text ?? '',
                                style: theme.textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: () =>
                              setState(() => _replyMessage = null),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(
  left: 12,
  right: 12,
  top: 8,
  bottom: 8,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.dividerColor),
                      borderRadius: BorderRadius.circular(30),
                      color: theme.cardColor,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: messageController,
                            style: TextStyle(
                                color: theme.textTheme.bodyMedium?.color),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: s.typeMessage, 
                              hintStyle: TextStyle(color: theme.hintColor),
                            ),
                            onFieldSubmitted: (_) => _sendMessage(cubit),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: colorScheme.primary,
                            child: IconButton(
                              icon: Icon(
                                IconlyLight.send,
                                size: 18,
                                color: colorScheme.onPrimary,
                              ),
                              onPressed: () => _sendMessage(cubit),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _sendMessage(MessageCubit cubit) {
    if (messageController.text.trim().isEmpty) return;
    final replyText = _replyMessage?.text;
    cubit.sendMessage(
      receiverId: widget.userModel.uId!,
      text: messageController.text.trim(),
      replyTo: replyText,
    );
    messageController.clear();
    setState(() => _replyMessage = null);
    _scrollToBottom();
  }

  bool _isDifferentDay(String? date1, String? date2) {
    if (date1 == null || date2 == null) return false;
    try {
      final d1 = DateTime.parse(date1);
      final d2 = DateTime.parse(date2);
      return d1.day != d2.day ||
          d1.month != d2.month ||
          d1.year != d2.year;
    } catch (_) {
      return false;
    }
  }

  Widget _buildDateSeparator(BuildContext context, String? dateTime) {
    final theme = Theme.of(context);
    final s = S.of(context); 
    String label = '';
    if (dateTime != null) {
      try {
        final date = DateTime.parse(dateTime);
        final now = DateTime.now();
        if (date.day == now.day &&
            date.month == now.month &&
            date.year == now.year) {
          label = s.today; 
        } else if (date.day == now.day - 1 &&
            date.month == now.month &&
            date.year == now.year) {
          label = s.yesterday; 
        } else {
          label = '${date.day}/${date.month}/${date.year}';
        }
      } catch (_) {}
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Divider(color: theme.dividerColor)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ),
          Expanded(child: Divider(color: theme.dividerColor)),
        ],
      ),
    );
  }

  Widget _buildMyMessage(
      BuildContext context, MessageModel message, String time) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (message.replyTo != null)
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    left: BorderSide(
                        color: colorScheme.onPrimary, width: 2),
                  ),
                ),
                child: Text(
                  message.replyTo!,
                  style: TextStyle(
                    color: colorScheme.onPrimary.withOpacity(0.8),
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Text(
              message.text ?? '',
              style: TextStyle(color: colorScheme.onPrimary),
            ),
            const SizedBox(height: 3),
            Text(
              time,
              style: TextStyle(
                color: colorScheme.onPrimary.withOpacity(0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiverMessage(
      BuildContext context, MessageModel message, String time) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
color: theme.brightness == Brightness.dark
    ? Colors.grey.shade800
    : Colors.grey.shade200,          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(18),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.replyTo != null)
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.outline.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    left: BorderSide(
                        color: colorScheme.primary, width: 2),
                  ),
                ),
                child: Text(
                  message.replyTo!,
                  style: TextStyle(
                    color: theme.textTheme.bodySmall?.color,
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Text(
              message.text ?? '',
              style: TextStyle(color: theme.textTheme.bodyMedium?.color),
            ),
            const SizedBox(height: 3),
            Text(
              time,
              style: TextStyle(
                color: colorScheme.outline,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}