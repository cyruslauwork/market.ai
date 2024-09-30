import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:market_ai/models/models.dart';
import 'package:market_ai/presenters/presenters.dart';
import 'package:market_ai/services/services.dart';
import 'package:market_ai/styles/styles.dart';
import 'package:market_ai/utils/utils.dart';

class SearchView extends StatefulWidget {
  // const SearchView({Key? key}) : super(key: key);

  // Singleton implementation
  static SearchView? _instance;
  factory SearchView({Key? key}) {
    _instance ??= SearchView._(key: key);
    return _instance!;
  }
  const SearchView._({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  double _currentCandleTolerance = (PrefsService.to.prefs
          .getDouble(SharedPreferencesConstant.candleTolerance) ??
      40.0);
  double _currentPriceTolerance = (PrefsService.to.prefs
          .getDouble(SharedPreferencesConstant.priceTolerance) ??
      40.0);
  double _currentMaTolerance =
      (PrefsService.to.prefs.getDouble(SharedPreferencesConstant.maTolerance) ??
          40.0);
  double _currentFirstMaTolerance = (PrefsService.to.prefs
          .getDouble(SharedPreferencesConstant.firstMaTolerance) ??
      40.0);
  double _currentEma1520Vwma20Tolerance = (PrefsService.to.prefs
          .getDouble(SharedPreferencesConstant.ema1520Vwma20Tolerance) ??
      40.0);
  double _currentEma40Tolerance = (PrefsService.to.prefs
          .getDouble(SharedPreferencesConstant.ema40Tolerance) ??
      40.0);
  double _currentEma60Tolerance = (PrefsService.to.prefs
          .getDouble(SharedPreferencesConstant.ema60Tolerance) ??
      40.0);
  double _currentEma120Tolerance = (PrefsService.to.prefs
          .getDouble(SharedPreferencesConstant.ema120Tolerance) ??
      40.0);
  double _currentEma1520Vwma20FirstTolerance = (PrefsService.to.prefs
          .getDouble(SharedPreferencesConstant.firstEma1520Vwma20Tolerance) ??
      40.0);
  double _currentEma40FirstTolerance = (PrefsService.to.prefs
          .getDouble(SharedPreferencesConstant.firstEma40Tolerance) ??
      40.0);
  double _currentEma60FirstTolerance = (PrefsService.to.prefs
          .getDouble(SharedPreferencesConstant.firstEma60Tolerance) ??
      40.0);
  double _currentEma120FirstTolerance = (PrefsService.to.prefs
          .getDouble(SharedPreferencesConstant.firstEma120Tolerance) ??
      40.0);
  int _currentLength =
      PrefsService.to.prefs.getInt(SharedPreferencesConstant.length) ?? 4;
  TextEditingController _textEditingController = TextEditingController();
  bool _autocomplete = true;
  List<SymbolAndName> listSymbolAndName = MainPresenter.to.listSymbolAndName;
  int _currentSubLength =
      PrefsService.to.prefs.getInt(SharedPreferencesConstant.subLength) ?? 12;

  Widget sizedBox = const SizedBox.shrink();
  final ScrollController _scrollController = ScrollController();

  static String _displayStringForOption(SymbolAndName option) =>
      '${option.symbol} (${option.name.length >= 40 ? '${option.name.substring(0, 40)}...' : option.name})';

  void _resetForm() {
    setState(() {
      _currentCandleTolerance = 40.0;
      _currentPriceTolerance = 40.0;
      _currentFirstMaTolerance = 40.0;
      _currentMaTolerance = 40.0;
      _currentEma1520Vwma20Tolerance = 40.0;
      _currentEma40Tolerance = 40.0;
      _currentEma60Tolerance = 40.0;
      _currentEma120Tolerance = 40.0;
      _currentEma1520Vwma20FirstTolerance = 40.0;
      _currentEma40FirstTolerance = 40.0;
      _currentEma60FirstTolerance = 40.0;
      _currentEma120FirstTolerance = 40.0;
      _currentLength = 5;
      _textEditingController.clear();
      _currentSubLength = 5;
    });
  }

  void _submitForm() {
    bool hasText = _textEditingController.text != '' ? true : false;
    bool skipSymbolInSearch = MainPresenter.to.alwaysSkipSymbolInSearch.value;
    final String symbol;
    if (!hasText && skipSymbolInSearch) {
      symbol = MainPresenter.to.financialInstrumentSymbol.value;
    } else {
      symbol = _textEditingController.text.toUpperCase();
    }
    if (hasText || skipSymbolInSearch) {
      bool textMatchesSymbol = listSymbolAndName
          .any((SymbolAndName symbolAndName) => symbolAndName.symbol == symbol);
      if (textMatchesSymbol) {
        String newName = listSymbolAndName
            .firstWhere(
                (SymbolAndName symbolAndName) => symbolAndName.symbol == symbol)
            .name;
        PrefsService.to.prefs.setString(
            SharedPreferencesConstant.financialInstrumentName, newName);
        MainPresenter.to.financialInstrumentName.value = newName;
        String newSymbol = symbol;
        PrefsService.to.prefs.setString(
            SharedPreferencesConstant.financialInstrumentSymbol, newSymbol);
        MainPresenter.to.financialInstrumentSymbol.value = newSymbol;
        int newLength = _currentLength;
        PrefsService.to.prefs
            .setInt(SharedPreferencesConstant.length, newLength);
        MainPresenter.to.length.value = newLength;
        double newCandleTolerance = _currentCandleTolerance;
        PrefsService.to.prefs.setDouble(
            SharedPreferencesConstant.candleTolerance, newCandleTolerance);
        MainPresenter.to.candleTolerance.value = newCandleTolerance;
        double newPriceTolerance = _currentPriceTolerance;
        PrefsService.to.prefs.setDouble(
            SharedPreferencesConstant.priceTolerance, newPriceTolerance);
        MainPresenter.to.priceTolerance.value = newPriceTolerance;
        double newMaTolerance = _currentMaTolerance;
        PrefsService.to.prefs
            .setDouble(SharedPreferencesConstant.maTolerance, newMaTolerance);
        MainPresenter.to.maTolerance.value = newMaTolerance;
        double newFirstMaTolerance = _currentFirstMaTolerance;
        PrefsService.to.prefs.setDouble(
            SharedPreferencesConstant.firstMaTolerance, newFirstMaTolerance);
        MainPresenter.to.firstMaTolerance.value = newFirstMaTolerance;
        int newSubLength = _currentSubLength;
        PrefsService.to.prefs
            .setInt(SharedPreferencesConstant.subLength, newSubLength);
        MainPresenter.to.subLength.value = newSubLength;
        double newEma1520Vwma20Tolerance = _currentEma1520Vwma20Tolerance;
        PrefsService.to.prefs.setDouble(
            SharedPreferencesConstant.ema1520Vwma20Tolerance,
            newEma1520Vwma20Tolerance);
        MainPresenter.to.ema1520Vwma20Tolerance.value =
            newEma1520Vwma20Tolerance;
        double newEma40Tolerance = _currentEma40Tolerance;
        PrefsService.to.prefs.setDouble(
            SharedPreferencesConstant.ema40Tolerance, newEma40Tolerance);
        MainPresenter.to.ema40Tolerance.value = newEma40Tolerance;
        double newEma60Tolerance = _currentEma60Tolerance;
        PrefsService.to.prefs.setDouble(
            SharedPreferencesConstant.ema60Tolerance, newEma60Tolerance);
        MainPresenter.to.ema60Tolerance.value = newEma60Tolerance;
        double newEma120Tolerance = _currentEma120Tolerance;
        PrefsService.to.prefs.setDouble(
            SharedPreferencesConstant.ema120Tolerance, newEma120Tolerance);
        MainPresenter.to.ema120Tolerance.value = newEma120Tolerance;
        double newFirstEma1520Vwma20Tolerance =
            _currentEma1520Vwma20FirstTolerance;
        PrefsService.to.prefs.setDouble(
            SharedPreferencesConstant.firstEma1520Vwma20Tolerance,
            newFirstEma1520Vwma20Tolerance);
        MainPresenter.to.firstEma1520Vwma20Tolerance.value =
            newFirstEma1520Vwma20Tolerance;
        double newFirstEma40Tolerance = _currentEma40FirstTolerance;
        PrefsService.to.prefs.setDouble(
            SharedPreferencesConstant.firstEma40Tolerance,
            newFirstEma40Tolerance);
        MainPresenter.to.firstEma40Tolerance.value = newFirstEma40Tolerance;
        double newFirstEma60Tolerance = _currentEma60FirstTolerance;
        PrefsService.to.prefs.setDouble(
            SharedPreferencesConstant.firstEma60Tolerance,
            newFirstEma60Tolerance);
        MainPresenter.to.firstEma60Tolerance.value = newFirstEma60Tolerance;
                double newFirstEma120Tolerance = _currentEma120FirstTolerance;
        PrefsService.to.prefs.setDouble(
            SharedPreferencesConstant.firstEma120Tolerance,
            newFirstEma120Tolerance);
        MainPresenter.to.firstEma120Tolerance.value = newFirstEma120Tolerance;
        MainPresenter.to.searchCountNotifier.value++;
        MainPresenter.to.back();
      } else {
        Iterable<SymbolAndName> textMatchesName = MainPresenter
            .to.listSymbolAndName
            .where((SymbolAndName symbolAndName) =>
                symbolAndName.name.toUpperCase().contains(symbol));
        if (textMatchesName.length == 1) {
          String newSymbol = textMatchesName.first.symbol;
          PrefsService.to.prefs.setString(
              SharedPreferencesConstant.financialInstrumentSymbol, newSymbol);
          MainPresenter.to.financialInstrumentSymbol.value = newSymbol;
          String newName = textMatchesName.first.name;
          PrefsService.to.prefs.setString(
              SharedPreferencesConstant.financialInstrumentName, newName);
          MainPresenter.to.financialInstrumentName.value = newName;
          int newLength = _currentLength;
          PrefsService.to.prefs
              .setInt(SharedPreferencesConstant.length, newLength);
          MainPresenter.to.length.value = newLength;
          double newCandleTolerance = _currentCandleTolerance;
          PrefsService.to.prefs.setDouble(
              SharedPreferencesConstant.candleTolerance, newCandleTolerance);
          MainPresenter.to.candleTolerance.value = newCandleTolerance;
          double newPriceTolerance = _currentPriceTolerance;
          PrefsService.to.prefs.setDouble(
              SharedPreferencesConstant.priceTolerance, newPriceTolerance);
          MainPresenter.to.priceTolerance.value = newPriceTolerance;
          double newMaTolerance = _currentMaTolerance;
          PrefsService.to.prefs
              .setDouble(SharedPreferencesConstant.maTolerance, newMaTolerance);
          MainPresenter.to.maTolerance.value = newMaTolerance;
          double newFirstMaTolerance = _currentFirstMaTolerance;
          PrefsService.to.prefs.setDouble(
              SharedPreferencesConstant.firstMaTolerance, newFirstMaTolerance);
          MainPresenter.to.firstMaTolerance.value = newFirstMaTolerance;
          int newSubLength = _currentSubLength;
          PrefsService.to.prefs
              .setInt(SharedPreferencesConstant.subLength, newSubLength);
          MainPresenter.to.subLength.value = newSubLength;
          double newEma1520Vwma20Tolerance = _currentEma1520Vwma20Tolerance;
          PrefsService.to.prefs.setDouble(
              SharedPreferencesConstant.ema1520Vwma20Tolerance,
              newEma1520Vwma20Tolerance);
          MainPresenter.to.ema1520Vwma20Tolerance.value =
              newEma1520Vwma20Tolerance;
          double newEma40Tolerance = _currentEma40Tolerance;
          PrefsService.to.prefs.setDouble(
              SharedPreferencesConstant.ema40Tolerance, newEma40Tolerance);
          MainPresenter.to.ema40Tolerance.value = newEma40Tolerance;
          double newEma60Tolerance = _currentEma60Tolerance;
          PrefsService.to.prefs.setDouble(
              SharedPreferencesConstant.ema60Tolerance, newEma60Tolerance);
          MainPresenter.to.ema60Tolerance.value = newEma60Tolerance;
        double newEma120Tolerance = _currentEma120Tolerance;
        PrefsService.to.prefs.setDouble(
            SharedPreferencesConstant.ema120Tolerance, newEma120Tolerance);
        MainPresenter.to.ema120Tolerance.value = newEma120Tolerance;
          double newFirstEma1520Vwma20Tolerance =
              _currentEma1520Vwma20FirstTolerance;
          PrefsService.to.prefs.setDouble(
              SharedPreferencesConstant.firstEma1520Vwma20Tolerance,
              newFirstEma1520Vwma20Tolerance);
          MainPresenter.to.firstEma1520Vwma20Tolerance.value =
              newFirstEma1520Vwma20Tolerance;
          double newFirstEma40Tolerance = _currentEma40FirstTolerance;
          PrefsService.to.prefs.setDouble(
              SharedPreferencesConstant.firstEma40Tolerance,
              newFirstEma40Tolerance);
          MainPresenter.to.firstEma40Tolerance.value = newFirstEma40Tolerance;
          double newFirstEma60Tolerance = _currentEma60FirstTolerance;
          PrefsService.to.prefs.setDouble(
              SharedPreferencesConstant.firstEma60Tolerance,
              newFirstEma60Tolerance);
                double newFirstEma120Tolerance = _currentEma120FirstTolerance;
        PrefsService.to.prefs.setDouble(
            SharedPreferencesConstant.firstEma120Tolerance,
            newFirstEma120Tolerance);
        MainPresenter.to.firstEma120Tolerance.value = newFirstEma120Tolerance;
          MainPresenter.to.firstEma60Tolerance.value = newFirstEma60Tolerance;
          MainPresenter.to.searchCountNotifier.value++;
          MainPresenter.to.back();
        } else if (textMatchesName.length > 1) {
          Get.snackbar(
              'notice'.tr,
              colorText: AppColor.whiteColor,
              backgroundColor: AppColor.errorColor,
              icon: const Icon(Icons.error),
              'too_many_matches'.tr);
        } else {
          Get.snackbar(
              'notice'.tr,
              colorText: AppColor.whiteColor,
              backgroundColor: AppColor.errorColor,
              icon: const Icon(Icons.error),
              'no_match_found'.tr);
        }
      }
    } else {
      Get.snackbar(
          'notice'.tr,
          colorText: AppColor.whiteColor,
          backgroundColor: AppColor.errorColor,
          icon: const Icon(Icons.error),
          'no_input'.tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'search'.tr,
          style: const TextTheme().sp7,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.h), // Thickness of the progress bar
          child: Obx(
            () => Visibility(
              visible: MainPresenter.to.isWaitingForReply
                  .value, // Show only when isLoading is true
              child: LinearProgressIndicator(
                backgroundColor: ThemeColor.secondary.value, // Background color
                valueColor: AlwaysStoppedAnimation<Color>(
                    ThemeColor.tertiary.value), // Progress color
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.w),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'candle_tolerance'.tr,
                      style: const TextTheme().sp5.primaryTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.w),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: _currentCandleTolerance,
                          max: 500,
                          min: 10,
                          divisions: 49, // (500 - 10) / 10 = 49
                          label: '${_currentCandleTolerance.round()}%',
                          onChanged: (double value) {
                            setState(() {
                              _currentCandleTolerance = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '10%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '125%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '250%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '375%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '500%',
                          style: const TextTheme().sp4,
                        ),
                      ],
                    ),
                    Text(
                      'recommended_tolerance'.tr,
                      style: const TextTheme().sp4.greyColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'price_tolerance'.tr,
                      style: const TextTheme().sp5.primaryTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.w),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: _currentPriceTolerance,
                          max: 100,
                          min: 5,
                          divisions: 19,
                          label: '${_currentPriceTolerance.round()}%',
                          onChanged: (double value) {
                            setState(() {
                              _currentPriceTolerance = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '5%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '25%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '50%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '75%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '100%',
                          style: const TextTheme().sp4,
                        ),
                      ],
                    ),
                    Text(
                      'recommended_tolerance'.tr,
                      style: const TextTheme().sp4.greyColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'first_ma_tolerance'.tr,
                      style: const TextTheme().sp5.primaryTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.w),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: _currentFirstMaTolerance,
                          max: 100,
                          min: 5,
                          divisions: 19,
                          label: '${_currentFirstMaTolerance.round()}%',
                          onChanged: (double value) {
                            setState(() {
                              _currentFirstMaTolerance = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '5%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '25%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '50%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '75%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '100%',
                          style: const TextTheme().sp4,
                        ),
                      ],
                    ),
                    Text(
                      'recommended_tolerance'.tr,
                      style: const TextTheme().sp4.greyColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ma_tolerance'.tr,
                      style: const TextTheme().sp5.primaryTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.w),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: _currentMaTolerance,
                          max: 100,
                          min: 5,
                          divisions: 19,
                          label: '${_currentMaTolerance.round()}%',
                          onChanged: (double value) {
                            setState(() {
                              _currentMaTolerance = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '5%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '25%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '50%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '75%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '100%',
                          style: const TextTheme().sp4,
                        ),
                      ],
                    ),
                    Text(
                      'recommended_tolerance'.tr,
                      style: const TextTheme().sp4.greyColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EMA15/20 VWMA20 ${'first_ma_tolerance'.tr}',
                      style: const TextTheme().sp5.primaryTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.w),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: _currentEma1520Vwma20FirstTolerance,
                          max: 100,
                          min: 5,
                          divisions: 19,
                          label:
                              '${_currentEma1520Vwma20FirstTolerance.round()}%',
                          onChanged: (double value) {
                            setState(() {
                              _currentEma1520Vwma20FirstTolerance = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '5%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '25%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '50%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '75%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '100%',
                          style: const TextTheme().sp4,
                        ),
                      ],
                    ),
                    Text(
                      'recommended_tolerance'.tr,
                      style: const TextTheme().sp4.greyColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ema15_ema20_vwma20_tolerance'.tr,
                      style: const TextTheme().sp5.primaryTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.w),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: _currentEma1520Vwma20Tolerance,
                          max: 100,
                          min: 5,
                          divisions: 19,
                          label: '${_currentEma1520Vwma20Tolerance.round()}%',
                          onChanged: (double value) {
                            setState(() {
                              _currentEma1520Vwma20Tolerance = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '5%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '25%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '50%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '75%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '100%',
                          style: const TextTheme().sp4,
                        ),
                      ],
                    ),
                    Text(
                      'recommended_tolerance'.tr,
                      style: const TextTheme().sp4.greyColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EMA40 ${'first_ma_tolerance'.tr}',
                      style: const TextTheme().sp5.primaryTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.w),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: _currentEma40FirstTolerance,
                          max: 100,
                          min: 5,
                          divisions: 19,
                          label: '${_currentEma40FirstTolerance.round()}%',
                          onChanged: (double value) {
                            setState(() {
                              _currentEma40FirstTolerance = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '5%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '25%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '50%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '75%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '100%',
                          style: const TextTheme().sp4,
                        ),
                      ],
                    ),
                    Text(
                      'recommended_tolerance'.tr,
                      style: const TextTheme().sp4.greyColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ema40_tolerance'.tr,
                      style: const TextTheme().sp5.primaryTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.w),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: _currentEma40Tolerance,
                          max: 100,
                          min: 5,
                          divisions: 19,
                          label: '${_currentEma40Tolerance.round()}%',
                          onChanged: (double value) {
                            setState(() {
                              _currentEma40Tolerance = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '5%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '25%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '50%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '75%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '100%',
                          style: const TextTheme().sp4,
                        ),
                      ],
                    ),
                    Text(
                      'recommended_tolerance'.tr,
                      style: const TextTheme().sp4.greyColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EMA60 ${'first_ma_tolerance'.tr}',
                      style: const TextTheme().sp5.primaryTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.w),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: _currentEma60FirstTolerance,
                          max: 100,
                          min: 5,
                          divisions: 19,
                          label: '${_currentEma60FirstTolerance.round()}%',
                          onChanged: (double value) {
                            setState(() {
                              _currentEma60FirstTolerance = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '5%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '25%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '50%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '75%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '100%',
                          style: const TextTheme().sp4,
                        ),
                      ],
                    ),
                    Text(
                      'recommended_tolerance'.tr,
                      style: const TextTheme().sp4.greyColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ema60_tolerance'.tr,
                      style: const TextTheme().sp5.primaryTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.w),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: _currentEma60Tolerance,
                          max: 100,
                          min: 5,
                          divisions: 19,
                          label: '${_currentEma60Tolerance.round()}%',
                          onChanged: (double value) {
                            setState(() {
                              _currentEma60Tolerance = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '5%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '25%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '50%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '75%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '100%',
                          style: const TextTheme().sp4,
                        ),
                      ],
                    ),
                    Text(
                      'recommended_tolerance'.tr,
                      style: const TextTheme().sp4.greyColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EMA120 ${'first_ma_tolerance'.tr}',
                      style: const TextTheme().sp5.primaryTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.w),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: _currentEma120FirstTolerance,
                          max: 100,
                          min: 5,
                          divisions: 19,
                          label: '${_currentEma120FirstTolerance.round()}%',
                          onChanged: (double value) {
                            setState(() {
                              _currentEma120FirstTolerance = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '5%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '25%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '50%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '75%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '100%',
                          style: const TextTheme().sp4,
                        ),
                      ],
                    ),
                    Text(
                      'recommended_tolerance'.tr,
                      style: const TextTheme().sp4.greyColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ema120_tolerance'.tr,
                      style: const TextTheme().sp5.primaryTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.w),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: _currentEma120Tolerance,
                          max: 100,
                          min: 5,
                          divisions: 19,
                          label: '${_currentEma120Tolerance.round()}%',
                          onChanged: (double value) {
                            setState(() {
                              _currentEma120Tolerance = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '5%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '25%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '50%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '75%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '100%',
                          style: const TextTheme().sp4,
                        ),
                      ],
                    ),
                    Text(
                      'recommended_tolerance'.tr,
                      style: const TextTheme().sp4.greyColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'time_range'.tr,
                      style: const TextTheme().sp5.primaryTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.w),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: _currentLength.toDouble(),
                          max: 10,
                          min: 2,
                          divisions: 8,
                          label: _currentLength.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _currentLength = value.toInt();
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '2_timeunits'.tr,
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '10_timeunits'.tr,
                          style: const TextTheme().sp4,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'subsequent_timeunit'.tr,
                      style: const TextTheme().sp5.primaryTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.w),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: _currentSubLength.toDouble(),
                          max: 20,
                          min: 2,
                          divisions: 18,
                          label: _currentSubLength.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _currentSubLength = value.toInt();
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '2_timeunits'.tr,
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '20_timeunits'.tr,
                          style: const TextTheme().sp4,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'strict_matching_criteria'.tr,
                        style: const TextTheme().sp5.w700,
                      ),
                    ),
                    Obx(
                      () => Switch(
                          value: MainPresenter.to.strictMatchCriteria.value,
                          activeColor: Colors.red,
                          onChanged: (bool value) {
                            MainPresenter.to.strictMatchCriteria.value = value;
                            PrefsService.to.prefs.setBool(
                                SharedPreferencesConstant.strictMatchCriteria,
                                value);
                            MainPresenter.to.refreshIndicator();
                          }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'ma_mathcing_criteria'.tr,
                        style: const TextTheme().sp5.w700,
                      ),
                    ),
                    Obx(
                      () => Switch(
                          value: MainPresenter.to.maMatchCriteria.value,
                          activeColor: Colors.red,
                          onChanged: (bool value) {
                            MainPresenter.to.maMatchCriteria.value = value;
                            PrefsService.to.prefs.setBool(
                                SharedPreferencesConstant.maMatchCriteria,
                                value);
                          }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'vwma20_mathcing_criteria'.tr,
                        style: const TextTheme().sp5.w700,
                      ),
                    ),
                    Obx(
                      () => Switch(
                        value: MainPresenter.to.vwma20MatchCriteria.value,
                        activeColor: Colors.red,
                        onChanged: (bool value) {
                          MainPresenter.to.vwma20MatchCriteria.value = value;
                          PrefsService.to.prefs.setBool(
                              SharedPreferencesConstant.vwma20MatchCriteria,
                              value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'ema40_mathcing_criteria'.tr,
                        style: const TextTheme().sp5.w700,
                      ),
                    ),
                    Obx(
                      () => Switch(
                        value: MainPresenter.to.ema40MatchCriteria.value,
                        activeColor: Colors.red,
                        onChanged: (bool value) {
                          MainPresenter.to.ema40MatchCriteria.value = value;
                          PrefsService.to.prefs.setBool(
                              SharedPreferencesConstant.ema40MatchCriteria,
                              value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'ema60_mathcing_criteria'.tr,
                        style: const TextTheme().sp5.w700,
                      ),
                    ),
                    Obx(
                      () => Switch(
                        value: MainPresenter.to.ema60MatchCriteria.value,
                        activeColor: Colors.red,
                        onChanged: (bool value) {
                          MainPresenter.to.ema60MatchCriteria.value = value;
                          PrefsService.to.prefs.setBool(
                              SharedPreferencesConstant.ema60MatchCriteria,
                              value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'ema120_mathcing_criteria'.tr,
                        style: const TextTheme().sp5.w700,
                      ),
                    ),
                    Obx(
                      () => Switch(
                        value: MainPresenter.to.ema120MatchCriteria.value,
                        activeColor: Colors.red,
                        onChanged: (bool value) {
                          MainPresenter.to.ema120MatchCriteria.value = value;
                          PrefsService.to.prefs.setBool(
                              SharedPreferencesConstant.ema120MatchCriteria,
                              value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Autocomplete<SymbolAndName>(
                      displayStringForOption:
                          _SearchViewState._displayStringForOption,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return listSymbolAndName;
                        }
                        if (_autocomplete) {
                          return listSymbolAndName
                              .where((SymbolAndName symbolAndName) {
                            return symbolAndName
                                .toString()
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        } else {
                          return const Iterable<SymbolAndName>.empty();
                        }
                      },
                      onSelected: (SymbolAndName selection) {
                        _autocomplete = false;
                        _textEditingController.text = selection.symbol;
                      },
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController textEditingController,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted) {
                        _textEditingController = textEditingController;
                        focusNode.addListener(() {
                          if (focusNode.hasFocus) {
                            setState(() {
                              sizedBox = SizedBox(height: 50.h);
                            });
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent + 50.h,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            // Clear the text field when losing focus if no selection was made
                            // if (_autocomplete) {
                            //   _textEditingController.text = '';
                            // }
                            if (sizedBox != const SizedBox.shrink()) {
                              setState(() {
                                sizedBox = const SizedBox.shrink();
                              });
                            }
                          }
                        });
                        return TextField(
                          onChanged: (String value) {
                            _autocomplete = true;
                          },
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: (MainPresenter.to.listingErr.value != ''
                                ? MainPresenter.to.listingErr.value
                                : 'input_placeholder'.tr),
                          ),
                        );
                      },
                    ),
                    MainPresenter.to.buildListingSourceRichText(),
                  ],
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.w),
              //   child: TextFormField(
              //     controller: _dateRangeController,
              //     decoration: const InputDecoration(
              //       labelText: 'Select Date Range',
              //       suffixIcon: Icon(Icons.calendar_today),
              //       border: OutlineInputBorder(),
              //     ),
              //     readOnly: true,
              //     onTap: () async {
              //       final range = await showDateRangePicker(
              //         context: context,
              //         firstDate: DateTime(1990),
              //         lastDate:
              //             DateTime.now(), //restrict user to choose future date
              //       );
              //       if (range != null) {
              //         setState(() {
              //           selectedDateRange = range;
              //           _dateRangeController.text =
              //               '${range.start.day}/${range.start.month}/${range.start.year} - ${range.end.day}/${range.end.month}/${range.end.year}';
              //         });
              //       }
              //     },
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _resetForm,
                      child: Text(
                        'reset'.tr,
                        style: const TextTheme().sp5,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(
                        'submit'.tr,
                        style: const TextTheme().sp5,
                      ),
                    ),
                  ],
                ),
              ),
              sizedBox,
            ],
          ),
        ),
      ),
    );
  }
}
