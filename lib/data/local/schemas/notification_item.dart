import 'package:isar/isar.dart';

part 'notification_item.g.dart';

/// Type of notification — used for grouping in the bell sheet
enum NotificationType { budgetWarning, upcomingBill, smsTransaction }

@collection
class NotificationItem {
  Id id = Isar.autoIncrement;

  late String title;
  late String message;

  @Enumerated(EnumType.name)
  late NotificationType type;

  @Index()
  late DateTime timestamp;

  bool isRead = false;
}
