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
    // Seed categories first — they drive budget rings
    final catCount = await isar.categorys.count();
    if (catCount == 0) {
      await isar.writeTxn(() async {
        final categories = [
          Category()
            ..name = 'Food'
            ..iconCode = 0xe533 // Icons.restaurant_rounded
            ..colorValue = 0xFFFB923C // orange
            ..budgetCap = 450.0,
          Category()
            ..name = 'Transport'
            ..iconCode = 0xe1b9 // Icons.directions_car_rounded
            ..colorValue = 0xFF60A5FA // blue
            ..budgetCap = 200.0,
          Category()
            ..name = 'Rent'
            ..iconCode = 0xe318 // Icons.home_rounded
            ..colorValue = 0xFFA78BFA // purple
            ..budgetCap = 1500.0,
          Category()
            ..name = 'Bills'
            ..iconCode = 0xe891 // Icons.receipt_long_rounded
            ..colorValue = 0xFFF87171 // red
            ..budgetCap = 300.0,
          Category()
            ..name = 'Shopping'
            ..iconCode = 0xe549 // Icons.shopping_bag_rounded
            ..colorValue = 0xFFF472B6 // pink
            ..budgetCap = 250.0,
          Category()
            ..name = 'Health'
            ..iconCode = 0xe3f3 // Icons.favorite_rounded
            ..colorValue = 0xFF34D399 // emerald
            ..budgetCap = 150.0,
          Category()
            ..name = 'Income'
            ..iconCode = 0xe14c // Icons.account_balance_wallet_rounded
            ..colorValue = 0xFF4ADE80 // green
            ..budgetCap = null,
          Category()
            ..name = 'Entertainment'
            ..iconCode = 0xe87f // Icons.movie_rounded
            ..colorValue = 0xFFFACC15 // yellow
            ..budgetCap = 100.0,
          Category()
            ..name = 'Savings'
            ..iconCode = 0xe6c4 // Icons.savings_rounded
            ..colorValue = 0xFF38BDF8 // sky
            ..budgetCap = 500.0,
        ];
        await isar.categorys.putAll(categories);
      });
    }

    // Seed rich expense history if not enough data
    final expenseCount = await isar.expenses.count();
    if (expenseCount < 25) {
      await isar.writeTxn(() async {
        await isar.expenses.clear();

        final now = DateTime.now();

        // Helper to create a date N days ago at a specific hour
        DateTime daysAgo(int days, {int hour = 12}) =>
            DateTime(now.year, now.month, now.day - days, hour);

        final expenses = [
          // ── This week ──
          Expense()
            ..title = 'Starbucks Coffee'
            ..amount = 5.50
            ..date = daysAgo(0, hour: 8)
            ..category = 'Food',
          Expense()
            ..title = 'Uber Ride'
            ..amount = 15.00
            ..date = daysAgo(1, hour: 9)
            ..category = 'Transport',
          Expense()
            ..title = 'Lunch – Chipotle'
            ..amount = 12.75
            ..date = daysAgo(1, hour: 13)
            ..category = 'Food',
          Expense()
            ..title = 'Grocery Shopping'
            ..amount = 85.20
            ..date = daysAgo(2, hour: 18)
            ..category = 'Food',
          Expense()
            ..title = 'Metro Pass'
            ..amount = 30.00
            ..date = daysAgo(3, hour: 7)
            ..category = 'Transport',

          // ── Earlier this month ──
          Expense()
            ..title = 'Monthly Rent'
            ..amount = 1200.00
            ..date = daysAgo(5, hour: 10)
            ..category = 'Rent',
          Expense()
            ..title = 'Netflix Subscription'
            ..amount = 15.99
            ..date = daysAgo(6, hour: 14)
            ..category = 'Bills',
          Expense()
            ..title = 'Amazon Order'
            ..amount = 42.80
            ..date = daysAgo(7, hour: 16)
            ..category = 'Shopping',
          Expense()
            ..title = 'Gym Membership'
            ..amount = 49.00
            ..date = daysAgo(8, hour: 7)
            ..category = 'Health',
          Expense()
            ..title = 'Electric Bill'
            ..amount = 75.00
            ..date = daysAgo(9, hour: 11)
            ..category = 'Bills',
          Expense()
            ..title = 'Nike Shoes'
            ..amount = 110.00
            ..date = daysAgo(10, hour: 15)
            ..category = 'Shopping',
          Expense()
            ..title = 'Doctor Visit'
            ..amount = 60.00
            ..date = daysAgo(12, hour: 10)
            ..category = 'Health',
          Expense()
            ..title = 'Spotify'
            ..amount = 9.99
            ..date = daysAgo(13, hour: 9)
            ..category = 'Bills',
          Expense()
            ..title = 'Cinema Night'
            ..amount = 28.50
            ..date = daysAgo(14, hour: 20)
            ..category = 'Entertainment',

          // ── Income this month ──
          Expense()
            ..title = 'Freelance Project'
            ..amount = 500.00
            ..isIncome = true
            ..date = daysAgo(4, hour: 11)
            ..category = 'Income',
          Expense()
            ..title = 'Client Retainer'
            ..amount = 2000.00
            ..isIncome = true
            ..date = daysAgo(15, hour: 10)
            ..category = 'Income',

          // ── Last month ──
          Expense()
            ..title = 'Monthly Rent'
            ..amount = 1200.00
            ..date = daysAgo(35, hour: 10)
            ..category = 'Rent',
          Expense()
            ..title = 'Grocery Shopping'
            ..amount = 120.50
            ..date = daysAgo(32, hour: 18)
            ..category = 'Food',
          Expense()
            ..title = 'Internet Bill'
            ..amount = 60.00
            ..date = daysAgo(40, hour: 9)
            ..category = 'Bills',
          Expense()
            ..title = 'Starbucks'
            ..amount = 8.20
            ..date = daysAgo(36, hour: 8)
            ..category = 'Food',
          Expense()
            ..title = 'Uber Ride'
            ..amount = 22.00
            ..date = daysAgo(38, hour: 7)
            ..category = 'Transport',
          Expense()
            ..title = 'H&M Jacket'
            ..amount = 79.90
            ..date = daysAgo(42, hour: 15)
            ..category = 'Shopping',
          Expense()
            ..title = 'Client Retainer'
            ..amount = 2000.00
            ..isIncome = true
            ..date = daysAgo(45, hour: 10)
            ..category = 'Income',
          Expense()
            ..title = 'Bonus'
            ..amount = 500.00
            ..isIncome = true
            ..date = daysAgo(40, hour: 12)
            ..category = 'Income',

          // ── Two months ago ──
          Expense()
            ..title = 'Monthly Rent'
            ..amount = 1200.00
            ..date = daysAgo(65, hour: 10)
            ..category = 'Rent',
          Expense()
            ..title = 'Grocery Shopping'
            ..amount = 90.50
            ..date = daysAgo(62, hour: 18)
            ..category = 'Food',
          Expense()
            ..title = 'Car Repair'
            ..amount = 450.00
            ..date = daysAgo(70, hour: 11)
            ..category = 'Transport',
          Expense()
            ..title = 'PlayStation Game'
            ..amount = 59.99
            ..date = daysAgo(68, hour: 20)
            ..category = 'Entertainment',
          Expense()
            ..title = 'Dentist Visit'
            ..amount = 150.00
            ..date = daysAgo(72, hour: 14)
            ..category = 'Health',
          Expense()
            ..title = 'Client Retainer'
            ..amount = 2000.00
            ..isIncome = true
            ..date = daysAgo(75, hour: 10)
            ..category = 'Income',
          Expense()
            ..title = 'Side Project Income'
            ..amount = 350.00
            ..isIncome = true
            ..date = daysAgo(60, hour: 11)
            ..category = 'Income',
        ];

        await isar.expenses.putAll(expenses);

        final expectedIncomes = [
          ExpectedIncome()
            ..amount = 300.00
            ..sourceLabel = 'Pending Client'
            ..expectedDate = now.subtract(const Duration(days: 4)), // Overdue
          ExpectedIncome()
            ..amount = 2000.00
            ..sourceLabel = 'Client Retainer'
            ..expectedDate = now.add(const Duration(days: 14)), // Upcoming
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
          RecurringTransaction()
            ..title = 'Spotify'
            ..amount = 9.99
            ..category = 'Bills'
            ..nextDueDate = now.add(const Duration(days: 1))
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
            ..message = "You've spent 90% of your Food budget this month."
            ..type = NotificationType.budgetWarning
            ..timestamp = now.subtract(const Duration(hours: 1)),
          NotificationItem()
            ..title = 'Netflix due in 5 days'
            ..message =
                'Netflix (\$15.99) is due on ${now.add(const Duration(days: 5)).day}/${now.month}.'
            ..type = NotificationType.upcomingBill
            ..timestamp = now.subtract(const Duration(hours: 2)),
          NotificationItem()
            ..title = 'Spotify due tomorrow'
            ..message =
                'Spotify (\$9.99) is due tomorrow. Make sure your balance is ready.'
            ..type = NotificationType.upcomingBill
            ..timestamp = now.subtract(const Duration(hours: 4)),
          NotificationItem()
            ..title = 'SMS Transaction Detected'
            ..message = 'New expense via SMS: Uber Ride \$15.00.'
            ..type = NotificationType.smsTransaction
            ..timestamp = now.subtract(const Duration(hours: 6)),
        ];
        await isar.notificationItems.putAll(notifs);
      });
    }
  }
}
