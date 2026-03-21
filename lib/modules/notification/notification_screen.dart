import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_gram/cubit/notification_cubit/cubit.dart';
import 'package:mini_gram/cubit/notification_cubit/states.dart';
import 'package:mini_gram/cubit/user_cubit/cubit.dart';
import 'package:mini_gram/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_gram/generated/l10n.dart'; 

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  String _formatTime(Timestamp? timestamp, BuildContext context) {
    if (timestamp == null) return '';
    final s = S.of(context);
    final now = DateTime.now();
    final time = timestamp.toDate();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return s.justNow;
    if (diff.inMinutes < 60) return s.minutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return s.hoursAgo(diff.inHours);
    if (diff.inDays < 7) return s.daysAgo(diff.inDays);
    return '${time.day}/${time.month}';
  }

  IconData _getIcon(String? type) {
    switch (type) {
      case 'like': return Icons.favorite;
      case 'comment': return Icons.chat_bubble;
      case 'message': return Icons.message;
      default: return Icons.notifications;
    }
  }

  Color _getIconColor(String? type) {
    switch (type) {
      case 'like': return Colors.red;
      case 'comment': return Colors.blue;
      case 'message': return Colors.green;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final currentUId = UserCubit.get(context).modell?.uId ?? '';
  
    if (currentUId.isNotEmpty) {
        NotificationCubit.get(context).getNotifications(currentUId);
    }
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final uId = UserCubit.get(context).modell?.uId ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(s.notifications),
        actions: [
          BlocBuilder<NotificationCubit, NotificationStates>(
            builder: (context, state) {
              final cubit = NotificationCubit.get(context);
              if (cubit.unreadCount == 0) return const SizedBox();
              return TextButton(
                onPressed: () => cubit.markAllAsRead(uId),
                child: Text(
                  s.markAllRead,
                  style: TextStyle(color: colorScheme.primary),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationStates>(
        builder: (context, state) {
          final cubit = NotificationCubit.get(context);

          if (state is NotificationLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cubit.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined,
                      size: 64, color: colorScheme.outline),
                  const SizedBox(height: 12),
                  Text(
                    s.noNotifications,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: cubit.notifications.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: theme.dividerColor,
            ),
            itemBuilder: (context, index) {
              final notification = cubit.notifications[index];
              return _buildNotificationItem(
                  context, notification, theme, colorScheme);
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    NotificationModel notification,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final isUnread = notification.isRead == false;

    return Container(
      color: isUnread
          ? colorScheme.primary.withOpacity(0.05)
          : Colors.transparent,
      child: ListTile(
        leading: SizedBox(
          width: 48,
          height: 48,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: colorScheme.surfaceVariant,
                backgroundImage: notification.senderImage != null && notification.senderImage!.isNotEmpty
                    ? NetworkImage(notification.senderImage!)
                    : null,
                child: notification.senderImage == null || notification.senderImage!.isEmpty
                    ? Icon(Icons.person, color: colorScheme.outline)
                    : null,
              ),
              CircleAvatar(
                radius: 9,
                backgroundColor: theme.scaffoldBackgroundColor, 
                child: CircleAvatar(
                  radius: 7,
                  backgroundColor: _getIconColor(notification.type),
                  child: Icon(
                    _getIcon(notification.type),
                    color: Colors.white,
                    size: 9,
                  ),
                ),
              ),
            ],
          ),
        ),
        title: Text(
          notification.title ?? '',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          notification.body ?? '',
          style: theme.textTheme.bodySmall,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(notification.dateTime, context), 
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.outline,
                fontSize: 10,
              ),
            ),
            if (isUnread)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}