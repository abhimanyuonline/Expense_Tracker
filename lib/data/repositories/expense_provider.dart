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
        if (!expense.isIncome) {
          total += expense.amount;
        }
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
        if (!expense.isIncome) {
          categoryTotals[expense.category] = (categoryTotals[expense.category] ?? 0) + expense.amount;
        }
      }
      return categoryTotals;
    },
    orElse: () => {},
  );
});

/// Groups last 7 days of expenses into [{dayIndex, amount, isToday}]
final sevenDaySpendProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final expenses = ref.watch(expenseListProvider).valueOrNull ?? [];
  final now = DateTime.now();
  final result = <Map<String, dynamic>>[];
  for (int i = 6; i >= 0; i--) {
    final day = now.subtract(Duration(days: i));
    final total = expenses
        .where((e) =>
            !e.isIncome &&
            e.date.year == day.year &&
            e.date.month == day.month &&
            e.date.day == day.day)
        .fold(0.0, (sum, e) => sum + e.amount);
    result.add({'dayIndex': 6 - i, 'amount': total, 'isToday': i == 0});
  }
  return result;
});

/// Total income this calendar month
final currentMonthIncomeProvider = Provider<double>((ref) {
  final expenses = ref.watch(expenseListProvider).valueOrNull ?? [];
  final now = DateTime.now();
  return expenses
      .where((e) => e.isIncome && e.date.year == now.year && e.date.month == now.month)
      .fold(0.0, (sum, e) => sum + e.amount);
});

/// Total spend this calendar month
final currentMonthSpendProvider = Provider<double>((ref) {
  final expenses = ref.watch(expenseListProvider).valueOrNull ?? [];
  final now = DateTime.now();
  return expenses
      .where((e) => !e.isIncome && e.date.year == now.year && e.date.month == now.month)
      .fold(0.0, (sum, e) => sum + e.amount);
});

/// Top 4 merchants by spend this month, sorted descending
final topMerchantsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final expenses = ref.watch(expenseListProvider).valueOrNull ?? [];
  final now = DateTime.now();
  final Map<String, double> merchants = {};
  final Map<String, bool> smsParsed = {};
  for (final e in expenses) {
    if (!e.isIncome && e.date.year == now.year && e.date.month == now.month) {
      merchants[e.title] = (merchants[e.title] ?? 0.0) + e.amount;
      if (e.smsId != null) smsParsed[e.title] = true;
    }
  }
  final sorted = merchants.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return sorted.take(4).map((entry) => {
    'merchant': entry.key,
    'amount': entry.value,
    'isSms': smsParsed[entry.key] ?? false,
  }).toList();
});
