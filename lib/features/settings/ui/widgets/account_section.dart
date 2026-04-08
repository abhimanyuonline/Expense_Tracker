import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/settings/ui/widgets/settings_tile.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('Delete Account', style: GoogleFonts.outfit(color: const Color(0xFFF87171), fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to permanently delete your account and all local data? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF87171)),
            onPressed: () {
              // TODO: Implement actual deletion logic (Isar drop, SharedPreferences clear)
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account data deleted.')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account & Security',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),

        SettingsTile(
          icon: Icons.link_rounded,
          label: 'Link Google Account',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Google Sign-In logic coming soon.')),
            );
          },
        ),

        const SizedBox(height: 8),

        SettingsTile(
          icon: Icons.delete_forever_rounded,
          iconColor: const Color(0xFFF87171),
          label: 'Delete Account',
          onTap: () => _confirmDelete(context),
        ),
      ],
    );
  }
}
