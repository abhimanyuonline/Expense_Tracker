import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/data/repositories/expense_provider.dart';

class ExpensePieChart extends ConsumerWidget {
  const ExpensePieChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryTotals = ref.watch(expenseCategoryTotalsProvider);
    
    return RepaintBoundary(
      child: SizedBox(
        height: 200,
        child: PieChart(
          PieChartData(
            sectionsSpace: 5,
            centerSpaceRadius: 40,
            sections: _getSections(categoryTotals),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _getSections(Map<String, double> categoryTotals) {
    if (categoryTotals.isEmpty) {
      return [
        PieChartSectionData(
          color: Colors.white.withValues(alpha: 0.1), 
          value: 1, 
          title: '', 
          radius: 50
        ),
      ];
    }
    
    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
      const Color(0xFFF43F5E),
      const Color(0xFFF59E0B),
    ];

    int colorIndex = 0;
    return categoryTotals.entries.map((entry) {
      final color = colors[colorIndex % colors.length];
      colorIndex++;
      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: entry.key,
        radius: 50,
        titleStyle: GoogleFonts.outfit(
          fontSize: 12, 
          fontWeight: FontWeight.bold, 
          color: Colors.white
        ),
      );
    }).toList();
  }
}
