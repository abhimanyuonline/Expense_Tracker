import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/insights/providers/insights_providers.dart';
import 'package:expense_tracker/features/settings/providers/settings_provider.dart';
import 'package:intl/intl.dart';

class PendingIncomeTracker extends ConsumerStatefulWidget {
  const PendingIncomeTracker({super.key});

  @override
  ConsumerState<PendingIncomeTracker> createState() => _PendingIncomeTrackerState();
}

class _PendingIncomeTrackerState extends ConsumerState<PendingIncomeTracker> {
  @override
  void initState() {
    super.initState();
    // Simulate checking and firing a local notification for overdue income.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mockFireNotificationCheck();
    });
  }
  
  void _mockFireNotificationCheck() {
    // In a real implementation we would call flutter_local_notifications plugin here.
    // For this milestone, we represent the trigger with a SnackBar logic simulation.
    final alerts = ref.read(pendingIncomeAlertsProvider);
    if (alerts.isNotEmpty) {
      debugPrint("MOCK LOCAL NOTIFICATION TRIGERRED: You have ${alerts.length} overdue expected incomes.");
    }
  }

  @override
  Widget build(BuildContext context) {
    // This utilizes the same pendingIncomeAlertsProvider representing incomplete `ExpectedIncome`s
    final alerts = ref.watch(pendingIncomeAlertsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (alerts.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.pending_actions, color: Color(0xFFF59E0B), size: 20),
              const SizedBox(width: 8),
              Text(
                'Pending Expected Income',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...alerts.map((income) {
            final daysOverdue = DateTime.now().difference(income.expectedDate).inDays;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            income.sourceLabel,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Expected: ${DateFormat('MMM d').format(income.expectedDate)}',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: isDark ? Colors.white54 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          ref.read(settingsProvider.notifier).formatAmount(income.amount),
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: daysOverdue > 0 ? const Color(0xFFFF7A7A).withOpacity(0.1) : const Color(0xFF6366F1).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            daysOverdue > 0 ? '$daysOverdue days late' : 'Upcoming',
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: daysOverdue > 0 ? const Color(0xFFFF7A7A) : const Color(0xFF6366F1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
