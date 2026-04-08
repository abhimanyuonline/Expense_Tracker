import 'dart:io';
import 'package:telephony/telephony.dart';
import 'package:isar/isar.dart' hide Sort;
import 'package:expense_tracker/features/sms_parser/logic/bank_parser.dart';
import 'package:expense_tracker/data/local/schemas/expense.dart';
import 'package:expense_tracker/features/settings/models/settings_model.dart';
import 'package:expense_tracker/data/repositories/expense_repository.dart';

class SmsService {
  final Telephony telephony = Telephony.instance;

  // Initialize SMS listener (Android only)
  Future<void> initListener(Function(Expense) onTransactionDetected, SettingsModel settings) async {
    if (!Platform.isAndroid) return;
    if (!settings.isSmsScanEnabled) return;

    bool? permissionsGranted = await telephony.requestSmsPermissions;
    if (permissionsGranted == true) {
      telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          final body = message.body;
          final sender = message.address?.toUpperCase() ?? '';
          
          if (body != null) {
            // Check whitelist
            if (!settings.bankFilterList.any((filter) => sender.contains(filter.toUpperCase()))) {
              return;
            }

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

  // Scan inbox on demand
  Future<void> scanInbox(int days, SettingsModel settings, ExpenseRepository repository) async {
    if (!Platform.isAndroid) return;

    bool? permissionsGranted = await telephony.requestSmsPermissions;
    if (permissionsGranted == true) {
      final now = DateTime.now();
      final threshold = now.subtract(Duration(days: days));

      final messages = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
      );

      for (var message in messages) {
        final dateInt = message.date;
        if (dateInt == null) continue;
        
        final msgDate = DateTime.fromMillisecondsSinceEpoch(dateInt);
        if (msgDate.isBefore(threshold)) {
          continue; // Skip very old messages
        }

        final sender = message.address?.toUpperCase() ?? '';
        final body = message.body;

        if (body != null && settings.bankFilterList.any((filter) => sender.contains(filter.toUpperCase()))) {
          final detectedExpense = BankParser.parseSms(body);
          if (detectedExpense != null) {
            
            // Generate a primitive deduplication ID
            final smsId = 'sms_${dateInt}_$sender';
            
            // Check if already exists in repository by smsId (requires adding find by smsId or fetching all and comparing)
            // For simplicity without changing Isar query, we just compare recently added expenses or we add smsId to Expense
            // We already have 'String? smsId;' in Expense!
            detectedExpense.smsId = smsId;
            
            final expenses = await repository.isar.expenses.where().findAll();
            final exists = expenses.any((e) => e.smsId == smsId);
            
            if (!exists) {
              await repository.addExpense(detectedExpense);
            }
          }
        }
      }
    }
  }
}
