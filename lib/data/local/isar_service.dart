import 'package:expense_tracker/data/local/schemas/category.dart';
import 'package:expense_tracker/data/local/schemas/expense.dart';
import 'package:expense_tracker/data/local/schemas/expected_income.dart';
import 'package:expense_tracker/data/local/schemas/recurring_transaction.dart';
import 'package:expense_tracker/data/local/schemas/notification_item.dart';
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
        [
          ExpenseSchema,
          CategorySchema,
          ExpectedIncomeSchema,
          RecurringTransactionSchema,
          NotificationItemSchema,
        ],
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

    // Automatically re-seed if the database doesn't have the rich mock data yet
    if (expenseCount < 20) {
      await isar.writeTxn(() async {
        await isar.expenses.clear();
        await isar.expectedIncomes.clear();

        final now = DateTime.now();
        final expenses = [
          // Current Month
          Expense()..title = 'Starbucks'..amount = 5.50..date = now.subtract(const Duration(hours: 2))..category = 'Food',
          Expense()..title = 'Uber Ride'..amount = 15.00..date = now.subtract(const Duration(days: 1))..category = 'Transport',
          Expense()..title = 'Monthly Rent'..amount = 1200.00..date = now.subtract(const Duration(days: 5))..category = 'Rent',
          Expense()..title = 'Grocery Shopping'..amount = 85.20..date = now.subtract(const Duration(days: 2))..category = 'Food',
          Expense()..title = 'Netflix'..amount = 15.99..date = now.subtract(const Duration(days: 3))..category = 'Bills',
          Expense()..title = 'Amazon Order'..amount = 42.80..date = now.subtract(const Duration(days: 4))..category = 'Shopping',
          Expense()..title = 'Gym Membership'..amount = 49.00..date = now.subtract(const Duration(days: 6))..category = 'Health',
          Expense()..title = 'Freelance Project'..amount = 500.00..isIncome = true..date = now.subtract(const Duration(days: 4))..category = 'Income',
          Expense()..title = 'Client Retainer'..amount = 1200.00..isIncome = true..date = now.subtract(const Duration(days: 15))..category = 'Income',

          // Last Month
          Expense()..title = 'Monthly Rent'..amount = 1200.00..date = now.subtract(const Duration(days: 35))..category = 'Rent',
          Expense()..title = 'Grocery Shopping'..amount = 120.50..date = now.subtract(const Duration(days: 32))..category = 'Food',
          Expense()..title = 'Internet Bill'..amount = 60.00..date = now.subtract(const Duration(days: 45))..category = 'Bills',
          Expense()..title = 'Starbucks'..amount = 8.20..date = now.subtract(const Duration(days: 36))..category = 'Food',
          Expense()..title = 'Uber Ride'..amount = 22.00..date = now.subtract(const Duration(days: 38))..category = 'Transport',
          Expense()..title = 'Client Retainer'..amount = 1200.00..isIncome = true..date = now.subtract(const Duration(days: 45))..category = 'Income',
          Expense()..title = 'Bonus'..amount = 300.00..isIncome = true..date = now.subtract(const Duration(days: 40))..category = 'Income',

          // Two Months Ago
          Expense()..title = 'Monthly Rent'..amount = 1200.00..date = now.subtract(const Duration(days: 65))..category = 'Rent',
          Expense()..title = 'Grocery Shopping'..amount = 90.50..date = now.subtract(const Duration(days: 62))..category = 'Food',
          Expense()..title = 'Car Repair'..amount = 450.00..date = now.subtract(const Duration(days: 75))..category = 'Transport',
          Expense()..title = 'Client Retainer'..amount = 1200.00..isIncome = true..date = now.subtract(const Duration(days: 75))..category = 'Income',
        ];
        await isar.expenses.putAll(expenses);

        final expectedIncomes = [
          ExpectedIncome()
            ..amount = 300.00
            ..sourceLabel = 'Pending Client'
            ..expectedDate = now.subtract(const Duration(days: 4)), // Overdue
          ExpectedIncome()
            ..amount = 1000.00
            ..sourceLabel = 'Salary'
            ..expectedDate = now.add(const Duration(days: 2)), // Upcoming
        ];
        await isar.expectedIncomes.putAll(expectedIncomes);
      });
    }

    // Seed recurring transactions if none exist
    final billCount = await isar.recurringTransactions.count();
    if (billCount == 0) {
      final now = DateTime.now();
      await isar.writeTxn(() async {
        final bills = [
          RecurringTransaction()
            ..title = 'Monthly Rent'
            ..amount = 1200.00
            ..category = 'Rent'
            ..nextDueDate = DateTime(now.year, now.month + 1, 1)
            ..frequencyDays = 30,
          RecurringTransaction()
            ..title = 'Netflix'
            ..amount = 15.99
            ..category = 'Bills'
            ..nextDueDate = now.add(const Duration(days: 5))
            ..frequencyDays = 30,
          RecurringTransaction()
            ..title = 'Internet Bill'
            ..amount = 60.00
            ..category = 'Bills'
            ..nextDueDate = now.add(const Duration(days: 2))
            ..frequencyDays = 30,
          RecurringTransaction()
            ..title = 'Gym Membership'
            ..amount = 49.00
            ..category = 'Health'
            ..nextDueDate = now.add(const Duration(days: 12))
            ..frequencyDays = 30,
        ];
        await isar.recurringTransactions.putAll(bills);
      });
    }

    // Seed sample notifications if none exist
    final notifCount = await isar.notificationItems.count();
    if (notifCount == 0) {
      final now = DateTime.now();
      await isar.writeTxn(() async {
        final notifs = [
          NotificationItem()
            ..title = 'Budget Warning'
            ..message = 'You\'ve spent 90% of your Food budget this month.'
            ..type = NotificationType.budgetWarning
            ..timestamp = now.subtract(const Duration(hours: 1)),
          NotificationItem()
            ..title = 'Netflix due in 5 days'
            ..message = 'Netflix (\$15.99) is due on ${now.add(const Duration(days: 5)).day}/${now.month}.'
            ..type = NotificationType.upcomingBill
            ..timestamp = now.subtract(const Duration(hours: 2)),
          NotificationItem()
            ..title = 'SMS Transaction Detected'
            ..message = 'New expense via SMS: Uber Ride \$15.00.'
            ..type = NotificationType.smsTransaction
            ..timestamp = now.subtract(const Duration(hours: 3)),
        ];
        await isar.notificationItems.putAll(notifs);
      });
    }
  }
}
