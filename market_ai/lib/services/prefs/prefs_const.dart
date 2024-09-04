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
  static String candleTolerance = 'candleTolerance';
  static String priceTolerance = 'priceTolerance';
  static String firstMaTolerance = 'firstMaTolerance';
  static String maTolerance = 'maTolerance';
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
  static String alwaysMaMatchCriteria = 'alwaysMaMatchCriteria';
  static String alwaysUseCrossData = 'alwaysUseCrossData';
  static String lockTrend = 'lockTrend';
  static String closePosWhenReachedMedian = 'closePosWhenReachedMedian';
  static String probThreshold = 'probThreshold';

  static String img1 = 'img1';
  static String img2 = 'img2';
  static String img3 = 'img3';
  static String img4 = 'img4';
  static String img5 = 'img5';
  static String img6 = 'img6';
  static String img7 = 'img7';
  static String img8 = 'img8';
  static String img9 = 'img9';
  static String img10 = 'img10';
  static String cluster = 'cluster';
  static String lockTrendLastRow = 'lockTrendLastRow';
  static String lockTrendLastDatetime = 'lockTrendLastDatetime';
  static String lowReturn = 'lowReturn';
  static String lowProb = 'lowProb';
  static String trendsLessThanFive = 'trendsLessThanFive';
  static String trendsOneSidedButLessThanFour = 'trendsOneSidedButLessThanFour';
  static String trendsNotOneSided = 'trendsNotOneSided';
  static String expectedProb = 'expectedProb';
  static String returnRate = 'returnRate';
  static String expectedMdd = 'expectedMdd';
  static String isLong = 'isLong';
  static String isShort = 'isShort';

  static String alwaysThousandthsData = 'alwaysThousandthsData';
  static String minReturnRateThreshold = 'minReturnRateThreshold';
}
