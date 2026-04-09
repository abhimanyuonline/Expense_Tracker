import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/dashboard/providers/dashboard_providers.dart';
import 'package:expense_tracker/data/local/schemas/notification_item.dart';
import 'package:expense_tracker/data/local/isar_provider.dart';
import 'package:isar/isar.dart';

class NotificationBell extends ConsumerWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadNotificationsCountProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        IconButton(
          icon: Icon(
            Icons.notifications_none_rounded,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
          onPressed: () => _showNotificationSheet(context),
        ),
        if (unreadCount > 0)
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: const Color(0xFFF87171),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
              ),
              constraints: const BoxConstraints(minWidth: 10, minHeight: 10),
            ),
          ),
      ],
    );
  }

  void _showNotificationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NotificationSheet(),
    );
  }
}

class NotificationSheet extends ConsumerWidget {
  const NotificationSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notifications',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _markAllAsRead(ref),
                      child: Text(
                        'Clear All',
                        style: GoogleFonts.outfit(color: const Color(0xFF6366F1)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: notificationsAsync.when(
                  data: (notifications) {
                    if (notifications.isEmpty) {
                      return Center(
                        child: Text(
                          'No notifications yet',
                          style: GoogleFonts.outfit(color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final item = notifications[index];
                        return _buildNotificationItem(context, ref, item, isDark);
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(child: Text('Error: $e')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem(BuildContext context, WidgetRef ref, NotificationItem item, bool isDark) {
    IconData iconData;
    Color color;

    switch (item.type) {
      case NotificationType.budgetWarning:
        iconData = Icons.warning_amber_rounded;
        color = const Color(0xFFFBBF24);
        break;
      case NotificationType.upcomingBill:
        iconData = Icons.receipt_long_rounded;
        color = const Color(0xFF6366F1);
        break;
      case NotificationType.smsTransaction:
        iconData = Icons.message_rounded;
        color = const Color(0xFF10B981);
        break;
    }

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(iconData, color: color, size: 20),
      ),
      title: Text(
        item.title,
        style: GoogleFonts.outfit(
          fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: Text(
        item.message,
        style: GoogleFonts.outfit(
          color: isDark ? Colors.white54 : Colors.black54,
          fontSize: 13,
        ),
      ),
      trailing: !item.isRead 
        ? Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFF87171), shape: BoxShape.circle))
        : null,
      onTap: () => _markAsRead(ref, item),
    );
  }

  void _markAsRead(WidgetRef ref, NotificationItem item) async {
    final isar = await ref.read(isarDbProvider.future);
    await isar.writeTxn(() async {
      final fresh = await isar.notificationItems.get(item.id);
      if (fresh != null) {
        fresh.isRead = true;
        await isar.notificationItems.put(fresh);
      }
    });
  }

  void _markAllAsRead(WidgetRef ref) async {
    final isar = await ref.read(isarDbProvider.future);
    await isar.writeTxn(() async {
      final unread = await isar.notificationItems.filter().isReadEqualTo(false).findAll();
      for (var item in unread) {
        item.isRead = true;
      }
      await isar.notificationItems.putAll(unread);
    });
  }
}
