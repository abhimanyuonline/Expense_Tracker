import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/data/repositories/expense_provider.dart';
import 'package:expense_tracker/data/local/schemas/expense.dart';
import 'package:expense_tracker/features/dashboard/widgets/animated_balance_card.dart';
import 'package:expense_tracker/features/dashboard/widgets/seven_day_sparkline.dart';
import 'package:expense_tracker/features/dashboard/widgets/budget_progress_rings.dart';
import 'package:expense_tracker/features/dashboard/widgets/upcoming_bills_strip.dart';
import 'package:expense_tracker/features/dashboard/widgets/top_merchants_leaderboard.dart';
import 'package:expense_tracker/features/dashboard/widgets/smart_transaction_list.dart';
import 'package:expense_tracker/features/dashboard/widgets/notification_bell.dart';
import 'package:expense_tracker/features/settings/providers/settings_provider.dart';
import 'package:expense_tracker/features/sms_parser/providers/sms_provider.dart';
import 'package:expense_tracker/features/sms_parser/ui/sms_confirmation_dialog.dart';
import 'package:flutter/services.dart';
import 'package:expense_tracker/presentation/widgets/circular_reveal_transition.dart';
import 'package:expense_tracker/features/dashboard/ui/add_expense_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _initSmsListener();
  }

  void _initSmsListener() {
    final settings = ref.read(settingsProvider);
    final smsService = ref.read(smsServiceProvider);
    smsService.initListener((expense) {
      _showConfirmationDialog(expense);
    }, settings);
  }

  void _showConfirmationDialog(Expense expense) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SmsConfirmationDialog(
        expense: expense,
        onConfirm: () async {
          final repo = ref.read(expenseRepositoryProvider);
          if (repo != null) {
            await repo.addExpense(expense);
          }
          if (mounted) Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaction added successfully!')),
          );
        },
        onDismiss: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expenseListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: expensesAsync.when(
          data: (expenses) => CustomScrollView(
            physics: const ClampingScrollPhysics(), // Prevent elastic stretching
            slivers: [
              // Premium App Bar with Branding & Bell
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  'Dashboard',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                actions: const [
                  NotificationBell(),
                  SizedBox(width: 12),
                ],
              ),

              // Feature 1: Animated Balance Hero Card
              const SliverToBoxAdapter(child: AnimatedBalanceCard()),

              // Feature 3: Budget Progress Rings
              const SliverToBoxAdapter(child: BudgetProgressRings()),

              // Feature 2: 7-day Spend Sparkline
              const SliverToBoxAdapter(child: SevenDaySparkline()),

              // Feature 5: Upcoming Bills Strip
              const SliverToBoxAdapter(child: UpcomingBillsStrip()),

              // Feature 6: Top Merchants Leaderboard
              const SliverToBoxAdapter(child: TopMerchantsLeaderboard()),

              // Feature 7: Smart Grouped Transaction List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                sliver: SmartTransactionList(expenses: expenses),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Text('Error: $err', style: TextStyle(color: textColor)),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset center = renderBox.localToGlobal(Offset.zero);
          center = center.translate(
            MediaQuery.of(context).size.width - 40,
            MediaQuery.of(context).size.height - 40,
          );

          Navigator.push(
            context,
            CircularRevealRoute(
              page: const AddExpenseScreen(),
              center: center,
            ),
          );
        },
        backgroundColor: const Color(0xFF6366F1),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
