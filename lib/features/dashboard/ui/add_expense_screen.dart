import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/data/repositories/expense_provider.dart';
import 'package:expense_tracker/data/local/schemas/expense.dart';
import 'package:expense_tracker/presentation/widgets/glass_card.dart';
import 'package:google_fonts/google_fonts.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Food';

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6366F1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Expense',
                      style: GoogleFonts.outfit(
                        fontSize: 28, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                GlassCard(
                  opacity: 0.1,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        autofocus: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Expense Title', Icons.title),
                        validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _amountController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: _inputDecoration('Amount', Icons.attach_money),
                        validator: (value) => double.tryParse(value!) == null ? 'Enter valid amount' : null,
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        dropdownColor: const Color(0xFF6366F1),
                        items: ['Food', 'Travel', 'Rent', 'Entertainment', 'Misc']
                            .map((c) => DropdownMenuItem(
                                value: c, 
                                child: Text(c, style: const TextStyle(color: Colors.white))
                              ))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedCategory = val!),
                        decoration: _inputDecoration('Category', Icons.category),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _saveExpense,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 5,
                    ),
                    child: Text(
                      'SAVE EXPENSE',
                      style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
    );
  }

  Future<void> _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      final repo = ref.read(expenseRepositoryProvider);
      if (repo != null) {
        final expense = Expense()
          ..title = _titleController.text
          ..amount = double.parse(_amountController.text)
          ..date = DateTime.now()
          ..category = _selectedCategory;
        
        await repo.addExpense(expense);
        if (mounted) Navigator.pop(context);
      }
    }
  }
}
