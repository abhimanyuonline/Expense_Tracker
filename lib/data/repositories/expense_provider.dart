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
