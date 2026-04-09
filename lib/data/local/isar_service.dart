import 'package:expense_tracker/data/local/schemas/category.dart';
import 'package:expense_tracker/data/local/schemas/expense.dart';
import 'package:expense_tracker/data/local/schemas/expected_income.dart';
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
        [ExpenseSchema, CategorySchema, ExpectedIncomeSchema],
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
          // Mock Income
          Expense()
            ..title = 'Freelance Project'
            ..amount = 500.00
            ..isIncome = true
            ..date = DateTime.now().subtract(const Duration(days: 4))
            ..category = 'Income',
          Expense()
            ..title = 'Client Retainer'
            ..amount = 1200.00
            ..isIncome = true
            ..date = DateTime.now().subtract(const Duration(days: 15))
            ..category = 'Income',
        ];
        await isar.expenses.putAll(expenses);
      });
      await isar.writeTxn(() async {
        final expectedIncomes = [
          ExpectedIncome()
             ..amount = 300.00
             ..sourceLabel = 'Pending Client'
             ..expectedDate = DateTime.now().subtract(const Duration(days: 4)), // Overdue
          ExpectedIncome()
             ..amount = 1000.00
             ..sourceLabel = 'Salary'
             ..expectedDate = DateTime.now().add(const Duration(days: 2)), // Upcoming
        ];
        await isar.expectedIncomes.putAll(expectedIncomes);
      });
    }
  }
}
