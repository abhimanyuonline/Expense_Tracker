import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/data/repositories/expense_provider.dart';
import 'package:expense_tracker/data/local/schemas/expense.dart';
import 'package:expense_tracker/data/local/schemas/category.dart';
import 'package:expense_tracker/data/local/schemas/expected_income.dart';
import 'package:expense_tracker/data/local/isar_provider.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:isar/isar.dart';

// ------------- Helper Providers -------------
final categoryListProvider = StreamProvider<List<Category>>((ref) {
  final isarAsync = ref.watch(isarDbProvider);
  return isarAsync.when(
    data: (isar) => isar.collection<Category>().where().watch(fireImmediately: true),
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

final expectedIncomeListProvider = StreamProvider<List<ExpectedIncome>>((ref) {
  final isarAsync = ref.watch(isarDbProvider);
  return isarAsync.when(
    data: (isar) => isar.collection<ExpectedIncome>().where().watch(fireImmediately: true),
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

// Used to filter insights (e.g. 'This Month', 'This Week')
final selectedPeriodProvider = StateProvider<String>((ref) => 'This Month');

// ------------- 1. Smart Summary Cards -------------

final topInsightProvider = Provider<String>((ref) {
  final expenses = ref.watch(expenseListProvider).valueOrNull ?? [];
  if (expenses.isEmpty) return "No data yet. Start tracking!";
  
  // Example logic: Find largest transaction this week
  final now = DateTime.now();
  final recentExpenses = expenses.where((e) => !e.isIncome && now.difference(e.date).inDays <= 7).toList();
  if (recentExpenses.isEmpty) return "You're on track! No major spending lately.";
  
  recentExpenses.sort((a, b) => b.amount.compareTo(a.amount));
  final largest = recentExpenses.first;
  
  return "Large transaction recently: \$${largest.amount.toStringAsFixed(2)} on ${largest.category}.";
});

class SpendComparison {
  final double currentAmount;
  final double previousAmount;
  final double percentageChange;

  SpendComparison(this.currentAmount, this.previousAmount, this.percentageChange);
}

final spendVsLastPeriodProvider = Provider<SpendComparison>((ref) {
  final expenses = ref.watch(expenseListProvider).valueOrNull ?? [];
  final period = ref.watch(selectedPeriodProvider);
  
  final now = DateTime.now();
  double currentAmount = 0.0;
  double previousAmount = 0.0;
  
  for (final exp in expenses.where((e) => !e.isIncome)) {
    if (period == 'This Month') {
      if (exp.date.year == now.year && exp.date.month == now.month) {
        currentAmount += exp.amount;
      } else if (exp.date.year == now.year && exp.date.month == now.month - 1) { // Simplistic prev month
        previousAmount += exp.amount;
      }
    }
  }
  
  double pct = 0.0;
  if (previousAmount > 0) {
    pct = ((currentAmount - previousAmount) / previousAmount) * 100;
  }
  
  return SpendComparison(currentAmount, previousAmount, pct);
});

final bestSavingDayProvider = Provider<Map<String, dynamic>?>((ref) {
  final expenses = ref.watch(expenseListProvider).valueOrNull ?? [];
  if (expenses.isEmpty) return null;
  
  final Map<String, double> dailySpend = {};
  for (final exp in expenses.where((e) => !e.isIncome)) {
    final dateKey = DateFormat('yyyy-MM-dd').format(exp.date);
    dailySpend[dateKey] = (dailySpend[dateKey] ?? 0.0) + exp.amount;
  }
  
  if (dailySpend.isEmpty) return null;
  
  var bestDate = dailySpend.keys.first;
  var lowestAmount = dailySpend[bestDate]!;
  
  dailySpend.forEach((date, amount) {
    if (amount < lowestAmount) {
      lowestAmount = amount;
      bestDate = date;
    }
  });
  
  return {'date': bestDate, 'amount': lowestAmount};
});

class OverspendWarning {
  final String category;
  final double spent;
  final double cap;
  OverspendWarning(this.category, this.spent, this.cap);
}

final overspendWarningProvider = Provider<List<OverspendWarning>>((ref) {
  final expenses = ref.watch(expenseListProvider).valueOrNull ?? [];
  final categories = ref.watch(categoryListProvider).valueOrNull ?? [];
  
  final Map<String, double> catSpent = {};
  for (final exp in expenses.where((e) => !e.isIncome)) {
    catSpent[exp.category] = (catSpent[exp.category] ?? 0.0) + exp.amount;
  }
  
  final warnings = <OverspendWarning>[];
  for (final cat in categories) {
    if (cat.budgetCap != null && cat.budgetCap! > 0) {
      final spent = catSpent[cat.name] ?? 0.0;
      if (spent >= cat.budgetCap! * 0.9) { // Warning if within 10%
        warnings.add(OverspendWarning(cat.name, spent, cat.budgetCap!));
      }
    }
  }
  
  return warnings;
});

// ------------- 2. Spending Trends -------------

final monthlyBarChartProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final expenses = ref.watch(expenseListProvider).valueOrNull ?? [];
  final Map<int, Map<String, double>> grouped = {};
  
  // Group by month
  for (final exp in expenses) {
    final month = exp.date.month;
    grouped[month] ??= {'expense': 0.0, 'income': 0.0};
    if (exp.isIncome) {
      grouped[month]!['income'] = (grouped[month]!['income']!) + exp.amount;
    } else {
      grouped[month]!['expense'] = (grouped[month]!['expense']!) + exp.amount;
    }
  }
  
  final result = <Map<String, dynamic>>[];
  for (int m = 1; m <= 12; m++) {
    result.add({
      'month': m,
      'expense': grouped[m]?['expense'] ?? 0.0,
      'income': grouped[m]?['income'] ?? 0.0,
    });
  }
  return result;
});

final timeOfDaySpendProvider = Provider<Map<String, double>>((ref) {
  final expenses = ref.watch(expenseListProvider).valueOrNull ?? [];
  final map = {
    'Morning': 0.0,
    'Afternoon': 0.0,
    'Evening': 0.0,
    'Night': 0.0,
  };
  
  for (final exp in expenses.where((e) => !e.isIncome)) {
    final h = exp.date.hour;
    if (h >= 6 && h < 12) map['Morning'] = map['Morning']! + exp.amount;
    else if (h >= 12 && h < 18) map['Afternoon'] = map['Afternoon']! + exp.amount;
    else if (h >= 18 && h < 22) map['Evening'] = map['Evening']! + exp.amount;
    else map['Night'] = map['Night']! + exp.amount;
  }
  
  return map;
});

final dayOfWeekHeatmapProvider = Provider<Map<int, double>>((ref) {
  final expenses = ref.watch(expenseListProvider).valueOrNull ?? [];
  final map = <int, double>{};
  for (int i = 1; i <= 7; i++) map[i] = 0.0;
  
  for (final exp in expenses.where((e) => !e.isIncome)) {
    final wd = exp.date.weekday;
    map[wd] = map[wd]! + exp.amount;
  }
  return map;
});

// ------------- 3. Income Analysis -------------

final incomeSourcesProvider = Provider<Map<String, double>>((ref) {
  final expenses = ref.watch(expenseListProvider).valueOrNull ?? [];
  final map = <String, double>{};
  
  for (final exp in expenses.where((e) => e.isIncome)) {
    map[exp.category] = (map[exp.category] ?? 0.0) + exp.amount;
  }
  return map;
});

class IncomeConsistency {
  final String label;
  final double cv;
  IncomeConsistency(this.label, this.cv);
}

final incomeConsistencyProvider = Provider<IncomeConsistency>((ref) {
  final monthly = ref.watch(monthlyBarChartProvider);
  final List<double> incomes = monthly.map((m) => m['income'] as double).where((i) => i > 0).toList();
  
  if (incomes.isEmpty) return IncomeConsistency("No Data", 0);
  
  final mean = incomes.reduce((a, b) => a + b) / incomes.length;
  if (mean == 0) return IncomeConsistency("Variable", 0);
  
  final variance = incomes.map((i) => pow(i - mean, 2)).reduce((a, b) => a + b) / incomes.length;
  final stdDev = sqrt(variance);
  
  final cv = stdDev / mean;
  
  String label = "Irregular";
  if (cv < 0.10) label = "Stable";
  else if (cv <= 0.30) label = "Variable";
  
  return IncomeConsistency(label, cv);
});

final pendingIncomeAlertsProvider = Provider<List<ExpectedIncome>>((ref) {
  final pending = ref.watch(expectedIncomeListProvider).valueOrNull ?? [];
  final List<ExpectedIncome> alerts = [];
  
  final now = DateTime.now();
  for (final inc in pending) {
    if (!inc.isMatched) {
      if (now.difference(inc.expectedDate).inDays >= 3) {
        alerts.add(inc);
      }
    }
  }
  
  alerts.sort((a, b) => a.expectedDate.compareTo(b.expectedDate));
  return alerts;
});
