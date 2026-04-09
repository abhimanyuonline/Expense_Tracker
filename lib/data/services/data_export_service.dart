import 'dart:convert';
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:expense_tracker/data/local/schemas/expense.dart';
import 'package:expense_tracker/data/local/schemas/category.dart';

class DataExportService {
  final Isar isar;

  DataExportService(this.isar);

  Future<void> exportAllDataAsJson() async {
    final expenses = await isar.expenses.where().findAll();
    final categories = await isar.categorys.where().findAll();

    final data = {
      'exportDate': DateTime.now().toIso8601String(),
      'expenses': expenses.map((e) => {
        'title': e.title,
        'amount': e.amount,
        'date': e.date?.toIso8601String(),
        'category': e.category,
        'isIncome': e.isIncome,
        'smsId': e.smsId,
      }).toList(),
      'categories': categories.map((c) => {
        'name': c.name,
        'budgetCap': c.budgetCap,
      }).toList(),
    };

    final jsonString = jsonEncode(data);
    
    // Get temporary directory to store the file for sharing
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/expense_tracker_export.json');
    
    await file.writeAsString(jsonString);
    
    // Share the file
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Expense Tracker Data Export',
    );
  }
}
