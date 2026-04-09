import 'package:isar/isar.dart';

part 'expected_income.g.dart';

@collection
class ExpectedIncome {
  Id id = Isar.autoIncrement;

  late double amount;
  late String sourceLabel;
  late DateTime expectedDate;
  
  bool isMatched = false;
  
  DateTime? matchedDate;
}
