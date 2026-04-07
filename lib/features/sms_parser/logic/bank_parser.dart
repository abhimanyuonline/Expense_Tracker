import 'package:expense_tracker/data/local/schemas/expense.dart';

class BankParser {
  // Modular patterns for common transaction SMS
  static final List<RegExp> _patterns = [
    // Pattern for "Sent/Spent Rs XXX"
    RegExp(r'(?:Sent|Spent|Paid|Debited)\s+(?:Rs\.?|INR)\s*([\d,.]+)', caseSensitive: false),
    // Pattern for "Transaction of Rs XXX"
    RegExp(r'Transaction\s+of\s+(?:Rs\.?|INR)\s*([\d,.]+)', caseSensitive: false),
  ];

  static Expense? parseSms(String body) {
    for (var pattern in _patterns) {
      final match = pattern.firstMatch(body);
      if (match != null) {
        final amountString = match.group(1)?.replaceAll(',', '') ?? '0';
        final amount = double.tryParse(amountString) ?? 0.0;
        
        if (amount > 0) {
          return Expense()
            ..title = _extractMerchant(body)
            ..amount = amount
            ..date = DateTime.now()
            ..category = 'Uncategorized'
            ..isSynced = false;
        }
      }
    }
    return null;
  }

  static String _extractMerchant(String body) {
    // Extract everything between 'to/at' and 'via/AC/on'
    final merchantMatch = RegExp(r'(?:to|at|on)\s+([A-Z0-9\s]+?)(?:\s+via|\.|\s+AC:|\s+on)', caseSensitive: false).firstMatch(body);
    String detected = merchantMatch?.group(1)?.trim() ?? 'Auto Transaction';
    
    // Cleanup common bank terms
    return detected.length > 30 ? detected.substring(0, 30) : detected;
  }
}
