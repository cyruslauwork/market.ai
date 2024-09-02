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
  double _currentTolerance =
      (PrefsService.to.prefs.getInt(SharedPreferencesConstant.tolerance) ?? 40)
          .toDouble();
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
      _currentTolerance = 40;
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
        int newTolerance = _currentTolerance.toInt();
        PrefsService.to.prefs
            .setInt(SharedPreferencesConstant.tolerance, newTolerance);
        MainPresenter.to.tolerance.value = newTolerance;
        int newSubLength = _currentSubLength;
        PrefsService.to.prefs
            .setInt(SharedPreferencesConstant.subLength, newSubLength);
        MainPresenter.to.subLength.value = newSubLength;
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
          int newTolerance = _currentTolerance.toInt();
          PrefsService.to.prefs
              .setInt(SharedPreferencesConstant.tolerance, newTolerance);
          MainPresenter.to.tolerance.value = newTolerance;
          int newSubLength = _currentSubLength;
          PrefsService.to.prefs
              .setInt(SharedPreferencesConstant.subLength, newSubLength);
          MainPresenter.to.subLength.value = newSubLength;
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
                      'tolerance'.tr,
                      style: const TextTheme().sp5.primaryTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.w),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: _currentTolerance,
                          max: 100,
                          min: 5,
                          divisions: 19,
                          label: '${_currentTolerance.round().toString()}%',
                          onChanged: (double value) {
                            setState(() {
                              _currentTolerance = value;
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
                        onChanged: (bool value) =>
                            MainPresenter.to.strictMatchCriteria.value = value,
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
                        'ma_mathcing_criteria'.tr,
                        style: const TextTheme().sp5.w700,
                      ),
                    ),
                    Obx(
                      () => Switch(
                        value: MainPresenter.to.maMatchCriteria.value,
                        activeColor: Colors.red,
                        onChanged: (bool value) =>
                            MainPresenter.to.maMatchCriteria.value = value,
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
