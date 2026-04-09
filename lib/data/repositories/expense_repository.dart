import 'package:expense_tracker/data/local/schemas/expense.dart';
import 'package:expense_tracker/data/local/schemas/recurring_transaction.dart';
import 'package:isar/isar.dart';

class ExpenseRepository {
  final Isar isar;

  ExpenseRepository(this.isar);

  // Stream of all expenses sorted by date
  Stream<List<Expense>> watchExpenses() {
    return isar.expenses.where().sortByDateDesc().watch(fireImmediately: true);
  }

  // Add new expense
  Future<void> addExpense(Expense expense) async {
    await isar.writeTxn(() async {
      await isar.expenses.put(expense);
    });
  }

  // Delete expense
  Future<void> deleteExpense(int id) async {
    await isar.writeTxn(() async {
      await isar.expenses.delete(id);
    });
  }

  // Calculate total balance
  Future<double> getTotalBalance() async {
    final expenses = await isar.expenses.where().findAll();
    double total = 0.0;
    for (final expense in expenses) {
      total += expense.amount;
    }
    return total;
  }

  // Mark a recurring bill as paid
  Future<void> markBillAsPaid(int id) async {
    await isar.writeTxn(() async {
      final bill = await isar.recurringTransactions.get(id);
      if (bill != null) {
        bill.lastPaidDate = DateTime.now();
        bill.nextDueDate = bill.nextDueDate.add(Duration(days: bill.frequencyDays));
        await isar.recurringTransactions.put(bill);
        
        // Also create an actual expense entry for this payment
        final expense = Expense()
          ..title = bill.title
          ..amount = bill.amount
          ..date = DateTime.now()
          ..category = bill.category;
        await isar.expenses.put(expense);
      }
    });
  }
}
