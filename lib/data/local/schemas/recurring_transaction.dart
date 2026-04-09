import 'package:isar/isar.dart';

part 'recurring_transaction.g.dart';

@collection
class RecurringTransaction {
  Id id = Isar.autoIncrement;

  late String title;
  late double amount;
  late String category;

  @Index()
  late DateTime nextDueDate;

  DateTime? lastPaidDate;

  /// How often this bill recurs in days (e.g. 30 for monthly, 7 for weekly)
  int frequencyDays = 30;

  bool isActive = true;
}
