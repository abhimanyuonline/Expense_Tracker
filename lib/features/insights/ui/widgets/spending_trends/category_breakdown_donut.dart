import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expense_tracker/features/insights/providers/insights_providers.dart';

class CategoryBreakdownDonut extends ConsumerStatefulWidget {
  const CategoryBreakdownDonut({super.key});

  @override
  ConsumerState<CategoryBreakdownDonut> createState() => _CategoryBreakdownDonutState();
}

class _CategoryBreakdownDonutState extends ConsumerState<CategoryBreakdownDonut> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    // In actual implementation, we might need a distinct category breakdowns provider.
    // For this demonstration, we'll use a mocked map based on categoryListProvider if it were aggregated.
    // We can compute it right here for simplicity, reusing logic.
    final overspendWarnings = ref.watch(overspendWarningProvider); 
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Fallback static data if no overspend is present just for visual structure. 
    // Ideally this comes from a dedicated provider.
    final mockData = {
      'Food': 450.50,
      'Transport': 120.0,
      'Rent': 1200.0,
      'Entertainment': 300.0,
    };
    
    final Map<String, double> aggregatedData = overspendWarnings.isNotEmpty 
      ? { for (var w in overspendWarnings) w.category: w.spent } 
      : mockData;

    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFFFF7A7A),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
    ];

    double total = aggregatedData.values.fold(0, (a, b) => a + b);

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
            'Category Breakdown',
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
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                sections: _showingSections(aggregatedData, total, colors),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Legend
          ...aggregatedData.entries.toList().asMap().entries.map((entry) {
            int idx = entry.key;
            var dataEntry = entry.value;
            bool isTouched = idx == touchedIndex;
            double pct = total == 0 ? 0 : (dataEntry.value / total) * 100;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isTouched 
                    ? colors[idx % colors.length].withOpacity(0.1) 
                    : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
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
                          fontWeight: isTouched ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    Text(
                      '\$${dataEntry.value.toStringAsFixed(2)}',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 45,
                      child: Text(
                        '${pct.toStringAsFixed(1)}%',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.outfit(
                          color: isDark ? Colors.white38 : Colors.black38,
                          fontSize: 12,
                        ),
                      ),
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

  List<PieChartSectionData> _showingSections(Map<String, double> data, double total, List<Color> colors) {
    return data.entries.toList().asMap().entries.map((entry) {
      final isTouched = entry.key == touchedIndex;
      final fontSize = isTouched ? 16.0 : 0.0; // Only show text on touch
      final radius = isTouched ? 30.0 : 20.0;
      final dataEntry = entry.value;
      double pct = total == 0 ? 0 : (dataEntry.value / total) * 100;

      return PieChartSectionData(
        color: colors[entry.key % colors.length],
        value: dataEntry.value,
        title: '${pct.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: GoogleFonts.outfit(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
