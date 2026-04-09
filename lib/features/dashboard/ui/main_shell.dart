import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:expense_tracker/features/dashboard/ui/dashboard_screen.dart';
import 'package:expense_tracker/features/insights/ui/insights_screen.dart';
import 'package:expense_tracker/features/settings/ui/settings_screen.dart';
import 'package:expense_tracker/features/dashboard/widgets/premium_bottom_nav_bar.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/features/dashboard/providers/navigation_provider.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const _pages = <Widget>[
    DashboardScreen(),
    InsightsScreen(),
    SettingsScreen(),
  ];

  static const _navItems = [
    NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    NavItem(
      icon: Icons.insights_outlined,
      activeIcon: Icons.insights_rounded,
      label: 'Insights',
    ),
    NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    void onTap(int index) {
      if (currentIndex == index) return;
      HapticFeedback.selectionClick();
      ref.read(navigationIndexProvider.notifier).state = index;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: PremiumBottomNavBar(
        currentIndex: currentIndex,
        items: _navItems,
        onTap: onTap,
      ),
    );
  }
}

