import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/data/repositories/expense_provider.dart';
import 'package:expense_tracker/data/local/schemas/expense.dart';
import 'package:expense_tracker/features/dashboard/widgets/balance_card.dart';
import 'package:expense_tracker/features/dashboard/widgets/expense_pie_chart.dart';
import 'package:expense_tracker/features/dashboard/widgets/transaction_list.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:expense_tracker/features/settings/providers/settings_provider.dart';
import 'package:expense_tracker/features/sms_parser/providers/sms_provider.dart';
import 'package:expense_tracker/features/sms_parser/services/sms_service.dart';
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
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: expensesAsync.when(
            data: (expenses) => CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Header / Balance Card
                      const BalanceCard(),
                      const SizedBox(height: 30),
                      // Pie Chart Section
                      const ExpensePieChart(),
                      const SizedBox(height: 30),
                      // Transactions Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Transactions',
                            style: GoogleFonts.outfit(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold, 
                              color: textColor
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                TransactionList(expenses: expenses),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err', style: TextStyle(color: textColor))),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset center = renderBox.localToGlobal(Offset.zero);
          // Adjust center to the button's position
          center = center.translate(MediaQuery.of(context).size.width - 40, MediaQuery.of(context).size.height - 40);
          
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
