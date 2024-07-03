import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:isar/isar.dart';

import 'package:market_ai/styles/styles.dart';
import 'package:market_ai/utils/utils.dart';
import 'package:market_ai/models/models.dart';
import 'package:market_ai/services/services.dart';
import 'package:market_ai/views/views.dart';
import 'package:market_ai/models/collections.dart';

class MainPresenter extends GetxController {
  // Singleton implementation
  static MainPresenter? _instance;
  factory MainPresenter() {
    _instance ??= MainPresenter._();
    return _instance!;
  }
  MainPresenter._();

  static MainPresenter get to => Get.find();

  List<CandleData> dummyCandle = [
    CandleData(
      timestamp: 1555939800 * 1000,
      open: 51.80,
      high: 53.94,
      low: 50.50,
      close: 52.55,
      volume: 60735500,
    ),
    CandleData(
      timestamp: 1556026200 * 1000,
      open: 43.80,
      high: 53.94,
      low: 42.50,
      close: 52.55,
      volume: 60735500,
    ),
    CandleData(
      timestamp: 1556112600 * 1000,
      open: 73.80,
      high: 83.94,
      low: 52.50,
      close: 72.55,
      volume: 60735500,
    ),
    CandleData(
      timestamp: 1556199000 * 1000,
      open: 72.55,
      high: 75.20,
      low: 70.50,
      close: 74.80,
      volume: 55000000,
    ),
    CandleData(
      timestamp: 1556285400 * 1000,
      open: 74.80,
      high: 76.50,
      low: 73.20,
      close: 75.50,
      volume: 51000000,
    ),
    CandleData(
      timestamp: 1556371800 * 1000,
      open: 75.50,
      high: 77.80,
      low: 74.50,
      close: 76.70,
      volume: 48000000,
    ),
    CandleData(
      timestamp: 1556458200 * 1000,
      open: 76.70,
      high: 77.90,
      low: 75.50,
      close: 77.20,
      volume: 46000000,
    ),
    CandleData(
      timestamp: 1556544600 * 1000,
      open: 77.20,
      high: 78.40,
      low: 76.80,
      close: 77.80,
      volume: 44000000,
    ),
    CandleData(
      timestamp: 1556631000 * 1000,
      open: 77.80,
      high: 79.20,
      low: 77.50,
      close: 78.90,
      volume: 42000000,
    ),
    CandleData(
      timestamp: 1556717400 * 1000,
      open: 78.90,
      high: 80.10,
      low: 78.20,
      close: 79.50,
      volume: 40000000,
    ),
    CandleData(
      timestamp: 1556803800 * 1000,
      open: 79.50,
      high: 81.00,
      low: 79.30,
      close: 80.70,
      volume: 38000000,
    ),
    CandleData(
      timestamp: 1556890200 * 1000,
      open: 80.70,
      high: 81.80,
      low: 80.10,
      close: 81.30,
      volume: 36000000,
    ),
    CandleData(
      timestamp: 1556976600 * 1000,
      open: 81.30,
      high: 82.50,
      low: 80.80,
      close: 82.20,
      volume: 34000000,
    ),
    CandleData(
      timestamp: 1557063000 * 1000,
      open: 82.20,
      high: 83.40,
      low: 81.60,
      close: 82.80,
      volume: 32000000,
    ),
    CandleData(
      timestamp: 1557149400 * 1000,
      open: 82.80,
      high: 84.00,
      low: 82.20,
      close: 83.50,
      volume: 30000000,
    ),
    CandleData(
      timestamp: 1557235800 * 1000,
      open: 83.50,
      high: 84.60,
      low: 82.80,
      close: 84.10,
      volume: 28000000,
    ),
    CandleData(
      timestamp: 1557495000 * 1000,
      open: 85.30,
      high: 87.10,
      low: 85.00,
      close: 86.50,
      volume: 22000000,
    ),
    CandleData(
      timestamp: 1557581400 * 1000,
      open: 86.50,
      high: 87.60,
      low: 86.00,
      close: 87.20,
      volume: 20000000,
    ),
    CandleData(
      timestamp: 1557667800 * 1000,
      open: 87.20,
      high: 88.40,
      low: 86.70,
      close: 87.80,
      volume: 18000000,
    ),
    CandleData(
      timestamp: 1557754200 * 1000,
      open: 87.80,
      high: 89.00,
      low: 87.10,
      close: 88.50,
      volume: 16000000,
    ),
    CandleData(
      timestamp: 1557840600 * 1000,
      open: 88.50,
      high: 89.80,
      low: 88.00,
      close: 89.10,
      volume: 14000000,
    ),
    CandleData(
      timestamp: 1557927000 * 1000,
      open: 89.10,
      high: 90.20,
      low: 88.40,
      close: 89.70,
      volume: 12000000,
    ),
    CandleData(
      timestamp: 1558013400 * 1000,
      open: 89.70,
      high: 90.90,
      low: 88.90,
      close: 90.40,
      volume: 10000000,
    ),
    CandleData(
      timestamp: 1558099800 * 1000,
      open: 90.40,
      high: 91.60,
      low: 89.70,
      close: 91.10,
      volume: 8000000,
    ),
    CandleData(
      timestamp: 1558186200 * 1000,
      open: 91.10,
      high: 92.30,
      low: 90.40,
      close: 91.80,
      volume: 6000000,
    ),
    CandleData(
      timestamp: 1558272600 * 1000,
      open: 91.80,
      high: 93.00,
      low: 91.10,
      close: 92.50,
      volume: 4000000,
    ),
    CandleData(
      timestamp: 1558359000 * 1000,
      open: 92.50,
      high: 93.70,
      low: 91.80,
      close: 93.20,
      volume: 2000000,
    ),
    CandleData(
      timestamp: 1558445400 * 1000,
      open: 93.20,
      high: 94.40,
      low: 92.50,
      close: 93.90,
      volume: 1000000,
    ),
    CandleData(
      timestamp: 1558531800 * 1000,
      open: 93.90,
      high: 95.00,
      low: 93.10,
      close: 94.50,
      volume: 900000,
    ),
    CandleData(
      timestamp: 1558618200 * 1000,
      open: 94.50,
      high: 95.70,
      low: 93.80,
      close: 95.20,
      volume: 800000,
    ),
    CandleData(
      timestamp: 1558704600 * 1000,
      open: 95.20,
      high: 96.40,
      low: 94.50,
      close: 95.90,
      volume: 700000,
    ),
    CandleData(
      timestamp: 1558791000 * 1000,
      open: 95.90,
      high: 97.10,
      low: 95.20,
      close: 96.60,
      volume: 600000,
    ),
    CandleData(
      timestamp: 1558877400 * 1000,
      open: 96.60,
      high: 97.80,
      low: 95.90,
      close: 97.30,
      volume: 500000,
    ),
    CandleData(
      timestamp: 1558963800 * 1000,
      open: 97.30,
      high: 98.50,
      low: 96.60,
      close: 98.00,
      volume: 400000,
    ),
    CandleData(
      timestamp: 1559050200 * 1000,
      open: 98.00,
      high: 99.20,
      low: 97.30,
      close: 98.70,
      volume: 300000,
    ),
    CandleData(
      timestamp: 1559136600 * 1000,
      open: 98.70,
      high: 99.90,
      low: 97.90,
      close: 99.40,
      volume: 200000,
    ),
    CandleData(
      timestamp: 1559223000 * 1000,
      open: 99.40,
      high: 100.60,
      low: 98.70,
      close: 100.10,
      volume: 100000,
    ),
    CandleData(
      timestamp: 1559309400 * 1000,
      open: 100.10,
      high: 101.30,
      low: 99.40,
      close: 100.80,
      volume: 50000,
    ),
    CandleData(
      timestamp: 1559395800 * 1000,
      open: 100.80,
      high: 102.00,
      low: 100.10,
      close: 101.50,
      volume: 25000,
    ),
    CandleData(
      timestamp: 1559482200 * 1000,
      open: 101.50,
      high: 102.70,
      low: 100.80,
      close: 102.20,
      volume: 10000,
    ),
  ];
  bool isInit = false;

  /* Preference */
  RxBool darkMode =
      (PrefsService.to.prefs.getBool(SharedPreferencesConstant.darkMode) ??
              false)
          .obs;
  bool isDarkModeInit = false;
  RxBool devMode = false.obs;
  ValueNotifier<bool> devModeNotifier = ValueNotifier<bool>(false);
  bool isDevModeListenerAdded = false;
  ValueNotifier<bool> isEnNotifier = ValueNotifier<bool>(
      (PrefsService.to.prefs.getBool(SharedPreferencesConstant.isEn) ?? true));
  bool isEnListenerAdded = false;
  RxBool alwaysShowAnalytics = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.alwaysShowAnalytics) ??
          false)
      .obs;
  RxBool alwaysShowSdDistPlot = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.alwaysShowSdDistPlot) ??
          false)
      .obs;
  RxList<String> watchlist = (PrefsService.to.prefs
              .getStringList(SharedPreferencesConstant.watchlist) ??
          [])
      .obs;
  late Rx<IconData> bookmarked =
      (watchlist.contains(financialInstrumentSymbol.value)
              ? Icons.bookmark_outlined
              : Icons.bookmark_border_outlined)
          .obs;
  RxString apiKey =
      (PrefsService.to.prefs.getString(SharedPreferencesConstant.apiKey) ?? '')
          .obs;
  RxString apiKeyErr =
      (PrefsService.to.prefs.getString(SharedPreferencesConstant.apiKeyErr) ??
              '')
          .obs;
  RxString jumpServerUrl = (PrefsService.to.prefs
              .getString(SharedPreferencesConstant.jumpServerUrl) ??
          '35.212.154.124')
      .obs;
  RxBool alwaysShowMinuteData = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.alwaysShowMinuteData) ??
          false)
      .obs;
  late Rx<IconData> dataGranularity =
      (alwaysShowMinuteData.value ? Icons.timer_outlined : Icons.today).obs;
  RxBool alwaysUseCrossData = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.alwaysUseCrossData) ??
          false)
      .obs;
  late Rx<IconData> crossData =
      (alwaysUseCrossData.value ? Icons.dataset_linked_rounded : Icons.dataset)
          .obs;

  /* Candlestick-related */
  RxString financialInstrumentSymbol = (PrefsService.to.prefs
              .getString(SharedPreferencesConstant.financialInstrumentSymbol) ??
          'SPY')
      .obs;
  RxString financialInstrumentName = (PrefsService.to.prefs
              .getString(SharedPreferencesConstant.financialInstrumentName) ??
          'SPDR S&P 500 ETF Trust')
      .obs;
  RxInt candledownloadTime = 0.obs;
  RxList<List<dynamic>> candleListList = [[]].obs;
  RxList<List<dynamic>> spyCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> qqqCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> usoCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> gldCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> slvCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> iwmCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> xlkCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> aaplCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> baCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> bacCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> mcdCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> nvdaCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> msftCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> gskCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> tslaCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> amznCandleListList = [[]].obs; // Cross-data
  late Rx<Future<List<CandleData>>> futureListCandledata = init().obs;
  late RxList<CandleData> listCandledata = dummyCandle.obs;
  late RxList<CandleData> spyListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> qqqListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> usoListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> gldListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> slvListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> iwmListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> xlkListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> aaplListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> baListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> bacListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> mcdListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> nvdaListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> msftListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> gskListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> tslaListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> amznListCandledata = dummyCandle.obs; // Cross-data
  ValueNotifier<bool> showAverageNotifier = ValueNotifier<bool>(true);
  bool isShowAverageListenerAdded = false;
  late RxString marketDataProviderMsg = Rx('mkt_data'.tr)().obs;
  RxBool isMarketDataProviderErr = false.obs;
  RxList minuteDataList = [
    'SPY',
    'QQQ',
    'USO',
    'GLD',
    'SLV',
    'IWM',
    'XLK',
    'AAPL',
    'BA',
    'BAC',
    'MCD',
    'NVDA',
    'MSFT',
    'GSK',
    'TSLA',
    'AMZN',
  ].obs;
  RxBool hasMinuteData = false.obs;
  late Rx<String> lastDatetime = 'Loading last datetime...'.obs;
  RxBool hasCandleData = false.obs;
  late RxString legends = (MainPresenter.to.alwaysShowMinuteData.value
          ? '🟠EMA5 🔴EMA10 🟢EMA15 🔵EMA20'
          : '🟠MA5 🔴MA20 🟢MA60 🔵MA120 🟣MA240')
      .obs;
  RxBool hasSpyMinuteData = false.obs;
  RxBool hasQqqMinuteData = false.obs;
  RxBool hasUsoMinuteData = false.obs;
  RxBool hasGldMinuteData = false.obs;
  RxBool hasSlvMinuteData = false.obs;
  RxBool hasIwmMinuteData = false.obs;
  RxBool hasXlkMinuteData = false.obs;
  RxBool hasAaplMinuteData = false.obs;
  RxBool hasBaMinuteData = false.obs;
  RxBool hasBacMinuteData = false.obs;
  RxBool hasMcdMinuteData = false.obs;
  RxBool hasNvdaMinuteData = false.obs;
  RxBool hasMsftMinuteData = false.obs;
  RxBool hasGskMinuteData = false.obs;
  RxBool hasTslaMinuteData = false.obs;
  RxBool hasAmznMinuteData = false.obs;

  /* Listings */
  RxInt listingsDownloadTime = 0.obs;
  RxList<SymbolAndName> listSymbolAndName =
      [const SymbolAndName(symbol: '', name: '')].obs;
  RxString listingErr = ''.obs;
  RxBool isListingInit = false.obs;
  late RxString listingsProviderMsg = Rx('listings'.tr)().obs;
  RxBool isListingsProviderErr = false.obs;

  /* Search */
  ValueNotifier<int> searchCountNotifier = ValueNotifier<int>(0);
  bool isSearchCountListenerAdded = false;
  RxBool alwaysSkipSymbolInSearch = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.alwaysSkipSymbolInSearch) ??
          false)
      .obs;
  RxBool alwayStrictMatchCriteria = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.alwayStrictMatchCriteria) ??
          false)
      .obs;
  RxBool strictMatchCriteria = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.alwayStrictMatchCriteria) ??
          false)
      .obs;
  RxBool alwaysMaMatchCriteria = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.alwaysMaMatchCriteria) ??
          false)
      .obs;
  RxBool maMatchCriteria = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.alwaysMaMatchCriteria) ??
          false)
      .obs;

  /* Chat */
  RxList<String> messages = (PrefsService.to.prefs
              .getStringList(SharedPreferencesConstant.messages) ??
          [
            "Hi! I'm your dedicated News AI, here to assist you in analyzing news related to your preferred stocks or ETFs! ^_^"
          ])
      .obs;
  RxBool isWaitingForReply = false.obs;
  RxInt aiResponseTime = 0.obs;
  RxBool firstQuestion = true.obs;
  ValueNotifier<bool> isWaitingForReplyNotifier = ValueNotifier<bool>(false);
  bool isWaitingForReplyNotifierAdded = false;

  /* Trend match */
  RxInt length =
      (PrefsService.to.prefs.getInt(SharedPreferencesConstant.length) ?? 4).obs;
  RxInt tolerance =
      (PrefsService.to.prefs.getInt(SharedPreferencesConstant.tolerance) ?? 40)
          .obs;
  RxList<double> selectedPeriodPercentDifferencesList = [0.0].obs;
  RxList<double> selectedPeriodActualDifferencesList = [0.0].obs;
  RxList<double> selectedPeriodActualPricesList = [0.0].obs;
  RxList<List<double>> comparePeriodPercentDifferencesListList = [
    [0.0]
  ].obs;
  RxList<List<double>> comparePeriodActualDifferencesListList = [
    [0.0]
  ].obs;
  RxList<List<double>> comparePeriodActualPricesListList = [
    [0.0]
  ].obs;
  RxList<List<double>> matchPercentDifferencesListList = [
    [0.0]
  ].obs;
  RxList<List<double>> matchActualDifferencesListList = [
    [0.0]
  ].obs;
  RxList<List<double>> matchActualPricesListList = [
    [0.0]
  ].obs;
  RxList<int> trendMatchOutput = [0, 0, 0, 0, 0].obs;
  RxList<int> matchRows = [0].obs;
  RxList<int> spyMatchRows = [0].obs; // Cross-data
  RxList<int> qqqMatchRows = [0].obs; // Cross-data
  RxList<int> usoMatchRows = [0].obs; // Cross-data
  RxList<int> gldMatchRows = [0].obs; // Cross-data
  RxList<int> slvMatchRows = [0].obs; // Cross-data
  RxList<int> iwmMatchRows = [0].obs; // Cross-data
  RxList<int> xlkMatchRows = [0].obs; // Cross-data
  RxList<int> aaplMatchRows = [0].obs; // Cross-data
  RxList<int> baMatchRows = [0].obs; // Cross-data
  RxList<int> bacMatchRows = [0].obs; // Cross-data
  RxList<int> mcdMatchRows = [0].obs; // Cross-data
  RxList<int> nvdaMatchRows = [0].obs; // Cross-data
  RxList<int> msftMatchRows = [0].obs; // Cross-data
  RxList<int> gskMatchRows = [0].obs; // Cross-data
  RxList<int> tslaMatchRows = [0].obs; // Cross-data
  RxList<int> amznMatchRows = [0].obs; // Cross-data
  RxBool trendMatched = false.obs;
  RxBool showAnalytics = false.obs;
  ValueNotifier<bool> showAnalyticsNotifier = ValueNotifier<bool>(false);
  bool isShowAnalyticsNotifierAdded = false;
  late RxDouble candleChartHeight = (showAnalytics.value ? 50.h : 100.h).obs;
  ValueNotifier<bool> chartExpandNotifier = ValueNotifier<bool>(true);
  bool isChartExpandNotifierAdded = false;
  Rx<IconData> expandOrShrinkIcon = Icons.vertical_align_center_rounded.obs;
  Rx<Widget> sidePlot = (const SizedBox.shrink()).obs;
  late RxDouble tmChartWidth =
      (Platform.isWindows || Platform.isLinux || Platform.isMacOS
          ? (Get.width - 5.w).obs
          : 135.w.obs);
  RxInt subLength =
      (PrefsService.to.prefs.getInt(SharedPreferencesConstant.subLength) ?? 12)
          .obs;
  RxInt maxMa = 240.obs;
  RxBool isLockTrend =
      (PrefsService.to.prefs.getBool(SharedPreferencesConstant.lockTrend) ??
              false)
          .obs;
  RxBool isFirstThirtyMins = true.obs;
  RxBool hitCeilingOrFloor = true.obs;
  RxBool goOpposite = true.obs;
  RxBool lowReturn = true.obs;
  RxBool lowProb = true.obs;
  RxString instruction = 'Awaiting for instruction...'.obs;
  RxDouble expectedReturn = 0.0.obs;
  RxDouble expectedMdd = 0.0.obs;
  RxList cluster = [].obs;

  /* Subsequent analytics */
  RxInt lastClosePriceAndSubsequentTrendsExeTime = 0.obs;
  RxInt cloudSubsequentAnalyticsTime = 0.obs;
  RxBool hasSubsequentAnalytics = false.obs;
  Rx<Uint8List> img1Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img2Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img3Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img4Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img5Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img6Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img7Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img8Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img9Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img10Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  RxString subsequentAnalyticsErr = ''.obs;
  RxInt numOfClusters = 0.obs;
  RxString maxSilhouetteScore = '0'.obs;
  ValueNotifier<bool> subsequentAnalyticsNotifier = ValueNotifier<bool>(false);
  bool isSubsequentAnalyticsNotifierAdded = false;
  RxInt saCount = 0.obs;

  // A 2nd initialization will be triggered when starting the app
  @override
  void onInit() {
    if (!isInit) {
      // PrefsService.to.prefs
      //     .setString(SharedPreferencesConstant.financialInstrumentSymbol, 'QQQ');
      // PrefsService.to.prefs.setString(
      //     SharedPreferencesConstant.financialInstrumentName,
      //     'Invesco QQQ Trust, Series 1');
      // PrefsService.to.prefs.setInt(SharedPreferencesConstant.range, 5);
      // PrefsService.to.prefs.setInt(SharedPreferencesConstant.tolerance, 100);
      // PrefsService.to.prefs
      //     .setStringList(SharedPreferencesConstant.watchlist, []);
      // PrefsService.to.prefs
      //     .setBool(SharedPreferencesConstant.alwaysShowMinuteData, false);
      alwaysUseCrossData.value = false;
      PrefsService.to.prefs
          .setBool(SharedPreferencesConstant.alwaysUseCrossData, false);

      matchRows.value = [];
      spyMatchRows.value = []; // Cross-data
      qqqMatchRows.value = []; // Cross-data
      usoMatchRows.value = []; // Cross-data
      gldMatchRows.value = []; // Cross-data
      slvMatchRows.value = []; // Cross-data
      iwmMatchRows.value = []; // Cross-data
      xlkMatchRows.value = []; // Cross-data
      aaplMatchRows.value = []; // Cross-data
      baMatchRows.value = []; // Cross-data
      bacMatchRows.value = []; // Cross-data
      mcdMatchRows.value = []; // Cross-data
      nvdaMatchRows.value = []; // Cross-data
      msftMatchRows.value = []; // Cross-data
      gskMatchRows.value = []; // Cross-data
      tslaMatchRows.value = []; // Cross-data
      amznMatchRows.value = []; // Cross-data

      isLockTrend.value = false;
      PrefsService.to.prefs.setBool(SharedPreferencesConstant.lockTrend, false);

      isInit = true;
    }

    super.onInit();
    if (!isDarkModeInit) {
      if (darkMode.value) {
        AppColor.primaryTextColor = Colors.white;
      } else {
        AppColor.primaryTextColor = Colors.black;
      }
      isDarkModeInit = true;
    }

    if (!isShowAverageListenerAdded) {
      showAverageNotifier.addListener(showAverageListener);
      isShowAverageListenerAdded = true;
    }

    if (!isDevModeListenerAdded) {
      devModeNotifier.addListener(devModeListener);
      isDevModeListenerAdded = true;
    }

    if (!isEnListenerAdded) {
      isEnNotifier.addListener(isEnListener);
      isEnListenerAdded = true;
    }

    if (!isSearchCountListenerAdded) {
      searchCountNotifier.addListener(isSearchCountListener);
      isSearchCountListenerAdded = true;
    }

    if (!isListingInit.value) {
      isListingInit.value =
          true; // Must set the value to true before invoking the method
      Listing().init();
    }

    if (!isShowAnalyticsNotifierAdded) {
      showAnalyticsNotifier.addListener(showAnalyticsListener);
      isShowAnalyticsNotifierAdded = true;
    }

    if (!isChartExpandNotifierAdded) {
      chartExpandNotifier.addListener(chartExpandListener);
      isChartExpandNotifierAdded = true;
    }

    if (!isSubsequentAnalyticsNotifierAdded) {
      subsequentAnalyticsNotifier.addListener(subsequentAnalyticsListener);
      isSubsequentAnalyticsNotifierAdded = true;
    }

    if (!isWaitingForReplyNotifierAdded) {
      isWaitingForReplyNotifier.addListener(isWaitingForReplyListener);
      isWaitingForReplyNotifierAdded = true;
    }
  }

  void showAverageListener() {
    // Perform actions based on the new value of showAverage
    if (showAverageNotifier.value) {
      // Show the average
      Candle().computeTrendLines();
    } else {
      // Hide the average
      Candle().removeTrendLines();
    }
  }

  void devModeListener() {
    devMode.toggle();
    if (devModeNotifier.value) {
      Get.snackbar(
          'system_info'.tr,
          colorText: AppColor.whiteColor,
          backgroundColor: AppColor.greyColor,
          icon: const Icon(Icons.settings),
          'dev_mode'.tr);
      showAnalyticsNotifier.value = true;
    }
  }

  void isEnListener() {
    if (isEnNotifier.value) {
      LangService.to.changeLanguage(Lang.en);
      if (!isLockTrend.value) {
        SubsequentAnalytics().init();
      }
    } else {
      LangService.to.changeLanguage(Lang.zh);
      if (!isLockTrend.value) {
        SubsequentAnalytics().init();
      }
    }
  }

  void isSearchCountListener() {
    bookmarked.value = watchlist.contains(financialInstrumentSymbol.value)
        ? Icons.bookmark_outlined
        : Icons.bookmark_border_outlined;
    futureListCandledata.value = init();
  }

  void showAnalyticsListener() {
    if (showAnalyticsNotifier.value) {
      showAnalytics.value = true;
      chartExpandNotifier.value = false;
    } else {
      showAnalytics.value = false;
      chartExpandNotifier.value = true;
    }
  }

  void chartExpandListener() {
    if (chartExpandNotifier.value) {
      candleChartHeight.value = 100.h;
      expandOrShrinkIcon.value = Icons.vertical_align_center_rounded;
    } else {
      candleChartHeight.value = 50.h;
      expandOrShrinkIcon.value = Icons.expand;
    }
  }

  void subsequentAnalyticsListener() {
    double width = (Platform.isWindows || Platform.isLinux || Platform.isMacOS
        ? (Get.width - 10.w)
        : 135.w);
    if (subsequentAnalyticsNotifier.value &&
        subsequentAnalyticsErr.value != '') {
      hasSubsequentAnalytics.value = true;
      sidePlot.value = const SizedBox.shrink();
      tmChartWidth.value = width;
    } else if (subsequentAnalyticsNotifier.value &&
        subsequentAnalyticsErr.value == '') {
      hasSubsequentAnalytics.value = true;
      var img10 = img10Bytes.value;
      if (img10.isEmpty ||
          img10.toString() == Uint8List.fromList([0]).toString()) {
        sidePlot.value = const SizedBox.shrink();
        tmChartWidth.value = width;
      } else {
        sidePlot.value = SizedBox(
            child: Padding(
          padding: EdgeInsets.only(top: 7.5.h),
          child: Image.memory(
            img10,
            width: (Platform.isWindows || Platform.isLinux || Platform.isMacOS
                ? ((Get.width - 5.w) * 0.3)
                : 52.5.w),
            height: (Platform.isWindows || Platform.isLinux || Platform.isMacOS
                ? 110.1.h
                : 80.h),
            fit: BoxFit.fill,
          ),
        ));
        tmChartWidth.value =
            (Platform.isWindows || Platform.isLinux || Platform.isMacOS
                ? ((Get.width - 5.w) * 0.7)
                : 90.w);
      }
    } else {
      sidePlot.value = const SizedBox.shrink();
      tmChartWidth.value = width;
      hasSubsequentAnalytics.value = false;
    }
  }

  void isWaitingForReplyListener() {
    if (isWaitingForReplyNotifier.value) {
      isWaitingForReply.value = true;
    } else {
      isWaitingForReply.value = false;
    }
  }

  @override
  void dispose() {
    Get.delete<MainPresenter>();
    super.dispose();
  }

  Future<List<CandleData>> init() async {
    if (!alwaysShowAnalytics.value) {
      showAnalyticsNotifier.value = false;
    } else {
      showAnalyticsNotifier.value = true;
    }
    if (apiKey.value == '' && alwaysShowMinuteData.value) {
      MainPresenter.to.marketDataProviderMsg.value =
          'No API key to access Firestore with';
      MainPresenter.to.isMarketDataProviderErr.value = true;
    } else {
      // listCandledata.value = dummyCandle;
      await Candle().init();
      // for (final data in listCandledata) {
      //   if (data.open == 463.39) {
      //     print(data.toString());
      //     print(data.timestamp.toString());
      //   }
      // }
      if (showAverageNotifier.value) {
        await Candle().computeTrendLines();
      }
      if (listCandledata.isNotEmpty && !isLockTrend.value) {
        await TrendMatch().init();
        if (apiKey.value != '') {
          SubsequentAnalytics().init();
        }
      }
    }
    checkMinuteData();
    return listCandledata;
  }

  void checkMinuteData() async {
    final isar = await IsarService().getIsarInstance();
    var spyData = await isar.spyDatas.where().findFirst();
    var qqqData = await isar.qqqDatas.where().findFirst();
    var usoData = await isar.usoDatas.where().findFirst();
    var gldData = await isar.gldDatas.where().findFirst();
    var slvData = await isar.slvDatas.where().findFirst();
    var iwmData = await isar.iwmDatas.where().findFirst();
    var xlkData = await isar.xlkDatas.where().findFirst();
    var aaplData = await isar.aaplDatas.where().findFirst();
    var baData = await isar.baDatas.where().findFirst();
    var bacData = await isar.bacDatas.where().findFirst();
    var mcdData = await isar.mcdDatas.where().findFirst();
    var nvdaData = await isar.nvdaDatas.where().findFirst();
    var msftData = await isar.msftDatas.where().findFirst();
    var gskData = await isar.gskDatas.where().findFirst();
    var tslaData = await isar.tslaDatas.where().findFirst();
    var amznData = await isar.amznDatas.where().findFirst();
    if (spyData == null) {
      hasSpyMinuteData.value = false;
    } else {
      hasSpyMinuteData.value = true;
    }
    if (qqqData == null) {
      hasQqqMinuteData.value = false;
    } else {
      hasQqqMinuteData.value = true;
    }
    if (usoData == null) {
      hasUsoMinuteData.value = false;
    } else {
      hasUsoMinuteData.value = true;
    }
    if (gldData == null) {
      hasGldMinuteData.value = false;
    } else {
      hasGldMinuteData.value = true;
    }
    if (slvData == null) {
      hasSlvMinuteData.value = false;
    } else {
      hasSlvMinuteData.value = true;
    }
    if (iwmData == null) {
      hasIwmMinuteData.value = false;
    } else {
      hasIwmMinuteData.value = true;
    }
    if (xlkData == null) {
      hasXlkMinuteData.value = false;
    } else {
      hasXlkMinuteData.value = true;
    }
    if (aaplData == null) {
      hasAaplMinuteData.value = false;
    } else {
      hasAaplMinuteData.value = true;
    }
    if (baData == null) {
      hasBaMinuteData.value = false;
    } else {
      hasBaMinuteData.value = true;
    }
    if (bacData == null) {
      hasBacMinuteData.value = false;
    } else {
      hasBacMinuteData.value = true;
    }
    if (mcdData == null) {
      hasMcdMinuteData.value = false;
    } else {
      hasMcdMinuteData.value = true;
    }
    if (nvdaData == null) {
      hasNvdaMinuteData.value = false;
    } else {
      hasNvdaMinuteData.value = true;
    }
    if (msftData == null) {
      hasMsftMinuteData.value = false;
    } else {
      hasMsftMinuteData.value = true;
    }
    if (gskData == null) {
      hasGskMinuteData.value = false;
    } else {
      hasGskMinuteData.value = true;
    }
    if (tslaData == null) {
      hasTslaMinuteData.value = false;
    } else {
      hasTslaMinuteData.value = true;
    }
    if (amznData == null) {
      hasAmznMinuteData.value = false;
    } else {
      hasAmznMinuteData.value = true;
    }
  }

  /* Route */
  void route(String path) {
    Get.toNamed(path);
  }

  void back() {
    Get.back();
  }

  /* UI Logic (mainly focused on show/hide) */
  List<Widget> buildListingRelatedIcons({required BuildContext context}) {
    if (isListingInit.value) {
      return [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            if (!MainPresenter.to.isLockTrend.value) {
              MainPresenter.to.route(RouteName.searchView.path);
            } else {
              showScaffoldMessenger(
                  context: context, localizedMsg: 'lock_trend_alert'.tr);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.contact_support),
          onPressed: () {
            MainPresenter.to.route(RouteName.chatView.path);
          },
        ),
      ];
    } else {
      return [];
    }
  }

  Widget showTm() {
    return Obx(() {
      if (trendMatched.value && showAnalytics.value) {
        return TrendMatchView().showAdjustedLineChart();
      } else if (showAnalytics.value) {
        return TrendMatchView().showCircularProgressIndicator();
      }
      return const SizedBox.shrink();
    });
  }

  Widget showCluster() {
    return Obx(() {
      if (trendMatched.value && showAnalytics.value) {
        return TrendMatchView().showAdjustedLineChart();
      }
      return const SizedBox.shrink();
    });
  }

  Widget showStartBtn() {
    return Obx(() {
      if (showAnalytics.value) {
        return const SizedBox.shrink();
      } else {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: ElevatedButton.icon(
            onPressed: () {
              MainPresenter.to.showAnalyticsNotifier.value = true;
            },
            icon: Icon(
              Icons.analytics_outlined,
              size: 20.h,
            ),
            label: Text(
              'btn_tm_sa'.tr,
              style: const TextTheme().sp5.w700,
            ),
          ),
        );
      }
    });
  }

  Widget showDevModeViewOne(bool devMode) {
    if (devMode) {
      return MainView().devModeViewOne();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget showDevModeViewTwo(bool devMode) {
    if (devMode) {
      return MainView().devModeViewTwo();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget showSa() {
    return Obx(() {
      if ((hasSubsequentAnalytics.value &&
              showAnalytics.value &&
              devMode.value &&
              apiKey.value != '') ||
          (showAnalytics.value &&
              devMode.value &&
              apiKey.value != '' &&
              isLockTrend.value)) {
        if (subsequentAnalyticsErr.value == '' && apiKeyErr.value == '') {
          return Column(
            children: [
              SubsequentAnalyticsView().showSaChart(),
              SubsequentAnalyticsView().showSaDevChart(),
            ],
          );
        } else if (apiKeyErr.value == '') {
          return SubsequentAnalyticsView().showError();
        } else {
          return Column(
            children: [
              SubsequentAnalyticsView().showError(),
              showApiKeyReminder(),
            ],
          );
        }
      } else if ((hasSubsequentAnalytics.value &&
              showAnalytics.value &&
              apiKey.value != '') ||
          (showAnalytics.value && apiKey.value != '' && isLockTrend.value)) {
        if (subsequentAnalyticsErr.value == '' && apiKeyErr.value == '') {
          return SubsequentAnalyticsView().showSaChart();
        } else if (apiKeyErr.value == '') {
          return SubsequentAnalyticsView().showError();
        } else {
          return Column(
            children: [
              SubsequentAnalyticsView().showError(),
              showApiKeyReminder(),
            ],
          );
        }
      } else if (showAnalytics.value && apiKey.value != '') {
        return SubsequentAnalyticsView().showCircularProgressIndicator();
      } else if (showAnalytics.value) {
        showApiKeyInput();
        return showApiKeyReminder();
      }
      return const SizedBox.shrink();
    });
  }

  Widget buildListingSourceRichText() {
    final imageSpan = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColor.imageDefaultBgColor,
          ),
          child: Image.asset(
            'images/nasdaq.png',
            height: 6.h,
          ),
        ),
      ),
    );
    final imageSpan2 = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColor.imageDefaultBgColor,
          ),
          child: Image.asset(
            'images/nyse.png',
            height: 7.h,
          ),
        ),
      ),
    );
    final imageSpan3 = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Transform.translate(
          offset: Offset(0.0, 3.h),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColor.imageDefaultBgColor,
            ),
            child: Image.asset(
              'images/amex.png',
              height: 12.h,
            ),
          ),
        ),
      ),
    );

    return RichText(
      text: TextSpan(
        text: listingsProviderMsg.value,
        children: [imageSpan, imageSpan2, imageSpan3],
        style: const TextTheme().sp4.greyColor,
      ),
    );
  }

  Widget buildMktDataProviderRichText() {
    return Obx(
      () => Row(
        children: [
          (alwaysShowMinuteData.value
              ? Padding(
                  padding: EdgeInsets.only(right: 3.w),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColor.imageDefaultBgColor,
                    ),
                    child: Image.asset(
                      'images/futubull.png',
                      height: (Platform.isWindows ||
                              Platform.isLinux ||
                              Platform.isMacOS
                          ? 8.h
                          : 6.h), // Adjust the height as needed
                    ),
                  ),
                )
              : const SizedBox.shrink()),
          Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColor.imageDefaultBgColor,
              ),
              child: Image.asset(
                'images/yahoofinance.png',
                height:
                    (Platform.isWindows || Platform.isLinux || Platform.isMacOS
                        ? 8.h
                        : 6.h), // Adjust the height as needed
              ),
            ),
          ),
          Text(
            marketDataProviderMsg.value,
            style: const TextTheme().sp4.greyColor,
          ),
        ],
      ),
    );
  }

  Widget buildCloudFunctionCol() {
    final imageSpan = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Transform.translate(
          offset: Offset(0.0, 3.h),
          child: Image.asset(
            'images/cloudfunction.png',
            height: (Platform.isWindows || Platform.isLinux || Platform.isMacOS
                ? 25.h
                : 18.h), // Adjust the height as needed
          ),
        ),
      ),
    );
    final textSpan = WidgetSpan(
      child: Padding(
          padding: EdgeInsets.only(left: 3.w),
          child: Text(
            'x',
            style: const TextTheme().sp10.greyColor,
          )),
    );
    final imageSpan2 = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Transform.translate(
          offset: Offset(0.0, 3.h),
          child: Image.asset(
            'images/hsuhk_cs_dept.png',
            height: (Platform.isWindows || Platform.isLinux || Platform.isMacOS
                ? 25.h
                : 18.h), // Adjust the height as needed
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            'power_from'.tr,
            style: const TextTheme().sp4.greyColor,
          ),
        ),
        Center(
          child: RichText(
            text: TextSpan(
              children: [imageSpan, textSpan, imageSpan2],
              style: const TextTheme().sp4.greyColor,
            ),
          ),
        ),
        SizedBox(height: 50.h),
      ],
    );
  }

  void changeAppearance() {
    darkMode.toggle();
    if (darkMode.value) {
      AppColor.primaryTextColor = Colors.white;
    } else {
      AppColor.primaryTextColor = Colors.black;
    }
    PrefsService.to.prefs
        .setBool(SharedPreferencesConstant.darkMode, darkMode.value);
  }

  clearMsg() {
    messages.value = messages.sublist(0, 1); // newList will be ["first"]
    PrefsService.to.prefs
        .setStringList(SharedPreferencesConstant.messages, messages);
    firstQuestion.value = true;
  }

  void bookmarkThis({required BuildContext context}) {
    if (watchlist.contains(financialInstrumentSymbol.value)) {
      bookmarked.value = Icons.bookmark_border_outlined;
      watchlist.remove(financialInstrumentSymbol.value);
      PrefsService.to.prefs
          .setStringList(SharedPreferencesConstant.watchlist, watchlist);
    } else {
      if (watchlist.length >= 16) {
        Get.snackbar(
            'notice'.tr,
            colorText: AppColor.whiteColor,
            backgroundColor: AppColor.errorColor,
            icon: const Icon(Icons.error),
            'watchlist_max'.tr);
      } else {
        bookmarked.value = Icons.bookmark_outlined;
        watchlist.add(financialInstrumentSymbol.value);
        PrefsService.to.prefs
            .setStringList(SharedPreferencesConstant.watchlist, watchlist);
        showScaffoldMessenger(
          context: context,
          localizedMsg: 'bookmarked'.tr,
        );
      }
    }
  }

  List<PopupMenuEntry<String>> popMenuItems() {
    List<PopupMenuEntry<String>> watchlistMenuItems;
    if (watchlist.isEmpty) {
      watchlistMenuItems = [
        PopupMenuItem<String>(
          value: 'watchlistEmpty',
          child: Text(
            'watchlistEmpty'.tr,
            style: const TextTheme().sp4.primaryTextColor,
          ),
        ),
      ];
    } else {
      watchlistMenuItems = watchlist.map((String item) {
        return PopupMenuItem<String>(
          value: item,
          child: ListTile(
            leading: Icon(
              Icons.bookmark_outlined,
              color: ThemeColor.primary.value,
            ),
            title: Text(
              item,
              style: const TextTheme().sp4.primaryTextColor,
            ),
          ),
        );
      }).toList();
    }
    return watchlistMenuItems;
  }

  refreshIndicator() {
    futureListCandledata.value = init();
  }

  alwaysShowAnalyticsToggle(bool value) {
    alwaysShowAnalytics.value = value;
    PrefsService.to.prefs
        .setBool(SharedPreferencesConstant.alwaysShowAnalytics, value);
  }

  alwaysShowSdDistPlotToggle(bool value) {
    alwaysShowSdDistPlot.value = value;
    PrefsService.to.prefs
        .setBool(SharedPreferencesConstant.alwaysShowSdDistPlot, value);
  }

  alwaysSkipSymbolInSearchToggle(bool value) {
    alwaysSkipSymbolInSearch.value = value;
    PrefsService.to.prefs
        .setBool(SharedPreferencesConstant.alwaysSkipSymbolInSearch, value);
  }

  alwayStrictMatchCriteriaToggle(bool value) {
    alwayStrictMatchCriteria.value = value;
    PrefsService.to.prefs
        .setBool(SharedPreferencesConstant.alwayStrictMatchCriteria, value);
    strictMatchCriteria.value = value;
  }

  alwayMaMatchCriteriaToggle(bool value) {
    alwaysMaMatchCriteria.value = value;
    PrefsService.to.prefs
        .setBool(SharedPreferencesConstant.alwaysMaMatchCriteria, value);
    maMatchCriteria.value = value;
  }

  alwaysShowMinuteDataToggle(bool value, BuildContext context) {
    if (!isLockTrend.value) {
      alwaysShowMinuteData.value = value;
      PrefsService.to.prefs
          .setBool(SharedPreferencesConstant.alwaysShowMinuteData, value);
      dataGranularity.value = (value ? Icons.timer_outlined : Icons.today);
      if (value) {
        legends.value = '🟠EMA5 🔴EMA10 🟢EMA15 🔵EMA20';
        showScaffoldMessenger(
            context: context, localizedMsg: 'show_one_minute');
      } else {
        legends.value = '🟠MA5 🔴MA20 🟢MA60 🔵MA120 🟣MA240';
        showScaffoldMessenger(context: context, localizedMsg: 'show_one_day');
      }
      futureListCandledata.value = init();
    } else {
      showScaffoldMessenger(
          context: context, localizedMsg: 'lock_trend_alert'.tr);
    }
  }

  alwaysUseCrossDataToggle(bool value, BuildContext context) {
    if (!isLockTrend.value) {
      alwaysUseCrossData.value = value;
      PrefsService.to.prefs
          .setBool(SharedPreferencesConstant.alwaysUseCrossData, value);
      crossData.value = (value ? Icons.dataset_linked : Icons.dataset);
      if (value) {
        showScaffoldMessenger(context: context, localizedMsg: 'cross_data');
      } else {
        showScaffoldMessenger(context: context, localizedMsg: 'cross_data_off');
      }
      futureListCandledata.value = init();
    } else {
      showScaffoldMessenger(
          context: context, localizedMsg: 'lock_trend_alert'.tr);
    }
  }

  showApiKeyInput() {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        'notice'.tr,
        colorText: AppColor.whiteColor,
        backgroundColor: AppColor.errorColor,
        icon: const Icon(Icons.error),
        'api_key'.tr,
        duration: const Duration(seconds: 60),
        userInputForm: Form(
          key: formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  initialValue: apiKey.value,
                  decoration: InputDecoration(
                    errorStyle: const TextTheme().sp4.whiteColor,
                    hintText: 'api_key'.tr,
                    hintStyle: const TextTheme().sp5.whiteColor,
                    prefixIcon: const Icon(Icons.key),
                    prefixIconColor: AppColor.whiteColor,
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'api_key_validation'.tr;
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    apiKey.value = value!;
                    PrefsService.to.prefs.setString(
                        SharedPreferencesConstant.apiKey, apiKey.value);
                    apiKeyErr.value = '';
                    PrefsService.to.prefs
                        .setString(SharedPreferencesConstant.apiKeyErr, '');
                    if (!MainPresenter.to.isLockTrend.value) {
                      TrendMatch().init();
                      SubsequentAnalytics().init();
                    }
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    Get.closeCurrentSnackbar();
                  }
                },
                child: Text(
                  'submit'.tr,
                  style: const TextTheme().sp5,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget showApiKeyReminder() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: ElevatedButton.icon(
        onPressed: () {
          showApiKeyInput();
        },
        icon: Icon(
          Icons.key_off,
          size: 5.h,
        ),
        label: Text(
          'apikey_reminder'.tr,
          style: const TextTheme().sp5.w700,
        ),
      ),
    );
  }

  Widget showMinuteDataToggleBtn({required BuildContext context}) {
    if (hasMinuteData.value) {
      return IconButton(
        onPressed: () =>
            alwaysShowMinuteDataToggle(!alwaysShowMinuteData.value, context),
        icon: Obx(
          () => Icon(
            MainPresenter.to.dataGranularity.value,
          ),
        ),
        color: ThemeColor.primary.value,
        iconSize: 10.h,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget showCrossDataToggleBtn({required BuildContext context}) {
    if (hasMinuteData.value) {
      return IconButton(
        onPressed: () =>
            alwaysUseCrossDataToggle(!alwaysUseCrossData.value, context),
        icon: Obx(
          () => Icon(
            MainPresenter.to.crossData.value,
          ),
        ),
        color: ThemeColor.primary.value,
        iconSize: 10.h,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  void showScaffoldMessenger(
      {required BuildContext context, required String localizedMsg}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Center(
        child: Text(
          localizedMsg.tr,
          style: const TextTheme().sp5.greyColor,
        ),
      ),
    ));
  }

  String getLastDatetime() {
    if (MainPresenter.to.candleListList.isNotEmpty) {
      var lastDatetime = MainPresenter.to.candleListList.last[0];
      // print(lastDatetime);
      try {
        if (alwaysShowMinuteData.value && hasMinuteData.value) {
          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
              lastDatetime.toInt() * 1000,
              isUtc: true);
          DateTime subtractedDateTime =
              TimeService.to.subtractHoursBasedOnTimezone(dateTime);
          lastDatetime =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(subtractedDateTime);
          String timezone =
              TimeService.to.isEasternDaylightTime(dateTime) ? 'EDT' : 'EST';
          return '${'as_of'.tr} $lastDatetime $timezone.';
        } else {
          return '${'as_of'.tr} $lastDatetime.';
        }
      } catch (e) {
        return 'Failed to fetch datetime';
      }
    } else {
      return 'Loading';
    }
  }

  String showCandleListListLastItem({required int i}) {
    if (MainPresenter.to.candleListList.isNotEmpty) {
      return MainPresenter.to.candleListList.last[i].toString();
    } else {
      return 'Loading';
    }
  }

  Widget showCandlestickChart(
      {required AsyncSnapshot<List<CandleData>> snapshot}) {
    if (hasCandleData.value) {
      return Obx(
        () => SizedBox(
          width: 393.w,
          height: MainPresenter.to.candleChartHeight.value,
          child: InteractiveChart(
            candles: (snapshot.data!.length > 1000
                ? snapshot.data!
                    .sublist(snapshot.data!.length - 999, snapshot.data!.length)
                : snapshot.data!),
            style: ChartStyle(
              trendLineStyles: [
                Paint()
                  ..strokeWidth = 1.0
                  ..strokeCap = StrokeCap.round
                  ..color = Colors.orange,
                Paint()
                  ..strokeWidth = 1.0
                  ..strokeCap = StrokeCap.round
                  ..color = Colors.red,
                Paint()
                  ..strokeWidth = 1.0
                  ..strokeCap = StrokeCap.round
                  ..color = Colors.green,
                Paint()
                  ..strokeWidth = 1.0
                  ..strokeCap = StrokeCap.round
                  ..color = Colors.blue[700]!,
                Paint()
                  ..strokeWidth = 1.0
                  ..strokeCap = StrokeCap.round
                  ..color = Colors.purple[300]!,
                // Paint()
                //   ..strokeWidth = 1.0
                //   ..strokeCap = StrokeCap.round
                //   ..color = Colors.yellow,
              ],
              selectionHighlightColor: Colors.red.withOpacity(0.75),
              overlayBackgroundColor: Colors.red.withOpacity(0.75),
              overlayTextStyle: const TextStyle(color: AppColor.whiteColor),
            ),
            /** Callbacks */
            // onTap: (candle) => print("user tapped on $candle"),
          ),
        ),
      );
    } else {
      return Center(
        child: Column(
          children: [
            LoadingAnimationWidget.staggeredDotsWave(
              color: ThemeColor.primary.value,
              size: 25.w,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child:
                  Text('downloading_candle'.tr, style: const TextTheme().sp5),
            ),
          ],
        ),
      );
    }
  }

  Widget showMatchesExceededMsg() {
    if (MainPresenter.to.matchRows.length > 500) {
      return Text('more_than_500_matches'.tr, style: const TextTheme().sp5);
    } else {
      return const SizedBox.shrink();
    }
  }
}
