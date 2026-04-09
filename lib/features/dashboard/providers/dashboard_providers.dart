import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/data/local/isar_provider.dart';
import 'package:expense_tracker/data/local/schemas/recurring_transaction.dart';
import 'package:expense_tracker/data/local/schemas/notification_item.dart';
import 'package:expense_tracker/data/repositories/expense_provider.dart';
import 'package:expense_tracker/features/insights/providers/insights_providers.dart';
import 'package:isar/isar.dart';

// ------------- 1. Recurring Bills -------------
final recurringTransactionListProvider = StreamProvider<List<RecurringTransaction>>((ref) {
  final isarAsync = ref.watch(isarDbProvider);
  return isarAsync.when(
    data: (isar) => isar.collection<RecurringTransaction>().where().watch(fireImmediately: true),
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

final upcomingBillsProvider = Provider<List<RecurringTransaction>>((ref) {
  final bills = ref.watch(recurringTransactionListProvider).valueOrNull ?? [];
  final now = DateTime.now();
  final threshold = now.add(const Duration(days: 14));
  
  final upcoming = bills.where((b) {
    return b.isActive && b.nextDueDate.isBefore(threshold);
  }).toList();
  
  upcoming.sort((a, b) => a.nextDueDate.compareTo(b.nextDueDate));
  return upcoming;
});

// ------------- 2. Notifications -------------
final notificationListProvider = StreamProvider<List<NotificationItem>>((ref) {
  final isarAsync = ref.watch(isarDbProvider);
  return isarAsync.when(
    data: (isar) => isar.collection<NotificationItem>().where().sortByTimestampDesc().watch(fireImmediately: true),
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationListProvider).valueOrNull ?? [];
  return notifications.where((n) => !n.isRead).length;
});

// ------------- 3. Budget Rings -------------
class BudgetRingData {
  final String title;
  final double spent;
  final double limit;
  final bool isOverspentWarning;

  BudgetRingData({
    required this.title,
    required this.spent,
    required this.limit,
    this.isOverspentWarning = false,
  });

  double get percentage => limit > 0 ? (spent / limit).clamp(0.0, double.infinity) : 0.0;
}

final budgetProgressProvider = Provider<List<BudgetRingData>>((ref) {
  final categories = ref.watch(categoryListProvider).valueOrNull ?? [];
  final monthlySpend = ref.watch(currentMonthSpendProvider);
  
  // 1. Overall Monthly Budget
  // Assuming a static global budget for demo purposes, or we could sum category caps
  double totalBudgetCap = categories.fold(0.0, (sum, c) => sum + (c.budgetCap ?? 0.0));
  if (totalBudgetCap == 0) totalBudgetCap = 2000.0; // Default mock budget

  // 2. Savings Goal
  // Mock savings goal progress
  final monthlyIncome = ref.watch(currentMonthIncomeProvider);
  final saved = monthlyIncome - monthlySpend;
  final savingsGoal = monthlyIncome * 0.20; // Goal: Save 20% of income

  // 3. Top Overspent Category
  final warnings = ref.watch(overspendWarningProvider);
  BudgetRingData? worstCategory;
  if (warnings.isNotEmpty) {
    warnings.sort((a, b) => (b.spent / b.cap).compareTo(a.spent / a.cap));
    final worst = warnings.first;
    worstCategory = BudgetRingData(
      title: worst.category,
      spent: worst.spent,
      limit: worst.cap,
      isOverspentWarning: true,
    );
  } else {
     // No warnings, pick highest spend category
     final highestCatOpt = ref.watch(expenseCategoryTotalsProvider);
      if (highestCatOpt.isNotEmpty) {
        final sorted = highestCatOpt.entries.toList()..sort((a,b)=>b.value.compareTo(a.value));
        final topCatName = sorted.first.key;
        final topCatSpend = sorted.first.value;
        
        // Find matching category object or take the first available
        final matches = categories.where((c) => c.name == topCatName);
        final catObj = matches.isNotEmpty 
            ? matches.first 
            : (categories.isNotEmpty ? categories.first : null);
        
        final cap = (catObj != null) ? (catObj.budgetCap ?? topCatSpend * 1.5) : topCatSpend * 1.5;
        worstCategory = BudgetRingData(
          title: topCatName,
          spent: topCatSpend,
          limit: cap > 0 ? cap : 1000,
        );
      }
  }

  return [
    BudgetRingData(title: 'Monthly Budget', spent: monthlySpend, limit: totalBudgetCap),
    if (worstCategory != null) worstCategory,
    BudgetRingData(title: 'Savings Goal', spent: saved > 0 ? saved : 0, limit: savingsGoal > 0 ? savingsGoal : 500),
  ];
});
