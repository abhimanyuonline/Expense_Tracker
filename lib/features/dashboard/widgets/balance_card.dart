import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/presentation/widgets/glass_card.dart';
import 'package:expense_tracker/data/repositories/expense_provider.dart';
import 'package:expense_tracker/features/settings/providers/settings_provider.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(settingsProvider); // React to settings changes
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final totalBalance = ref.watch(totalBalanceProvider);
        
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance', 
            style: GoogleFonts.outfit(color: subTextColor)
          ),
          const SizedBox(height: 8),
          Text(
            settingsNotifier.formatAmount(totalBalance), 
            style: GoogleFonts.outfit(
              fontSize: 32, 
              fontWeight: FontWeight.bold, 
              color: textColor
            )
          ),
        ],
      ),
    );
  }
}
