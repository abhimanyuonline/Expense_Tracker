import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/data/repositories/expense_provider.dart';
import 'package:expense_tracker/features/dashboard/providers/dashboard_providers.dart';
import 'package:expense_tracker/data/local/schemas/recurring_transaction.dart';

class UpcomingBillsStrip extends ConsumerWidget {
  const UpcomingBillsStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcomingBills = ref.watch(upcomingBillsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (upcomingBills.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Bills',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  'Swipe to pay',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: upcomingBills.length,
              itemBuilder: (context, index) {
                final bill = upcomingBills[index];
                return _buildBillCard(context, ref, bill, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillCard(BuildContext context, WidgetRef ref, RecurringTransaction bill, bool isDark) {
    final daysUntil = bill.nextDueDate.difference(DateTime.now()).inDays;
    
    Color urgencyColor;
    if (daysUntil <= 2) {
      urgencyColor = const Color(0xFFF87171); // Red
    } else if (daysUntil <= 7) {
      urgencyColor = const Color(0xFFFBBF24); // Amber
    } else {
      urgencyColor = const Color(0xFF10B981); // Green
    }

    return Dismissible(
      key: ValueKey('bill_${bill.id}'),
      direction: DismissDirection.up,
      onDismissed: (_) {
        ref.read(expenseRepositoryProvider)?.markBillAsPaid(bill.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Paid: ${bill.title}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: urgencyColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    bill.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Text(
                  '\$${bill.amount.toStringAsFixed(0)}',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: urgencyColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: urgencyColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                daysUntil == 0 ? 'Today' : (daysUntil == 1 ? 'Tomorrow' : 'In $daysUntil days'),
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: urgencyColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
