class SettingsModel {
  final String displayName;
  final String profileImagePath;
  final bool isDarkMode;
  final String currency;
  final String dateFormat;
  final String numberFormat;
  final bool isSmsScanEnabled;
  final List<String> bankFilterList;

  SettingsModel({
    this.displayName = 'Your Name',
    this.profileImagePath = '',
    this.isDarkMode = true,
    this.currency = '\$',
    this.dateFormat = 'DD/MM/YYYY',
    this.numberFormat = 'en-US',
    this.isSmsScanEnabled = true,
    this.bankFilterList = const ['SBI-SBIBNK', 'HDFC-HDFCBK', 'ICICI-ICICIB'],
  });

  SettingsModel copyWith({
    String? displayName,
    String? profileImagePath,
    bool? isDarkMode,
    String? currency,
    String? dateFormat,
    String? numberFormat,
    bool? isSmsScanEnabled,
    List<String>? bankFilterList,
  }) {
    return SettingsModel(
      displayName: displayName ?? this.displayName,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      currency: currency ?? this.currency,
      dateFormat: dateFormat ?? this.dateFormat,
      numberFormat: numberFormat ?? this.numberFormat,
      isSmsScanEnabled: isSmsScanEnabled ?? this.isSmsScanEnabled,
      bankFilterList: bankFilterList ?? this.bankFilterList,
    );
  }
}
