import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/data/local/schemas/expense.dart';
import 'package:expense_tracker/data/repositories/expense_provider.dart';
import 'package:expense_tracker/features/settings/providers/settings_provider.dart';
import 'package:expense_tracker/presentation/widgets/glass_card.dart';

class SmartTransactionList extends ConsumerWidget {
  final List<Expense> expenses;

  const SmartTransactionList({super.key, required this.expenses});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (expenses.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Text(
              'No transactions yet.',
              style: GoogleFonts.outfit(color: Colors.grey),
            ),
          ),
        ),
      );
    }

    // Group expenses by date
    final groups = <String, List<Expense>>{};
    for (var expense in expenses) {
      final key = DateFormat('yyyy-MM-dd').format(expense.date);
      groups[key] ??= [];
      groups[key]!.add(expense);
    }

    final sortedKeys = groups.keys.toList()..sort((a, b) => b.compareTo(a));

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // This is a bit complex for a SliverChildBuilderDelegate if we want sticky headers
          // But for a simple grouped list without real "sticky" (which requires a more complex structure)
          // we can just intercalate headers.
          
          // Flatten the groups for the builder
          int currentIdx = 0;
          for (var dateKey in sortedKeys) {
            final groupItems = groups[dateKey]!;
            
            // Header
            if (currentIdx == index) {
              return _buildDateHeader(context, dateKey);
            }
            currentIdx++;
            
            // Items
            for (var item in groupItems) {
              if (currentIdx == index) {
                return _buildTransactionItem(context, ref, item);
              }
              currentIdx++;
            }
          }
          return const SizedBox.shrink();
        },
        childCount: sortedKeys.length + expenses.length,
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context, String dateKey) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final date = DateTime.parse(dateKey);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    
    String label;
    if (date == today) {
      label = 'Today';
    } else if (date == yesterday) {
      label = 'Yesterday';
    } else {
      label = DateFormat('MMMM d, y').format(date);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 12),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white38 : Colors.black38,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, WidgetRef ref, Expense expense) {
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Dismissible(
      key: ValueKey('tx_${expense.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF87171),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) {
        final repo = ref.read(expenseRepositoryProvider);
        if (repo != null) {
          repo.deleteExpense(expense.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Deleted ${expense.title}'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () => repo.addExpense(expense),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          opacity: isDark ? 0.03 : 0.05,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: _buildCategoryIcon(expense.category),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    expense.title,
                    style: GoogleFonts.outfit(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (expense.smsId != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'SMS',
                      style: GoogleFonts.outfit(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            subtitle: Text(
              expense.category,
              style: GoogleFonts.outfit(
                color: isDark ? Colors.white38 : Colors.black38,
                fontSize: 12,
              ),
            ),
            trailing: Text(
              '${expense.isIncome ? '+' : '-'}${settingsNotifier.formatAmount(expense.amount)}',
              style: GoogleFonts.outfit(
                color: expense.isIncome ? const Color(0xFF10B981) : const Color(0xFFF87171),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(String category) {
    IconData iconData;
    Color color;

    switch (category.toLowerCase()) {
      case 'food':
        iconData = Icons.restaurant_rounded;
        color = Colors.orange;
        break;
      case 'transport':
        iconData = Icons.directions_car_rounded;
        color = Colors.blue;
        break;
      case 'rent':
        iconData = Icons.home_rounded;
        color = Colors.purple;
        break;
      case 'bills':
        iconData = Icons.receipt_long_rounded;
        color = Colors.red;
        break;
      case 'shopping':
        iconData = Icons.shopping_bag_rounded;
        color = Colors.pink;
        break;
      case 'income':
        iconData = Icons.account_balance_wallet_rounded;
        color = Colors.green;
        break;
      default:
        iconData = Icons.category_rounded;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(iconData, color: color, size: 20),
    );
  }
}
