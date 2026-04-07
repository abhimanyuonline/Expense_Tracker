import 'dart:io';
import 'package:telephony/telephony.dart';
import 'package:expense_tracker/features/sms_parser/logic/bank_parser.dart';
import 'package:expense_tracker/data/local/schemas/expense.dart';

class SmsService {
  final Telephony telephony = Telephony.instance;

  // Initialize SMS listener (Android only)
  Future<void> initListener(Function(Expense) onTransactionDetected) async {
    if (!Platform.isAndroid) return;

    bool? permissionsGranted = await telephony.requestSmsPermissions;
    if (permissionsGranted == true) {
      telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          final body = message.body;
          if (body != null) {
            final detectedExpense = BankParser.parseSms(body);
            if (detectedExpense != null) {
              onTransactionDetected(detectedExpense);
            }
          }
        },
        listenInBackground: false,
      );
    }
  }
}
