import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:expense_tracker/features/settings/ui/widgets/profile_section.dart';
import 'package:expense_tracker/features/settings/ui/widgets/appearance_section.dart';
import 'package:expense_tracker/features/settings/ui/widgets/sms_settings_section.dart';
import 'package:expense_tracker/features/settings/ui/widgets/account_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),
              Text(
                'Settings',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your account & preferences',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 40),
              
              const ProfileSection(),
              
              const AppearanceSection(),
              const SizedBox(height: 32),
              
              const SmsSettingsSection(),
              const SizedBox(height: 32),
              
              const AccountSection(),
              const SizedBox(height: 40),
              
              Center(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.logout_rounded, color: Color(0xFFF87171), size: 18),
                  label: Text(
                    'Sign Out',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFFF87171),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
