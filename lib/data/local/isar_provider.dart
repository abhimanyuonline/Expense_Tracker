import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/data/local/isar_service.dart';
import 'package:expense_tracker/data/services/data_export_service.dart';
import 'package:isar/isar.dart';

final isarServiceProvider = Provider<IsarService>((ref) {
  return IsarService();
});

final isarDbProvider = FutureProvider<Isar>((ref) async {
  final isarService = ref.watch(isarServiceProvider);
  return await isarService.db;
});

final dataExportServiceProvider = Provider.family<DataExportService, Isar>((ref, isar) {
  return DataExportService(isar);
});
