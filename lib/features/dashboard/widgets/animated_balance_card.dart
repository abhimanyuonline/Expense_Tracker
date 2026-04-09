import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/data/repositories/expense_provider.dart';
import 'package:expense_tracker/features/settings/providers/settings_provider.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class AnimatedBalanceCard extends ConsumerWidget {
  const AnimatedBalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final totalBalance = ref.watch(totalBalanceProvider);
    final monthlyIncome = ref.watch(currentMonthIncomeProvider);
    final monthlySpend = ref.watch(currentMonthSpendProvider);
    final saved = monthlyIncome - monthlySpend;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            // Premium Mesh Gradient Background
            Positioned.fill(
              child: MeshGradient(
                points: [
                  MeshGradientPoint(
                    position: const Offset(0.2, 0.2),
                    color: const Color(0xFF6366F1),
                  ),
                  MeshGradientPoint(
                    position: const Offset(0.8, 0.2),
                    color: const Color(0xFF8B5CF6),
                  ),
                  MeshGradientPoint(
                    position: const Offset(0.5, 0.8),
                    color: const Color(0xFF4F46E5),
                  ),
                ],
                options: MeshGradientOptions(
                  blend: 4,
                  noiseIntensity: 0.1,
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Balance',
                        style: GoogleFonts.outfit(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      _buildMoMBadge(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Animated Counter
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.fastOutSlowIn,
                    tween: Tween<double>(begin: 0, end: totalBalance),
                    builder: (context, value, child) {
                      return Text(
                        settingsNotifier.formatAmount(value),
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1,
                        ),
                      );
                    },
                  ),
                  
                  const Spacer(),
                  
                  // Sub-chips Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniInfo('Income', monthlyIncome, Colors.greenAccent),
                      _buildMiniInfo('Spent', monthlySpend, Colors.orangeAccent),
                      _buildMiniInfo('Saved', saved > 0 ? saved : 0, Colors.cyanAccent),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoMBadge() {
    // For now, hardcode a positive badge. 
    // In a real app, you'd compare currentMonthSpend with lastMonthSpend.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.trending_up, color: Colors.greenAccent, size: 14),
          const SizedBox(width: 4),
          Text(
            '+12.5%',
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniInfo(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '\$${amount.toStringAsFixed(0)}',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
