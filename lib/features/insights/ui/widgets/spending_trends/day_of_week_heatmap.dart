import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/insights/providers/insights_providers.dart';

class DayOfWeekHeatmap extends ConsumerWidget {
  const DayOfWeekHeatmap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heatmapData = ref.watch(dayOfWeekHeatmapProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    
    // Find max value for color interpolation
    double maxVal = 0;
    heatmapData.forEach((_, value) {
      if (value > maxVal) maxVal = value;
    });

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
            'Spending Intensity',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          RepaintBoundary(
            child: Table(
              children: [
                TableRow(
                  children: List.generate(7, (index) {
                    final val = heatmapData[index + 1] ?? 0.0;
                    final intensity = maxVal == 0 ? 0.0 : val / maxVal;
                    
                    return Column(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Color.lerp(
                              isDark ? Colors.white10 : Colors.black12,
                              const Color(0xFFFF7A7A),
                              intensity,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          days[index],
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: isDark ? Colors.white54 : Colors.black54,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
