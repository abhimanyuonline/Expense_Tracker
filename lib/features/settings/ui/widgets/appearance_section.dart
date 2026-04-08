import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/settings/providers/settings_provider.dart';
import 'package:expense_tracker/features/settings/ui/widgets/settings_tile.dart';

class AppearanceSection extends ConsumerWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appearance & Locale',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),

        SettingsSwitchTile(
          icon: Icons.dark_mode_rounded,
          label: 'Dark Mode',
          value: settings.isDarkMode,
          onChanged: (val) => notifier.updateTheme(val),
        ),

        SettingsTile(
          icon: Icons.payments_rounded,
          label: 'Currency',
          onTap: () {},
          trailing: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: settings.currency,
              dropdownColor: theme.cardColor,
              icon: Icon(Icons.arrow_drop_down, color: theme.iconTheme.color),
              style: GoogleFonts.outfit(
                color: theme.textTheme.bodyLarge?.color,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              items: ['₹', '\$', '€', '£', '¥'].map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) notifier.updateCurrency(val);
              },
            ),
          ),
        ),

        SettingsTile(
          icon: Icons.calendar_month_rounded,
          label: 'Date Format',
          onTap: () {},
          trailing: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: settings.dateFormat,
              dropdownColor: theme.cardColor,
              icon: Icon(Icons.arrow_drop_down, color: theme.iconTheme.color),
              style: GoogleFonts.outfit(
                color: theme.textTheme.bodyLarge?.color,
                fontSize: 14,
              ),
              items: ['dd/MM/yyyy', 'MM-dd-yyyy', 'yyyy-MM-dd'].map((String format) {
                return DropdownMenuItem<String>(
                  value: format,
                  child: Text(format.toUpperCase()),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) notifier.updateDateFormat(val);
              },
            ),
          ),
        ),

        SettingsTile(
          icon: Icons.numbers_rounded,
          label: 'Number Format',
          onTap: () {},
          trailing: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: settings.numberFormat,
              dropdownColor: theme.cardColor,
              icon: Icon(Icons.arrow_drop_down, color: theme.iconTheme.color),
              style: GoogleFonts.outfit(
                color: theme.textTheme.bodyLarge?.color,
                fontSize: 14,
              ),
              items: const [
                DropdownMenuItem(value: 'en-US', child: Text('100,000.00')),
                DropdownMenuItem(value: 'en-IN', child: Text('1,00,000.00')),
                DropdownMenuItem(value: 'de-DE', child: Text('100.000,00')),
              ],
              onChanged: (val) {
                if (val != null) notifier.updateNumberFormat(val);
              },
            ),
          ),
        ),
      ],
    );
  }
}
