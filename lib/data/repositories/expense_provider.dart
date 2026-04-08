import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/data/local/isar_provider.dart';
import 'package:expense_tracker/data/repositories/expense_repository.dart';
import 'package:expense_tracker/data/local/schemas/expense.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository?>((ref) {
  final isarAsync = ref.watch(isarDbProvider);
  return isarAsync.when(
    data: (isar) => ExpenseRepository(isar),
    loading: () => null,
    error: (_, __) => null,
  );
});

final expenseListProvider = StreamProvider<List<Expense>>((ref) {
  final repo = ref.watch(expenseRepositoryProvider);
  if (repo == null) return const Stream.empty();
  return repo.watchExpenses();
});

final totalBalanceProvider = Provider<double>((ref) {
  final expensesAsync = ref.watch(expenseListProvider);
  return expensesAsync.maybeWhen(
    data: (expenses) {
      double total = 0.0;
      for (final expense in expenses) {
        total += expense.amount;
      }
      return total;
    },
    orElse: () => 0.0,
  );
});

final expenseCategoryTotalsProvider = Provider<Map<String, double>>((ref) {
  final expensesAsync = ref.watch(expenseListProvider);
  return expensesAsync.maybeWhen(
    data: (expenses) {
      final Map<String, double> categoryTotals = {};
      for (var expense in expenses) {
        categoryTotals[expense.category] = (categoryTotals[expense.category] ?? 0) + expense.amount;
      }
      return categoryTotals;
    },
    orElse: () => {},
  );
});
