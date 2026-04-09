import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/features/settings/models/settings_model.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main.dart');
});

class SettingsNotifier extends StateNotifier<SettingsModel> {
  final SharedPreferences prefs;

  SettingsNotifier(this.prefs) : super(SettingsModel()) {
    _loadSettings();
  }

  void _loadSettings() {
    state = SettingsModel(
      displayName: prefs.getString('displayName') ?? 'Abhimanyu',
      profileImagePath: prefs.getString('profileImagePath') ?? '',
      isDarkMode: prefs.getBool('isDarkMode') ?? true,
      currency: prefs.getString('currency') ?? '\$',
      dateFormat: prefs.getString('dateFormat') ?? 'dd/MM/yyyy',
      numberFormat: prefs.getString('numberFormat') ?? 'en-US',
      isSmsScanEnabled: prefs.getBool('isSmsScanEnabled') ?? true,
      bankFilterList: prefs.getStringList('bankFilterList') ??
          const ['SBI-SBIBNK', 'HDFC-HDFCBK', 'ICICI-ICICIB'],
    );
  }

  Future<void> updateDisplayName(String name) async {
    await prefs.setString('displayName', name);
    state = state.copyWith(displayName: name);
  }

  Future<void> updateProfileImagePath(String path) async {
    await prefs.setString('profileImagePath', path);
    state = state.copyWith(profileImagePath: path);
  }

  Future<void> updateTheme(bool isDark) async {
    await prefs.setBool('isDarkMode', isDark);
    state = state.copyWith(isDarkMode: isDark);
  }

  Future<void> updateCurrency(String currency) async {
    await prefs.setString('currency', currency);
    state = state.copyWith(currency: currency);
  }

  Future<void> updateDateFormat(String format) async {
    await prefs.setString('dateFormat', format);
    state = state.copyWith(dateFormat: format);
  }

  Future<void> updateNumberFormat(String format) async {
    await prefs.setString('numberFormat', format);
    state = state.copyWith(numberFormat: format);
  }

  Future<void> updateSmsScanEnabled(bool enabled) async {
    await prefs.setBool('isSmsScanEnabled', enabled);
    state = state.copyWith(isSmsScanEnabled: enabled);
  }

  Future<void> addBankFilter(String bankId) async {
    final list = List<String>.from(state.bankFilterList)..add(bankId);
    await prefs.setStringList('bankFilterList', list);
    state = state.copyWith(bankFilterList: list);
  }

  Future<void> removeBankFilter(String bankId) async {
    final list = List<String>.from(state.bankFilterList)..remove(bankId);
    await prefs.setStringList('bankFilterList', list);
    state = state.copyWith(bankFilterList: list);
  }

  String formatAmount(double amount) {
    try {
      final formatter = NumberFormat.decimalPattern(state.numberFormat);
      return '${state.currency}${formatter.format(amount)}';
    } catch (e) {
      // Fallback
      return '${state.currency}${amount.toStringAsFixed(2)}';
    }
  }

  String formatDate(DateTime date) {
    try {
      return DateFormat(state.dateFormat).format(date);
    } catch (e) {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsModel>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsNotifier(prefs);
});
