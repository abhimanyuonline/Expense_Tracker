import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/features/sms_parser/services/sms_service.dart';

final smsServiceProvider = Provider<SmsService>((ref) => SmsService());
