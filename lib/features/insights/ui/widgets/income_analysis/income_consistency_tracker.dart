import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/insights/providers/insights_providers.dart';
import 'package:fl_chart/fl_chart.dart';

class IncomeConsistencyTracker extends ConsumerWidget {
  const IncomeConsistencyTracker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consistency = ref.watch(incomeConsistencyProvider);
    final monthlyData = ref.watch(monthlyBarChartProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color labelColor = const Color(0xFF10B981); // Green for Stable
    if (consistency.label == 'Variable') labelColor = const Color(0xFFFCD34D); // Yellow
    if (consistency.label == 'Irregular') labelColor = const Color(0xFFFF7A7A); // Red

    // Sparkline for last 6 months
    final last6 = monthlyData.length > 6 ? monthlyData.sublist(monthlyData.length - 6) : monthlyData;
    double maxInc = 0;
    for (var m in last6) {
      if (m['income'] > maxInc) maxInc = m['income'];
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Income Consistency',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      consistency.label,
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: labelColor,
                      ),
                    ),
                    Text(
                      'Variation: ${(consistency.cv * 100).toStringAsFixed(1)}%',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              // Sparkline BarChart
              SizedBox(
                width: 120,
                height: 50,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceEvenly,
                    maxY: maxInc == 0 ? 100 : maxInc * 1.2,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: const FlTitlesData(show: false),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(last6.length, (index) {
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: last6[index]['income'],
                            color: labelColor.withOpacity(0.6),
                            width: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
