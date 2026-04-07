import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/data/repositories/expense_provider.dart';
import 'package:expense_tracker/data/local/schemas/expense.dart';
import 'package:expense_tracker/presentation/widgets/glass_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
  final SmsService _smsService = SmsService();

  @override
  void initState() {
    super.initState();
    _initSmsListener();
  }

  void _initSmsListener() {
    _smsService.initListener((expense) {
      _showConfirmationDialog(expense);
    });
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

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: expensesAsync.when(
            data: (expenses) => CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Header / Balance Card
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Balance', 
                              style: GoogleFonts.outfit(color: Colors.white70)
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${_calculateTotal(expenses)}', 
                              style: GoogleFonts.outfit(
                                fontSize: 32, 
                                fontWeight: FontWeight.bold, 
                                color: Colors.white
                              )
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Pie Chart Section
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 5,
                            centerSpaceRadius: 40,
                            sections: _getSections(expenses),
                          ),
                        ),
                      ),
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
                              color: Colors.white
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final expense = expenses[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: GlassCard(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          opacity: 0.05,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6366F1).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF6366F1)),
                            ),
                            title: Text(
                              expense.title, 
                              style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w600)
                            ),
                            subtitle: Text(
                              DateFormat('dd MMM yyyy').format(expense.date), 
                              style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12)
                            ),
                            trailing: Text(
                              '-\$${expense.amount.toStringAsFixed(2)}',
                              style: GoogleFonts.outfit(
                                color: const Color(0xFFF87171), 
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: expenses.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.white))),
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

  String _calculateTotal(List<Expense> expenses) {
    if (expenses.isEmpty) return '0.00';
    double total = 0.0;
    for (final expense in expenses) {
      total += expense.amount;
    }
    return total.toStringAsFixed(2);
  }

  List<PieChartSectionData> _getSections(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return [
        PieChartSectionData(
          color: Colors.white.withOpacity(0.1), 
          value: 1, 
          title: '', 
          radius: 50
        ),
      ];
    }
    
    final Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      categoryTotals[expense.category] = (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
      const Color(0xFFF43F5E),
      const Color(0xFFF59E0B),
    ];

    int colorIndex = 0;
    return categoryTotals.entries.map((entry) {
      final color = colors[colorIndex % colors.length];
      colorIndex++;
      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: entry.key,
        radius: 50,
        titleStyle: GoogleFonts.outfit(
          fontSize: 12, 
          fontWeight: FontWeight.bold, 
          color: Colors.white
        ),
      );
    }).toList();
  }
}
