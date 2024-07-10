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
          (MainPresenter.to.trendMatched.value &&
                  MainPresenter.to.showAnalytics.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      MainPresenter.to.lockTrendDatetimeString.value,
                      style: const TextTheme().sp7.primaryTextColor.w700,
                    ),
                    Text(
                      'instruction'.tr,
                      style: const TextTheme().sp5.w700,
                    ),
                    Text(
                      MainPresenter.to.instruction.value,
                      style: const TextTheme().sp10.primaryTextColor.w700,
                    ),
                    Text(
                      'prediction'.tr,
                      style: const TextTheme().sp5.w700,
                    ),
                    Text(
                      '${'expected_return_mean'.tr} ${MainPresenter.to.expectedReturn.value}',
                      style: const TextTheme().sp7.primaryTextColor.w700,
                    ),
                    Text(
                      '${'expected_mdd'.tr} ${MainPresenter.to.expectedMdd.value.toString()}',
                      style: const TextTheme().sp7.primaryTextColor.w700,
                    ),
                    Text(
                      'considerations'.tr,
                      style: const TextTheme().sp5.w700,
                    ),
                    (MainPresenter.to.isFirstThirtyMins.value
                        ? Text(
                            'is_first_thirty_mins'.tr,
                            style: const TextTheme().sp5.primaryTextColor.w700,
                          )
                        : Text(
                            'is_not_first_thirty_mins'.tr,
                            style: const TextTheme().sp5.primaryTextColor.w700,
                          )),
                    (MainPresenter.to.lowReturn.value
                        ? Text(
                            'low_return_rate'.tr,
                            style: const TextTheme().sp5.primaryTextColor.w700,
                          )
                        : Text(
                            'profitable_return_rate'.tr,
                            style: const TextTheme().sp5.primaryTextColor.w700,
                          )),
                    (MainPresenter.to.lowProb.value
                        ? Text(
                            'low_probability'.tr,
                            style: const TextTheme().sp5.primaryTextColor.w700,
                          )
                        : Text(
                            'high_probability'.tr,
                            style: const TextTheme().sp5.primaryTextColor.w700,
                          )),
                    (MainPresenter.to.trendsLessThanFive.value
                        ? Text(
                            'trends_less_than_five'.tr,
                            style: const TextTheme().sp5.primaryTextColor.w700,
                          )
                        : Text(
                            'trends_more_than_four'.tr,
                            style: const TextTheme().sp5.primaryTextColor.w700,
                          )),
                    (MainPresenter.to.trendsOneSidedButLessThanFour.value
                        ? Text(
                            'trends_one_sided_but_less_than_four'.tr,
                            style: const TextTheme().sp5.primaryTextColor.w700,
                          )
                        : Text(
                            'trends_one_sided_but_more_than_three'.tr,
                            style: const TextTheme().sp5.primaryTextColor.w700,
                          )),
                    (MainPresenter.to.isLockTrend.value
                        ? (MainPresenter.to.hitCeilingOrFloor.value
                            ? Text(
                                'hit_ceiling_or_floor'.tr,
                                style:
                                    const TextTheme().sp5.primaryTextColor.w700,
                              )
                            : Text(
                                'not_hit_ceiling_or_floor'.tr,
                                style:
                                    const TextTheme().sp5.primaryTextColor.w700,
                              ))
                        : const SizedBox.shrink()),
                    (MainPresenter.to.isLockTrend.value
                        ? (MainPresenter.to.goOpposite.value
                            ? Text(
                                'go_opposite'.tr,
                                style:
                                    const TextTheme().sp5.primaryTextColor.w700,
                              )
                            : Text(
                                'not_go_opposite'.tr,
                                style:
                                    const TextTheme().sp5.primaryTextColor.w700,
                              ))
                        : const SizedBox.shrink()),
                    SizedBox(
                      height: 5.h,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (MainPresenter.to.isLockTrend.value) {
                          PrefsService.to.prefs.setBool(
                              SharedPreferencesConstant.lockTrend, false);
                          MainPresenter.to.isLockTrend.value = false;
                          MainPresenter.to.alwaysUseCrossData.value = false;
                          PrefsService.to.prefs.setBool(
                              SharedPreferencesConstant.alwaysUseCrossData,
                              false);

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
                          PrefsService.to.prefs.setStringList(
                              SharedPreferencesConstant.cluster, []);
                          MainPresenter.to.hasCluster.value = false;
                          PrefsService.to.prefs.setInt(
                              SharedPreferencesConstant.lockTrendLastRow, 0);
                          PrefsService.to.prefs.setInt(
                              SharedPreferencesConstant.lockTrendLastDatetime,
                              0);
                          MainPresenter.to.refreshIndicator();
                        } else {
                          PrefsService.to.prefs.setInt(
                              SharedPreferencesConstant.lockTrendLastRow,
                              MainPresenter.to.candleListList.length - 1);

                          PrefsService.to.prefs.setBool(
                              SharedPreferencesConstant.lockTrend, true);
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
              : const SizedBox.shrink()),
          ((MainPresenter.to.isLockTrend.value &&
                      MainPresenter.to.clusters.isNotEmpty) ||
                  (MainPresenter.to.isLockTrend.value &&
                      MainPresenter.to.hasCluster.value)
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdjustedLineChart(isCluster: true),
                    ],
                  ),
                )
              : const SizedBox.shrink()),
          (!MainPresenter.to.isLockTrend.value
              ? Center(child: MainPresenter.to.showTm())
              : const SizedBox.shrink()),
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
