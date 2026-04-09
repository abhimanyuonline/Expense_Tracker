import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expense_tracker/features/insights/providers/insights_providers.dart';
import 'package:expense_tracker/features/settings/providers/settings_provider.dart';

class IncomeSourcesBreakdown extends ConsumerWidget {
  const IncomeSourcesBreakdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomeSources = ref.watch(incomeSourcesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (incomeSources.isEmpty) return const SizedBox.shrink();

    final colors = [
      const Color(0xFF10B981),
      const Color(0xFF6366F1),
      const Color(0xFFFCD34D),
      const Color(0xFF8B5CF6),
    ];

    double total = incomeSources.values.fold(0, (a, b) => a + b);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
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
          Text(
            'Income Sources',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                sections: incomeSources.entries.toList().asMap().entries.map((entry) {
                  final dataEntry = entry.value;
                  double pct = total == 0 ? 0 : (dataEntry.value / total) * 100;
                  return PieChartSectionData(
                    color: colors[entry.key % colors.length],
                    value: dataEntry.value,
                    title: '${pct.toStringAsFixed(0)}%',
                    radius: 20,
                    titleStyle: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Legend
          ...incomeSources.entries.toList().asMap().entries.map((entry) {
            int idx = entry.key;
            var dataEntry = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 12, height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors[idx % colors.length],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      dataEntry.key,
                      style: GoogleFonts.outfit(
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                  Text(
                    ref.read(settingsProvider.notifier).formatAmount(dataEntry.value),
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
