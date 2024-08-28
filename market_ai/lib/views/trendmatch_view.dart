import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:market_ai/presenters/presenters.dart';
import 'package:market_ai/services/prefs/prefs.dart';
import 'package:market_ai/styles/styles.dart';
import 'package:market_ai/utils/utils.dart';
import 'package:market_ai/views/charts/charts.dart';

class TrendMatchView extends StatelessWidget {
  // const TrendMatchView({super.key});

  // Singleton implementation
  static final TrendMatchView _instance = TrendMatchView._internal();
  factory TrendMatchView() {
    return _instance;
  }
  TrendMatchView._internal();

  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: MainPresenter.to.showStartBtn()),
          if (MainPresenter.to.trendMatched.value &&
              MainPresenter.to.showAnalytics.value) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  MainPresenter.to.lockTrendDatetimeString.value,
                  style: const TextTheme().sp7.tertiarythemeTextColor.w700,
                ),
                Text(
                  'instruction'.tr,
                  style: const TextTheme().sp5.w700,
                ),
                Text(
                  MainPresenter.to.instruction.value,
                  style: const TextTheme().sp10.tertiarythemeTextColor.w700,
                ),
                Text(
                  'prediction'.tr,
                  style: const TextTheme().sp5.w700,
                ),
                Text(
                  '${'expected_return_median'.tr} +${(MainPresenter.to.expectedReturn.value * 100).toStringAsFixed(4)}%',
                  style: const TextTheme().sp7.tertiarythemeTextColor.w700,
                ),
                Text(
                  '${'expected_mdd'.tr} ${MainPresenter.to.expectedMdd.value.substring(0, 1)}${(double.parse(MainPresenter.to.expectedMdd.value.substring(1)) * 100).toStringAsFixed(4)}%',
                  style: const TextTheme().sp7.tertiarythemeTextColor.w700,
                ),
                Text(
                  'considerations'.tr,
                  style: const TextTheme().sp5.w700,
                ),
                (MainPresenter.to.isFirstThirtyMins.value
                    ? Text(
                        'is_first_thirty_mins'.tr,
                        style:
                            const TextTheme().sp5.tertiarythemeTextColor.w700,
                      )
                    : Text(
                        'is_not_first_thirty_mins'.tr,
                        style:
                            const TextTheme().sp5.tertiarythemeTextColor.w700,
                      )),
                (MainPresenter.to.lowReturn.value
                    ? Text(
                        '${'low_return_rate'.tr + (MainPresenter.to.minReturnRateThreshold.value * 100).toStringAsFixed(3)}%',
                        style:
                            const TextTheme().sp5.tertiarythemeTextColor.w700,
                      )
                    : Text(
                        '${'profitable_return_rate'.tr + (MainPresenter.to.minReturnRateThreshold.value * 100).toStringAsFixed(3)}%',
                        style:
                            const TextTheme().sp5.tertiarythemeTextColor.w700,
                      )),
                (MainPresenter.to.lowProb.value
                    ? Text(
                        '${'low_probability'.tr + (MainPresenter.to.probThreshold.value * 100).toStringAsFixed(0)}%',
                        style:
                            const TextTheme().sp5.tertiarythemeTextColor.w700,
                      )
                    : Text(
                        '${'high_probability'.tr + (MainPresenter.to.probThreshold.value * 100).toStringAsFixed(0)}%',
                        style:
                            const TextTheme().sp5.tertiarythemeTextColor.w700,
                      )),
                (MainPresenter.to.trendsNotOneSided.value
                    ? (MainPresenter.to.trendsLessThanFive.value
                        ? Text(
                            'trends_less_than_five'.tr,
                            style: const TextTheme()
                                .sp5
                                .tertiarythemeTextColor
                                .w700,
                          )
                        : Text(
                            'trends_more_than_four'.tr,
                            style: const TextTheme()
                                .sp5
                                .tertiarythemeTextColor
                                .w700,
                          ))
                    : (MainPresenter.to.trendsOneSidedButLessThanFour.value
                        ? Text(
                            'trends_one_sided_but_less_than_four'.tr,
                            style: const TextTheme()
                                .sp5
                                .tertiarythemeTextColor
                                .w700,
                          )
                        : Text(
                            'trends_one_sided_but_more_than_three'.tr,
                            style: const TextTheme()
                                .sp5
                                .tertiarythemeTextColor
                                .w700,
                          ))),
                if (MainPresenter.to.isLockTrend.value) ...[
                  (MainPresenter.to.hitCeilingOrFloor.value
                      ? Text(
                          'hit_ceiling_or_floor'.tr,
                          style:
                              const TextTheme().sp5.tertiarythemeTextColor.w700,
                        )
                      : Text(
                          'not_hit_ceiling_or_floor'.tr,
                          style:
                              const TextTheme().sp5.tertiarythemeTextColor.w700,
                        ))
                ],
                if (MainPresenter.to.isLockTrend.value) ...[
                  (MainPresenter.to.goOpposite.value
                      ? Text(
                          'go_opposite'.tr,
                          style:
                              const TextTheme().sp5.tertiarythemeTextColor.w700,
                        )
                      : Text(
                          'not_go_opposite'.tr,
                          style:
                              const TextTheme().sp5.tertiarythemeTextColor.w700,
                        ))
                ],
                SizedBox(
                  height: 5.h,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (MainPresenter.to.isLockTrend.value) {
                      PrefsService.to.prefs
                          .setBool(SharedPreferencesConstant.lockTrend, false);
                      MainPresenter.to.isLockTrend.value = false;
                      MainPresenter.to.alwaysUseCrossData.value = false;
                      PrefsService.to.prefs.setBool(
                          SharedPreferencesConstant.alwaysUseCrossData, false);

                      PrefsService.to.prefs
                          .setString(SharedPreferencesConstant.img1, '');
                      PrefsService.to.prefs
                          .setString(SharedPreferencesConstant.img2, '');
                      PrefsService.to.prefs
                          .setString(SharedPreferencesConstant.img3, '');
                      PrefsService.to.prefs
                          .setString(SharedPreferencesConstant.img4, '');
                      PrefsService.to.prefs
                          .setString(SharedPreferencesConstant.img5, '');
                      PrefsService.to.prefs
                          .setString(SharedPreferencesConstant.img6, '');
                      PrefsService.to.prefs
                          .setString(SharedPreferencesConstant.img7, '');
                      PrefsService.to.prefs
                          .setString(SharedPreferencesConstant.img8, '');
                      PrefsService.to.prefs
                          .setString(SharedPreferencesConstant.img9, '');
                      PrefsService.to.prefs
                          .setString(SharedPreferencesConstant.img10, '');
                      MainPresenter.to.clusters.value = [];
                      PrefsService.to.prefs
                          .setStringList(SharedPreferencesConstant.cluster, []);
                      MainPresenter.to.hasCluster.value = false;
                      PrefsService.to.prefs.setInt(
                          SharedPreferencesConstant.lockTrendLastRow, 0);
                      PrefsService.to.prefs.setInt(
                          SharedPreferencesConstant.lockTrendLastDatetime, 0);
                      MainPresenter.to.refreshIndicator();
                    } else {
                      int matchedTrends = MainPresenter.to.matchRows.length +
                          MainPresenter.to.spyMatchRows.length +
                          MainPresenter.to.qqqMatchRows.length +
                          MainPresenter.to.usoMatchRows.length +
                          MainPresenter.to.gldMatchRows.length +
                          MainPresenter.to.slvMatchRows.length +
                          MainPresenter.to.iwmMatchRows.length +
                          MainPresenter.to.xlkMatchRows.length +
                          MainPresenter.to.aaplMatchRows.length +
                          MainPresenter.to.baMatchRows.length +
                          MainPresenter.to.bacMatchRows.length +
                          MainPresenter.to.mcdMatchRows.length +
                          MainPresenter.to.nvdaMatchRows.length +
                          MainPresenter.to.msftMatchRows.length +
                          MainPresenter.to.gskMatchRows.length +
                          MainPresenter.to.tslaMatchRows.length +
                          MainPresenter.to.amznMatchRows.length;
                      if (matchedTrends < 4) {
                        MainPresenter.to.showScaffoldMessenger(
                            context: context,
                            localizedMsg: 'trends_not_enough'.tr);
                        return;
                      }
                      PrefsService.to.prefs
                          .setBool(SharedPreferencesConstant.lockTrend, true);
                      MainPresenter.to.isLockTrend.value = true;
                    }
                  },
                  icon: Icon(
                    (MainPresenter.to.isLockTrend.value
                        ? Icons.lock_open_rounded
                        : Icons.lock_clock),
                    size: 10.h,
                  ),
                  label: Text(
                    (MainPresenter.to.isLockTrend.value
                        ? 'unlock_trend'.tr
                        : 'lock_trend'.tr),
                    style: const TextTheme().sp5.w700,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
              ],
            )
          ],
          if ((MainPresenter.to.isLockTrend.value &&
                  MainPresenter.to.clusters.isNotEmpty) ||
              (MainPresenter.to.isLockTrend.value &&
                  MainPresenter.to.hasCluster.value)) ...[
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdjustedLineChart(isCluster: true),
                ],
              ),
            )
          ],
          if (!MainPresenter.to.isLockTrend.value) ...[
            Center(child: MainPresenter.to.showTm())
          ],
        ],
      ),
    );
  }

  Widget showAdjustedLineChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Tooltip(
                key: tooltipkey,
                triggerMode: TooltipTriggerMode.manual,
                message:
                    '1) We adjusted last prices to be the same as the last selected price and apply to previous prices. \n2) adjusted first prices to be the same as the last selected price and apply to subsequent prices.',
                child: Text(
                  '${'recent'.tr}${MainPresenter.to.length.toString()}${'tm_title1'.tr}${MainPresenter.to.tolerance.toString()}${'tm_title2'.tr}',
                  style: const TextTheme().sp5.w700,
                ),
              ),
            ),
            SizedBox(
              height:
                  (Platform.isWindows || Platform.isLinux || Platform.isMacOS
                      ? 14.h
                      : 10.h),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: ThemeColor.primary.value),
                child: IconButton(
                  onPressed: () =>
                      tooltipkey.currentState?.ensureTooltipVisible(),
                  icon: Transform.translate(
                    offset: Offset(0.0, -1.5.h),
                    child: const Icon(
                      Icons.question_mark,
                    ),
                  ),
                  color: AppColor.whiteColor,
                  iconSize: 7.h,
                ),
              ),
            )
          ],
        ),
        AdjustedLineChart(isCluster: false),
        MainPresenter.to.showMatchesExceededMsg(),
      ],
    );
  }

  Widget showCircularProgressIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20.w,
          height: (Platform.isWindows || Platform.isLinux || Platform.isMacOS
              ? 25.h
              : 20.h),
          child: const CircularProgressIndicator(),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Text('trend_matching'.tr, style: const TextTheme().sp5),
        ),
      ],
    );
  }
}
