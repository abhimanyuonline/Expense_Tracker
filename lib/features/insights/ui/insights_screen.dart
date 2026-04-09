import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/insights/ui/widgets/summary_cards/top_insight_card.dart';
import 'package:expense_tracker/features/insights/ui/widgets/summary_cards/spend_vs_last_period_card.dart';
import 'package:expense_tracker/features/insights/ui/widgets/summary_cards/best_saving_day_card.dart';
import 'package:expense_tracker/features/insights/ui/widgets/summary_cards/overspend_warning_card.dart';
import 'package:expense_tracker/features/insights/ui/widgets/spending_trends/monthly_bar_chart.dart';
import 'package:expense_tracker/features/insights/ui/widgets/spending_trends/category_breakdown_donut.dart';
import 'package:expense_tracker/features/insights/ui/widgets/spending_trends/day_of_week_heatmap.dart';
import 'package:expense_tracker/features/insights/ui/widgets/spending_trends/daily_spend_line_chart.dart';
import 'package:expense_tracker/features/insights/ui/widgets/spending_trends/time_of_day_chart.dart';

import 'package:expense_tracker/features/insights/ui/widgets/income_analysis/income_sources_breakdown.dart';
import 'package:expense_tracker/features/insights/ui/widgets/income_analysis/income_consistency_tracker.dart';
import 'package:expense_tracker/features/insights/ui/widgets/income_analysis/income_vs_expense_ratio.dart';
import 'package:expense_tracker/features/insights/ui/widgets/income_analysis/pending_income_tracker.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 80,
              floating: true,
              pinned: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                title: Text(
                  'Insights',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
            
            // Section 01: Summary Cards
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const TopInsightCard(),
                  const SpendVsLastPeriodCard(),
                  const BestSavingDayCard(),
                  const OverspendWarningCard(),
                ]),
              ),
            ),
            
            // Section 02: Spending Trends
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text(
                      'Spending Trends',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  const MonthlyBarChart(),
                  const DailySpendLineChart(),
                  const CategoryBreakdownDonut(),
                  const DayOfWeekHeatmap(),
                  const TimeOfDaySpendChart(),
                ]),
              ),
            ),
            
            const SliverToBoxAdapter(
              child: SizedBox(height: 100), // Bottom padding for navbar
            ),
          ],
        ),
      ),
    );
  }
}
