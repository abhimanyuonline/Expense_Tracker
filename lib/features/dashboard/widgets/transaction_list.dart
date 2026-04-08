import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/data/local/schemas/expense.dart';
import 'package:expense_tracker/presentation/widgets/glass_card.dart';
import 'package:expense_tracker/features/settings/providers/settings_provider.dart';

class TransactionList extends ConsumerWidget {
  final List<Expense> expenses;

  const TransactionList({super.key, required this.expenses});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(settingsProvider); // React to settings changes
    final settingsNotifier = ref.read(settingsProvider.notifier);
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final expense = expenses[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              opacity: 0.05,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF6366F1)),
                ),
                title: Text(
                  expense.title, 
                  style: GoogleFonts.outfit(color: textColor, fontWeight: FontWeight.w600)
                ),
                subtitle: Text(
                  settingsNotifier.formatDate(expense.date), 
                  style: GoogleFonts.outfit(color: isDark ? Colors.white38 : Colors.black38, fontSize: 12)
                ),
                trailing: Text(
                  '-${settingsNotifier.formatAmount(expense.amount)}',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFFF87171), 
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
              ),
            ),
          );
        },
        childCount: expenses.length,
      ),
    );
  }
}
