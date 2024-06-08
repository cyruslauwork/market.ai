class SharedPreferencesConstant {
  // Singleton implementation
  static const SharedPreferencesConstant _instance =
      SharedPreferencesConstant._internal();
  factory SharedPreferencesConstant() {
    return _instance;
  }
  const SharedPreferencesConstant._internal();

  static String saveLanguageKey = 'lang';
  static String financialInstrumentSymbol = 'financialInstrumentSymbol';
  static String financialInstrumentName = 'financialInstrumentName';
  static String length = 'length';
  static String tolerance = 'tolerance';
  static String darkMode = 'darkMode';
  static String isEn = 'isEn';
  static String alwaysShowAnalytics = 'alwaysShowAnalytics';
  static String messages = 'messages';
  static String watchlist = 'watchlist';
  static String alwaysShowSdDistPlot = 'alwaysShowSdDistPlot';
  static String apiKey = 'apiKey';
  static String apiKeyErr = 'apiKeyErr';
  static String jumpServerUrl = 'jumpServerUrl';
  static String alwaysSkipSymbolInSearch = 'alwaysSkipSymbolInSearch';
  static String alwayStrictMatchCriteria = 'alwayStrictMatchCriteria';
  static String alwaysShowMinuteData = 'alwaysShowMinuteData';
  static String subLength = 'subLength';
}
