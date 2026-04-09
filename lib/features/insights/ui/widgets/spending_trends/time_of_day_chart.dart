import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expense_tracker/features/insights/providers/insights_providers.dart';

class TimeOfDaySpendChart extends ConsumerWidget {
  const TimeOfDaySpendChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeSpend = ref.watch(timeOfDaySpendProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bands = ['Morning', 'Afternoon', 'Evening', 'Night'];
    final colors = [
      const Color(0xFFFCD34D), // Morning - Yellow
      const Color(0xFFF97316), // Afternoon - Orange
      const Color(0xFF8B5CF6), // Evening - Purple
      const Color(0xFF1E3A8A), // Night - Blue
    ];

    double maxVal = 0;
    timeSpend.forEach((_, value) {
      if (value > maxVal) maxVal = value;
    });

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
          Text(
            'Time of Day',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                maxY: maxVal * 1.2 == 0 ? 100 : maxVal * 1.2,
                barTouchData: BarTouchData(enabled: false), // Disabled for simplicity
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            bands[value.toInt()],
                            style: GoogleFonts.outfit(
                              color: isDark ? Colors.white54 : Colors.black54,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(4, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: timeSpend[bands[index]] ?? 0.0,
                        color: colors[index],
                        width: 20,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
