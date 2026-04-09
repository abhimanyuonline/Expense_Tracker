import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expense_tracker/features/insights/providers/insights_providers.dart';

class IncomeVsExpenseRatio extends ConsumerWidget {
  const IncomeVsExpenseRatio({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyData = ref.watch(monthlyBarChartProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final incomeSpots = <FlSpot>[];
    final expenseSpots = <FlSpot>[];
    
    for (var i = 0; i < monthlyData.length; i++) {
       incomeSpots.add(FlSpot(i.toDouble(), monthlyData[i]['income'] as double));
       expenseSpots.add(FlSpot(i.toDouble(), monthlyData[i]['expense'] as double));
    }

    double maxY = 0;
    for (var spot in incomeSpots) { if (spot.y > maxY) maxY = spot.y; }
    for (var spot in expenseSpots) { if (spot.y > maxY) maxY = spot.y; }

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
            'Income vs Expense',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                lineTouchData: const LineTouchData(enabled: false), // Disabled to focus on visual overlapping
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark ? Colors.white10 : Colors.black12,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            (value + 1).toInt().toString(),
                            style: GoogleFonts.outfit(
                              color: isDark ? Colors.white54 : Colors.black54,
                              fontSize: 12,
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
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: maxY * 1.2 == 0 ? 100 : maxY * 1.2,
                lineBarsData: [
                  LineChartBarData(
                    spots: incomeSpots,
                    isCurved: true,
                    color: const Color(0xFF10B981), // Teal/Green Income
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF10B981).withOpacity(0.3),
                    ),
                  ),
                  LineChartBarData(
                    spots: expenseSpots,
                    isCurved: true,
                    color: const Color(0xFFFF7A7A), // Coral Expense
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFFFF7A7A).withOpacity(0.3),
                    ),
                  ),
                ],
                // Adding savings zone configuration
                betweenBarsData: [
                  BetweenBarsData(
                    fromIndex: 0,
                    toIndex: 1,
                    color: const Color(0xFF10B981).withOpacity(0.15),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend('Income', const Color(0xFF10B981), isDark),
              const SizedBox(width: 24),
              _buildLegend('Expense', const Color(0xFFFF7A7A), isDark),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLegend(String label, Color color, bool isDark) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.outfit(
            color: isDark ? Colors.white70 : Colors.black87,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
