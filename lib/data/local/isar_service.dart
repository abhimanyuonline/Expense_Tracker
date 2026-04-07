import 'package:expense_tracker/data/local/schemas/category.dart';
import 'package:expense_tracker/data/local/schemas/expense.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDb();
  }

  Future<Isar> openDb() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      final isar = await Isar.open(
        [ExpenseSchema, CategorySchema],
        inspector: true,
        directory: dir.path,
      );
      await _seedData(isar);
      return isar;
    }
    return Isar.getInstance()!;
  }

  Future<void> _seedData(Isar isar) async {
    final expenseCount = await isar.expenses.count();
    if (expenseCount == 0) {
      await isar.writeTxn(() async {
        final expenses = [
          Expense()
            ..title = 'Starbucks Coffee'
            ..amount = 5.50
            ..date = DateTime.now().subtract(const Duration(hours: 2))
            ..category = 'Food',
          Expense()
            ..title = 'Uber Ride'
            ..amount = 15.00
            ..date = DateTime.now().subtract(const Duration(days: 1))
            ..category = 'Travel',
          Expense()
            ..title = 'Monthly Rent'
            ..amount = 1200.00
            ..date = DateTime.now().subtract(const Duration(days: 5))
            ..category = 'Rent',
          Expense()
            ..title = 'Grocery Shopping'
            ..amount = 85.20
            ..date = DateTime.now().subtract(const Duration(days: 2))
            ..category = 'Food',
        ];
        await isar.expenses.putAll(expenses);
      });
    }
  }
}
