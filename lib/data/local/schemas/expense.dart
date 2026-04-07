import 'package:isar/isar.dart';

part 'expense.g.dart';

@collection
class Expense {
  Id id = Isar.autoIncrement;

  late String title;
  late double amount;
  late DateTime date;
  late String category;
  
  String? description;
  
  bool isSynced = false;
  
  // For SMS parsing identification
  String? smsId;
}
