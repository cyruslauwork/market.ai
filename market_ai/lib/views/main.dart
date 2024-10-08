import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:market_ai/models/models.dart';

import 'package:market_ai/presenters/presenters.dart';
import 'package:market_ai/utils/utils.dart';
import 'package:market_ai/views/views.dart';
import 'package:market_ai/styles/styles.dart';
import 'package:market_ai/services/services.dart';

class MainView extends StatefulWidget {
  // const MainView({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  // Singleton implementation
  static const MainView _instance = MainView._internal();
  factory MainView() {
    return _instance;
  }
  const MainView._internal();

  Widget devModeViewOne(BuildContext context) {
    String jumpServerUrl = MainPresenter.to.jumpServerUrl.value;
    double probThreshold = MainPresenter.to.probThreshold.value;
    double minReturnRateThreshold =
        MainPresenter.to.minReturnRateThreshold.value;
    return Column(children: [
      Column(children: [
        Text(
          'trend_match_title'.tr,
          style: const TextTheme().sp5.w700,
        ),
        Obx(
          () => Table(
            border: TableBorder.all(
                color: AppColor.blackColor, style: BorderStyle.solid, width: 2),
            children: [
              TableRow(children: [
                Column(children: [Text('dl'.tr, style: const TextTheme().sp4)]),
                Column(
                    children: [Text('rows'.tr, style: const TextTheme().sp4)]),
                Column(
                    children: [Text('range'.tr, style: const TextTheme().sp4)]),
                Column(children: [
                  Text('max_ma'.tr, style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text('subsequent_time_unit'.tr, style: const TextTheme().sp4)
                ]),
              ]),
              TableRow(children: [
                Column(children: [
                  Text(MainPresenter.to.candledownloadTime.toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(MainPresenter.to.trendMatchOutput[3].toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(MainPresenter.to.length.value.toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(MainPresenter.to.maxMa.toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(MainPresenter.to.subLength.toString(),
                      style: const TextTheme().sp4)
                ]),
              ]),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Obx(
          () => Table(
            border: TableBorder.all(
                color: AppColor.blackColor, style: BorderStyle.solid, width: 2),
            children: [
              TableRow(children: [
                Column(children: [
                  Text('tm_rows'.tr, style: const TextTheme().sp4)
                ]),
                Column(
                    children: [Text('exe'.tr, style: const TextTheme().sp4)]),
                Column(
                    children: [Text('true'.tr, style: const TextTheme().sp4)]),
                Column(
                    children: [Text('false'.tr, style: const TextTheme().sp4)]),
              ]),
              TableRow(children: [
                Column(children: [
                  Text(
                      (MainPresenter.to.trendMatchOutput[3] -
                              MainPresenter.to.trendMatchOutput[4])
                          .toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(MainPresenter.to.trendMatchOutput[2].toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(MainPresenter.to.trendMatchOutput[0].toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(MainPresenter.to.trendMatchOutput[1].toString(),
                      style: const TextTheme().sp4)
                ]),
              ]),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          'sa_title'.tr,
          style: const TextTheme().sp5.w700,
        ),
        Obx(
          () => Table(
            border: TableBorder.all(
                color: AppColor.blackColor, style: BorderStyle.solid, width: 2),
            children: [
              TableRow(children: [
                Column(children: [
                  Text('sa_prep'.tr, style: const TextTheme().sp4)
                ]),
                Column(children: [Text('sa'.tr, style: const TextTheme().sp4)]),
                Column(children: [
                  Text('clusters'.tr, style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text('max_ss'.tr, style: const TextTheme().sp4)
                ]),
              ]),
              TableRow(children: [
                Column(children: [
                  Text(
                      MainPresenter.to.lastClosePriceAndSubsequentTrendsExeTime
                          .toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(MainPresenter.to.cloudSubsequentAnalyticsTime.toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(MainPresenter.to.numOfClusters.toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(MainPresenter.to.maxSilhouetteScore.value,
                      style: const TextTheme().sp4)
                ]),
              ]),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          'misc'.tr,
          style: const TextTheme().sp5.w700,
        ),
        Obx(
          () => Table(
            border: TableBorder.all(
                color: AppColor.blackColor, style: BorderStyle.solid, width: 2),
            children: [
              TableRow(children: [
                Column(children: [
                  Text('listings_dl'.tr, style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text('ai_res'.tr, style: const TextTheme().sp4)
                ]),
              ]),
              TableRow(children: [
                Column(children: [
                  Text(MainPresenter.to.listingsDownloadTime.toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(MainPresenter.to.aiResponseTime.toString(),
                      style: const TextTheme().sp4)
                ]),
              ]),
            ],
          ),
        ),
        SizedBox(height: 5.h),
      ]),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Column(
          children: [
            const Divider(),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: Text(
                      'always_show_analytics'.tr,
                      style: const TextTheme().sp5.w700,
                    ),
                  ),
                  Switch(
                    value: MainPresenter.to.alwaysShowAnalytics.value,
                    activeColor: Colors.red,
                    onChanged: (bool value) =>
                        MainPresenter.to.alwaysShowAnalyticsToggle(value),
                  ),
                ],
              ),
            ),
            const Divider(),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: Text(
                      'always_show_std_dist_plot'.tr,
                      style: const TextTheme().sp5.w700,
                    ),
                  ),
                  Switch(
                    value: MainPresenter.to.alwaysShowSdDistPlot.value,
                    activeColor: Colors.red,
                    onChanged: (bool value) =>
                        MainPresenter.to.alwaysShowSdDistPlotToggle(value),
                  ),
                ],
              ),
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'jump_server_input_title'.tr,
                    style: const TextTheme().sp5.w700,
                  ),
                ),
                Expanded(
                  child: TextField(
                    onChanged: (String value) {
                      MainPresenter.to.jumpServerUrl.value = value;
                      PrefsService.to.prefs.setString(
                          SharedPreferencesConstant.jumpServerUrl, value);
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: jumpServerUrl,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: Text(
                      'always_skip_search_symbol'.tr,
                      style: const TextTheme().sp5.w700,
                    ),
                  ),
                  Switch(
                    value: MainPresenter.to.alwaysSkipSymbolInSearch.value,
                    activeColor: Colors.red,
                    onChanged: (bool value) =>
                        MainPresenter.to.alwaysSkipSymbolInSearchToggle(value),
                  ),
                ],
              ),
            ),
            const Divider(),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: Text(
                      'backtesting_thousandths_data'.tr,
                      style: const TextTheme().sp5.w700,
                    ),
                  ),
                  Switch(
                    value: MainPresenter.to.alwaysThousandthsData.value,
                    activeColor: Colors.red,
                    onChanged: (bool value) =>
                        MainPresenter.to.alwaysThousandthsDataToggle(value),
                  ),
                ],
              ),
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'backtesting_prob'.tr,
                    style: const TextTheme().sp5.w700,
                  ),
                ),
                Expanded(
                  child: TextField(
                    onChanged: (String value) {
                      MainPresenter.to.probThreshold.value =
                          double.parse(value);
                      PrefsService.to.prefs.setDouble(
                          SharedPreferencesConstant.probThreshold,
                          double.parse(value));
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: probThreshold.toString(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'backtesting_min_return_rate'.tr,
                    style: const TextTheme().sp5.w700,
                  ),
                ),
                Expanded(
                  child: TextField(
                    onChanged: (String value) {
                      MainPresenter.to.minReturnRateThreshold.value =
                          double.parse(value);
                      PrefsService.to.prefs.setDouble(
                          SharedPreferencesConstant.minReturnRateThreshold,
                          double.parse(value));
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: minReturnRateThreshold.toString(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            const Divider(),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: Text(
                      'close_pos_when_reached_median'.tr,
                      style: const TextTheme().sp5.w700,
                    ),
                  ),
                  Switch(
                    value: MainPresenter.to.closePosWhenReachedMedian.value,
                    activeColor: Colors.red,
                    onChanged: (bool value) =>
                        MainPresenter.to.closePosWhenReachedMedianToggle(value),
                  ),
                ],
              ),
            ),
            const Divider(),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: Text(
                      'close_pos_when_first_half_reached_three_fourths_median'
                          .tr,
                      style: const TextTheme().sp5.w700,
                    ),
                  ),
                  Switch(
                    value: MainPresenter.to
                        .closePosWhenFirstHalfReachedThreeFourthsMedian.value,
                    activeColor: Colors.red,
                    onChanged: (bool value) => MainPresenter.to
                        .closePosWhenFirstHalfReachedThreeFourthsMedianToggle(
                            value),
                  ),
                ],
              ),
            ),
            const Divider(),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: Text(
                      'trends_within_min_return_rate_quintile_not_counted'.tr,
                      style: const TextTheme().sp5.w700,
                    ),
                  ),
                  Switch(
                    value: MainPresenter
                        .to.trendsWithinMinReturnRateQuintileNotCounted.value,
                    activeColor: Colors.red,
                    onChanged: (bool value) => MainPresenter.to
                        .trendsWithinMinReturnRateQuintileNotCountedToggle(
                            value),
                  ),
                ],
              ),
            ),
            const Divider(),
            Obx(() => (MainPresenter.to.backtestDataLen1.value != 0
                ? Text(
                    '${MainPresenter.to.backtestDataRan1.value}/${MainPresenter.to.backtestDataLen1.value}',
                    style: const TextTheme().sp5.w700,
                  )
                : const SizedBox.shrink())),
            Obx(() => (MainPresenter.to.backtestDataLen2.value != 0
                ? Text(
                    '${MainPresenter.to.backtestDataRan2.value}/${MainPresenter.to.backtestDataLen2.value}',
                    style: const TextTheme().sp5.w700,
                  )
                : const SizedBox.shrink())),
            Obx(() => (MainPresenter.to.backtestDataLen3.value != 0
                ? Text(
                    '${MainPresenter.to.backtestDataRan3.value}/${MainPresenter.to.backtestDataLen3.value}',
                    style: const TextTheme().sp5.w700,
                  )
                : const SizedBox.shrink())),
            Obx(() => (MainPresenter.to.backtestDataLen4.value != 0
                ? Text(
                    '${MainPresenter.to.backtestDataRan4.value}/${MainPresenter.to.backtestDataLen4.value}',
                    style: const TextTheme().sp5.w700,
                  )
                : const SizedBox.shrink())),
            Obx(() => (MainPresenter.to.backtestDataLen5.value != 0
                ? Text(
                    '${MainPresenter.to.backtestDataRan5.value}/${MainPresenter.to.backtestDataLen5.value}',
                    style: const TextTheme().sp5.w700,
                  )
                : const SizedBox.shrink())),
            Obx(
              () => Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                child: Column(
                  children: MainPresenter.to.universalHasMinuteData.entries
                      .where((entry) => entry.value) // Filter for true values
                      .expand((entry) {
                    String symbol = entry.key; // Get the symbol
                    return [
                      ElevatedButton.icon(
                        onPressed: MainPresenter.to.isButtonDisabled.value
                            ? () => MainPresenter.to.showScaffoldMessenger(
                                context: context,
                                localizedMsg:
                                    'backtesting_disturbance_detected'.tr)
                            : () {
                                IsarService().clearData(symbol);
                                MainPresenter
                                    .to.universalHasMinuteData[symbol] = false;
                              },
                        icon: Icon(
                          Icons.clean_hands_rounded,
                          size: 10.h,
                        ),
                        label: Text(
                          symbol + 'btn_clear_minute'.tr,
                          style: const TextTheme().sp5.w700,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: MainPresenter.to.isButtonDisabled.value
                            ? () => MainPresenter.to.showScaffoldMessenger(
                                context: context,
                                localizedMsg:
                                    'backtesting_disturbance_detected'.tr)
                            : () => MainPresenter.to.backtest(symbol, context),
                        icon: MainPresenter.to.backtestingSymbol.value == symbol
                            ? SizedBox(
                                width: 10.w,
                                height: 10.h,
                                child: const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColor
                                      .whiteColor), // Color of the loading indicator
                                ),
                              )
                            : Icon(
                                Icons.insights_outlined,
                                size: 10.h,
                              ),
                        label: Text(
                          symbol + 'btn_backtest_minute'.tr,
                          style: const TextTheme().sp5.w700,
                        ),
                      ),
                    ];
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 5.h),
          ],
        ),
      ),
      Text(
        'percent_diff_title'.tr,
        style: const TextTheme().sp5.w700,
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: false,
          border: TableBorder.all(
              color: AppColor.blackColor, style: BorderStyle.solid, width: 2),
          columns: MainPresenter.to.selectedPeriodPercentDifferencesList
              .mapIndexed((i, e) => DataColumn(
                      label: Text(
                    '${'close_price'.tr} ${(i + 1).toString()} - ${'close_price'.tr} ${(i + 2).toString()}',
                    style: const TextTheme().sp4,
                  )))
              .toList(),
          rows: [
            DataRow(
              cells: MainPresenter.to.selectedPeriodPercentDifferencesList
                  .map((e) => DataCell(Text(
                        e.toString(),
                        style: const TextTheme().sp4,
                      )))
                  .toList(),
            ),
          ],
        ),
      ),
      SizedBox(height: 5.h),
      // Text(
      //   'actual_diff_title'.tr,
      //   style: const TextTheme().sp5.w700,
      // ),
      // SingleChildScrollView(
      //   scrollDirection: Axis.horizontal,
      //   child: DataTable(
      //     showCheckboxColumn: false,
      //     border: TableBorder.all(
      //         color: AppColor.blackColor, style: BorderStyle.solid, width: 2),
      //     columns: MainPresenter.to.selectedPeriodActualDifferencesList
      //         .mapIndexed((i, e) => DataColumn(
      //                 label: Text(
      //               '${'close_price'.tr} ${(i + 1).toString()} - ${'close_price'.tr} ${(i + 2).toString()}',
      //               style: const TextTheme().sp4,
      //             )))
      //         .toList(),
      //     rows: [
      //       DataRow(
      //         cells: MainPresenter.to.selectedPeriodActualDifferencesList
      //             .map((e) => DataCell(Text(
      //                   e.toString(),
      //                   style: const TextTheme().sp4,
      //                 )))
      //             .toList(),
      //       ),
      //     ],
      //   ),
      // ),
      // SizedBox(height: 5.h),
      // Text(
      //   'actual_price_title'.tr,
      //   style: const TextTheme().sp5.w700,
      // ),
      // SingleChildScrollView(
      //   scrollDirection: Axis.horizontal,
      //   child: DataTable(
      //     showCheckboxColumn: false,
      //     border: TableBorder.all(
      //         color: AppColor.blackColor, style: BorderStyle.solid, width: 2),
      //     columns: MainPresenter.to.selectedPeriodActualPricesList
      //         .mapIndexed((i, e) => DataColumn(
      //                 label: Text(
      //               '${'close_price'.tr} ${(i + 1).toString()}',
      //               style: const TextTheme().sp4,
      //             )))
      //         .toList(),
      //     rows: [
      //       DataRow(
      //         cells: MainPresenter.to.selectedPeriodActualPricesList
      //             .map((e) => DataCell(Text(
      //                   e.toString(),
      //                   style: const TextTheme().sp4,
      //                 )))
      //             .toList(),
      //       ),
      //     ],
      //   ),
      // ),
      // SizedBox(height: 5.h),
      // const Divider(),
      // Text(
      //   'matched_title'.tr,
      //   style: const TextTheme().sp5.w700,
      // ),
      // SimpleLineChart(),
      // SizedBox(height: 5.h),
      // Text(
      //   'normalized_matched_title'.tr,
      //   style: const TextTheme().sp5.w700,
      // ),
      // SimpleLineChart(
      //   normalized: true,
      // ),
      // SizedBox(height: 5.h),
    ]);
  }

  Widget devModeViewTwo() {
    if (MainPresenter.to.trendMatched.value) {
      return Column(children: [
        const Divider(),
        Text(
          'matched_rows_title'.tr,
          style: const TextTheme().sp5.w700,
        ),
        (MainPresenter.to.matchRows.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  MainPresenter.to.matchRows.toString(),
                  style: const TextTheme().sp4,
                ),
              )
            : Text('0', style: const TextTheme().sp4)),
        // Iterate over the universalMatchRows
        ...MainPresenter.to.universalMatchRows.entries.map((entry) {
          String key = entry.key;
          List<int> values = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title for each key
              Text(key, style: const TextTheme().sp5.w700),
              // Content based on values
              values.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        values.toString(),
                        style: const TextTheme().sp4,
                      ),
                    )
                  : Text('0', style: const TextTheme().sp4),
            ],
          );
        }),
        SizedBox(height: 5.h),
        // Text(
        //   'matched_percent_diff_title'.tr,
        //   style: const TextTheme().sp5.w700,
        // ),
        // (MainPresenter.to.matchPercentDifferencesListList.isNotEmpty
        //     ? SingleChildScrollView(
        //         scrollDirection: Axis.horizontal,
        //         child: Text(
        //           '${MainPresenter.to.matchPercentDifferencesListList.mapIndexed((i, e) => '${MainPresenter.to.matchRows[i]}:$e\n').take(10).toList().toString()}...${(MainPresenter.to.matchPercentDifferencesListList.length > 10 ? MainPresenter.to.matchPercentDifferencesListList.length - 10 : 0)} rows left',
        //           style: const TextTheme().sp4,
        //         ),
        //       )
        //     : Text('0', style: const TextTheme().sp4)),
        // SizedBox(height: 5.h),
        // Text(
        //   'matched_actual_diff_title'.tr,
        //   style: const TextTheme().sp5.w700,
        // ),
        // (MainPresenter.to.matchActualDifferencesListList.isNotEmpty
        //     ? SingleChildScrollView(
        //         scrollDirection: Axis.horizontal,
        //         child: Text(
        //           '${MainPresenter.to.matchActualDifferencesListList.mapIndexed((i, e) => '${MainPresenter.to.matchRows[i]}:$e\n').take(10).toList().toString()}...${(MainPresenter.to.matchActualDifferencesListList.length > 10 ? MainPresenter.to.matchActualDifferencesListList.length - 10 : 0)} rows left',
        //           style: const TextTheme().sp4,
        //         ),
        //       )
        //     : Text('0', style: const TextTheme().sp4)),
        // SizedBox(height: 5.h),
        // Text(
        //   'matched_actual_title'.tr,
        //   style: const TextTheme().sp5.w700,
        // ),
        // (MainPresenter.to.matchActualPricesListList.isNotEmpty
        //     ? SingleChildScrollView(
        //         scrollDirection: Axis.horizontal,
        //         child: Text(
        //           '${MainPresenter.to.matchActualPricesListList.mapIndexed((i, e) => '${MainPresenter.to.matchRows[i]}:$e\n').take(10).toList().toString()}...${(MainPresenter.to.matchActualPricesListList.length > 10 ? MainPresenter.to.matchActualPricesListList.length - 10 : 0)} rows left',
        //           style: const TextTheme().sp4,
        //         ),
        //       )
        //     : Text('0', style: const TextTheme().sp4)),
        // SizedBox(height: 5.h),
        // Text(
        //   'Comparison_percent_diff_title'.tr,
        //   style: const TextTheme().sp5.w700,
        // ),
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: Text(
        //     '${MainPresenter.to.comparePeriodPercentDifferencesListList.mapIndexed((i, e) => '$i:$e\n').take(10).toList()}...${MainPresenter.to.comparePeriodPercentDifferencesListList.length - 10} rows left',
        //     style: const TextTheme().sp4,
        //   ),
        // ),
        // SizedBox(height: 5.h),
        // Text(
        //   'Comparison_actual_diff_title'.tr,
        //   style: const TextTheme().sp5.w700,
        // ),
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: Text(
        //     '${MainPresenter.to.comparePeriodActualDifferencesListList.mapIndexed((i, e) => '$i:$e\n').take(10).toList()}...${MainPresenter.to.comparePeriodActualDifferencesListList.length - 10} rows left',
        //     style: const TextTheme().sp4,
        //   ),
        // ),
        // SizedBox(height: 5.h),
        // Text(
        //   'comparison_actual_title'.tr,
        //   style: const TextTheme().sp5.w700,
        // ),
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: Text(
        //     '${MainPresenter.to.comparePeriodActualPricesListList.mapIndexed((i, e) => '$i:$e\n').take(10).toList()}...${MainPresenter.to.comparePeriodActualPricesListList.length - 10} rows left',
        //     style: const TextTheme().sp4,
        //   ),
        // ),
        // SizedBox(height: 5.h),
        const Divider(),
      ]);
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final ScrollController _scrollController = ScrollController();
  bool _isChartFrozen = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    double chartFrozenY = MediaQuery.of(context).size.height * 2.75;
    // Check if the scroll position exceeds position Y
    if (_scrollController.offset > chartFrozenY) {
      if (!_isChartFrozen) {
        setState(() {
          _isChartFrozen = true; // Trigger the freeze
        });
      }
    } else {
      if (_isChartFrozen) {
        setState(() {
          _isChartFrozen = false; // Unfreeze if scrolled back
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              // Check the current offset
              if (_scrollController.position.pixels == 0) {
                // If at the top, scroll to the bottom
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                );
              } else {
                // If not at the top, scroll to the top
                _scrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Text(
              'app_name'.tr,
              style: const TextTheme().sp7.w700,
            ),
          ),
          actions: MainPresenter.to.listCandledata.length > 1
              ? MainPresenter.to.buildListingRelatedIcons(context: context) +
                  [
                    IconButton(
                      icon: Icon(MainPresenter.to.darkMode.value
                          ? Icons.dark_mode
                          : Icons.light_mode),
                      onPressed: () => MainPresenter.to.changeAppearance(),
                    ),
                    if (MainPresenter.to.devModeNotifier.value) ...[
                      IconButton(
                        icon: Icon(MainPresenter.to.showAverageNotifier.value
                            ? Icons.show_chart
                            : Icons.bar_chart_outlined),
                        onPressed: () {
                          setState(() {
                            MainPresenter.to.showAverageNotifier.value =
                                !MainPresenter.to.showAverageNotifier.value;
                          });
                        },
                      )
                    ],
                    IconButton(
                      icon: Icon(MainPresenter.to.isEnNotifier.value
                          ? Icons.g_translate
                          : Icons.translate),
                      onPressed: () {
                        MainPresenter.to.isEnNotifier.value =
                            !MainPresenter.to.isEnNotifier.value;
                        PrefsService.to.prefs.setBool(
                            SharedPreferencesConstant.isEn,
                            MainPresenter.to.isEnNotifier.value);
                      },
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_outlined),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'devMode',
                              child: ListTile(
                                leading: Icon(
                                  MainPresenter.to.devModeNotifier.value
                                      ? Icons.code
                                      : Icons.code_off,
                                  color: ThemeColor.primary.value,
                                ),
                                title: Text(
                                  'Dev Mode',
                                  style: const TextTheme().sp4.primaryTextColor,
                                ),
                              ),
                            ),
                            const PopupMenuDivider(),
                          ] +
                          MainPresenter.to.popMenuItems(),
                      onSelected: (String value) {
                        // Handle the selected value here
                        if (value == 'devMode') {
                          if (!MainPresenter.to.isLockTrend.value ||
                              (MainPresenter.to.matchRows.isNotEmpty &&
                                  MainPresenter.to.matchRows.first != 0)) {
                            setState(() {
                              MainPresenter.to.devModeNotifier.value =
                                  !MainPresenter.to.devModeNotifier.value;
                            });
                          } else {
                            MainPresenter.to.showScaffoldMessenger(
                                context: context,
                                localizedMsg: 'lock_trend_alert'.tr);
                          }
                        } else if (value != 'watchlistEmpty') {
                          if (!MainPresenter.to.isLockTrend.value) {
                            List<SymbolAndName> listSymbolAndName =
                                MainPresenter.to.listSymbolAndName;
                            String newName;
                            try {
                              newName = listSymbolAndName
                                  .firstWhere((SymbolAndName symbolAndName) =>
                                      symbolAndName.symbol == value)
                                  .name;
                            } catch (e) {
                              newName =
                                  'Failed to fetch financial symbol name.';
                            }
                            PrefsService.to.prefs.setString(
                                SharedPreferencesConstant
                                    .financialInstrumentName,
                                newName);
                            MainPresenter.to.financialInstrumentName.value =
                                newName;
                            String newSymbol = value;
                            PrefsService.to.prefs.setString(
                                SharedPreferencesConstant
                                    .financialInstrumentSymbol,
                                newSymbol);
                            MainPresenter.to.financialInstrumentSymbol.value =
                                newSymbol;
                            MainPresenter.to.searchCountNotifier.value++;
                          } else {
                            MainPresenter.to.showScaffoldMessenger(
                                context: context,
                                localizedMsg: 'lock_trend_alert'.tr);
                          }
                        }
                      },
                    ),
                  ]
              : null,
          bottom: PreferredSize(
            preferredSize:
                Size.fromHeight(2.h), // Thickness of the progress bar
            child: Obx(
              () => Visibility(
                visible: MainPresenter.to.isWaitingForReply
                    .value, // Show only when isLoading is true
                child: LinearProgressIndicator(
                  backgroundColor:
                      ThemeColor.secondary.value, // Background color
                  valueColor: AlwaysStoppedAnimation<Color>(
                      ThemeColor.tertiary.value), // Progress color
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          minimum: EdgeInsets.all(1.w),
          child: FutureBuilder<List<CandleData>>(
            future: MainPresenter.to.futureListCandledata,
            builder: (BuildContext context,
                AsyncSnapshot<List<CandleData>> snapshot) {
              if (snapshot.hasData) {
                return RefreshIndicator(
                    color: AppColor.whiteColor,
                    backgroundColor: ThemeColor.primary.value,
                    onRefresh: () =>
                        Future.value(MainPresenter.to.refreshIndicator()),
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      MainPresenter
                                          .to.financialInstrumentName.value,
                                      style: const TextTheme()
                                          .sp7
                                          .primaryTextColor
                                          .w700,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '(${MainPresenter.to.financialInstrumentSymbol.value})',
                                    style:
                                        const TextTheme().sp5.primaryTextColor,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${MainPresenter.to.showCandleListListLastItem()}',
                                    style: const TextTheme()
                                        .sp10
                                        .primaryTextColor
                                        .w700,
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () =>
                                            MainPresenter.to.refreshIndicator(),
                                        icon: const Icon(
                                          Icons.refresh_outlined,
                                        ),
                                        color: ThemeColor.primary.value,
                                        iconSize: 10.h,
                                      ),
                                      MainPresenter.to.showMinuteDataToggleBtn(
                                          context: context),
                                      MainPresenter.to.showCrossDataToggleBtn(
                                          context: context),
                                      IconButton(
                                        onPressed: () => MainPresenter.to
                                            .bookmarkThis(context: context),
                                        icon: Obx(
                                          () => Icon(
                                            MainPresenter.to.bookmarked.value,
                                          ),
                                        ),
                                        color: ThemeColor.primary.value,
                                        iconSize: 10.h,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Obx(
                                () => Text(
                                  MainPresenter.to.lastDatetime.value,
                                  style: const TextTheme().sp4.greyColor,
                                ),
                              ),
                              Center(
                                child: Text(
                                  'candle_chart_title'.tr,
                                  style: const TextTheme().sp5,
                                ),
                              ),
                              MainPresenter.to
                                  .showCandlestickChart(snapshot: snapshot),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Obx(
                                    () => Text(
                                      MainPresenter.to.legends.value,
                                      style: const TextTheme().sp4.greyColor,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MainPresenter.to
                                      .buildMktDataProviderRichText(),
                                  SizedBox(
                                    height: (Platform.isWindows ||
                                            Platform.isLinux ||
                                            Platform.isMacOS
                                        ? 14.h
                                        : 10.h),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColor.greyColor
                                              .withOpacity(0.5)),
                                      child: IconButton(
                                        onPressed: () => (MainPresenter
                                                .to.chartExpandNotifier.value =
                                            !MainPresenter
                                                .to.chartExpandNotifier.value),
                                        icon: Transform.translate(
                                          offset: Offset(0.0, -1.h),
                                          child: Obx(
                                            () => Icon(
                                              MainPresenter
                                                  .to.expandOrShrinkIcon.value,
                                            ),
                                          ),
                                        ),
                                        color: AppColor.whiteColor,
                                        iconSize: 7.h,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const Divider(),
                              SizedBox(height: 5.h),
                              MainPresenter.to.showDevModeViewOne(
                                  MainPresenter.to.devModeNotifier.value,
                                  context),
                              MainPresenter.to.showDevModeViewTwo(
                                  MainPresenter.to.devModeNotifier.value),
                              TrendMatchView(),
                              SizedBox(height: 10.h),
                              SubsequentAnalyticsView(context: context),
                              MainPresenter.to.showMatchedCandlestickCharts(),
                              MainPresenter.to
                                  .showUniversalMatchedCandlestickCharts(),
                              MainPresenter.to.buildCloudFunctionCol(),
                              SizedBox(height: 100.h),
                            ],
                          ),
                        ),
                        // Conditionally render the fixed header
                        if (MainPresenter.to.devMode.value && _isChartFrozen)
                          Obx(
                            () => Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: AppColor
                                    .blackColor, // Background color for visibility
                                child: SizedBox(
                                  width: 393.w,
                                  height:
                                      MainPresenter.to.matchedCandleChartHeight,
                                  child: InteractiveChart(
                                    candles: (snapshot.data!.length >
                                            (60 + MainPresenter.to.length.value)
                                        ? snapshot.data!.sublist(
                                            snapshot.data!.length -
                                                (60 +
                                                    MainPresenter
                                                        .to.length.value -
                                                    1),
                                            snapshot.data!.length)
                                        : snapshot.data!),
                                    style: ChartStyle(
                                      trendLineStyles:
                                          MainPresenter.to.trendLineStyles,
                                      selectionHighlightColor:
                                          Colors.red.withOpacity(0.75),
                                      overlayBackgroundColor:
                                          Colors.red.withOpacity(0.75),
                                      overlayTextStyle: const TextStyle(
                                          color: AppColor.whiteColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ));
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColor.errorColor,
                        size: 40.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextTheme().sp7,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.network(
                    //   'https://storage.googleapis.com/fplsblog/1/2020/04/line-graph.png',
                    //   fit: BoxFit.cover,
                    //   opacity: const AlwaysStoppedAnimation(.9),
                    //   color: ThemeColor.primary.value,
                    //   colorBlendMode: BlendMode.color,
                    // ),
                    Image(
                      image: const AssetImage('images/line-graph.png'),
                      fit: BoxFit.cover,
                      opacity: const AlwaysStoppedAnimation(.9),
                      color: ThemeColor.primary.value,
                      colorBlendMode: BlendMode.color,
                    ),
                    SizedBox(height: 5.h),
                    SizedBox(
                      width: 40.w,
                      height: 40.h,
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: ThemeColor.primary.value,
                        size: 25.w,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Text('downloading_candle'.tr,
                          style: const TextTheme().sp5),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
