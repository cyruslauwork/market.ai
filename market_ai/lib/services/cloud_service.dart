import 'dart:convert';

import 'package:get/get.dart';
import 'package:market_ai/presenters/presenters.dart';

import 'package:market_ai/services/services.dart';

// import 'package:market_ai/utils/utils.dart';

class CloudService extends GetxService {
  // Singleton implementation
  static final CloudService _instance = CloudService._();
  factory CloudService() => _instance;
  CloudService._();

  static HTTPService get to => Get.find();

  Future<CloudService> init() async {
    return this;
  }

  Future<Map<String, dynamic>> fetchCsvAndPng({
    required List<List<double>> lastClosePriceAndSubsequentTrends,
    required double minValueOfAllTrends,
    required double maxValueOfAllTrends,
    required String apiKey,
  }) async {
    String encodedTrends = jsonEncode(lastClosePriceAndSubsequentTrends);
    String lang = LangService.to.currentLang.langCode;

    /* POST method */
    Map<String, dynamic> parsedResponse = await HTTPService()
        .postFetchJson('http://${MainPresenter.to.jumpServerUrl.value}/', {
      'api_key': apiKey,
      'sub_trend': encodedTrends,
      'func': 'subtrend-to-csv-png',
      'lang': lang,
      'min_value': '$minValueOfAllTrends',
      'max_value': '$maxValueOfAllTrends',
    });

    return parsedResponse;
  }

  Future<String> fetchNewsAnalytics(
      {String? symbolAndName, String? symbols, String? question}) async {
    String urlEncodedApiKey =
        Uri.encodeComponent(MainPresenter.to.apiKey.value);
    if (symbolAndName != null) {
      /* GET method */
      String urlEncodedSymbolAndName = Uri.encodeComponent(symbolAndName);
      // log(urlEncodedSymbolAndName);
      String response = await HTTPService().getFetchString(
          'http://${MainPresenter.to.jumpServerUrl.value}/?func=gemini-pro-news&symbol_and_name=$urlEncodedSymbolAndName&api_key=$urlEncodedApiKey');
      if (response == Err.apiKey.name) {
        MainPresenter.to.apiKeyErr.value = response;
        PrefsService.to.prefs
            .setString(SharedPreferencesConstant.apiKeyErr, response);
        MainPresenter.to.showApiKeyInput();
      }
      return response;
    } else if (symbols != null && question != null) {
      /* GET method */
      String urlEncodedSymbols = Uri.encodeComponent(symbols);
      String urlEncodedQuestion = Uri.encodeComponent(question);
      // log(urlEncodedSymbols);
      // log(urlEncodedQuestion);
      String response = await HTTPService().getFetchString(
          'http://${MainPresenter.to.jumpServerUrl.value}/?func=gemini-pro-news-custom&symbols=$urlEncodedSymbols&question=$urlEncodedQuestion&api_key=$urlEncodedApiKey');
      if (response == Err.apiKey.name) {
        MainPresenter.to.apiKeyErr.value = response;
        PrefsService.to.prefs
            .setString(SharedPreferencesConstant.apiKeyErr, response);
        MainPresenter.to.showApiKeyInput();
      }
      return response;
    } else {
      throw ArgumentError(
          'Must have correct passing parameter value(s) to fetch news analytics.');
    }
  }
}
