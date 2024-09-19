import 'dart:io';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:market_ai/styles/styles.dart';
import 'package:get/get.dart';

import 'package:market_ai/models/models.dart';
import 'package:market_ai/presenters/presenters.dart';
import 'package:market_ai/utils/utils.dart';

class AdjustedLineChart extends StatelessWidget {
  final LineChartData lineChartData;
  final bool isTracking;

  AdjustedLineChart({
    super.key,
    LineChartData? lineChartData,
    required bool isLockTrend,
    this.isTracking = false,
  }) : lineChartData = lineChartData ??
            TrendMatch().getDefaultAdjustedLineChartData(
                isLockTrend: isLockTrend, isTracking: isTracking);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: (MainPresenter.to.darkMode.value
                ? AppColor.whiteColor.withOpacity(0.5)
                : AppColor.blackColor.withOpacity(0.1)), // Set 50% transparency
          ),
          child: Row(
            children: [
              SizedBox(
                width: !isTracking
                    ? MainPresenter.to.tmChartWidth.value
                    : (Platform.isWindows ||
                            Platform.isLinux ||
                            Platform.isMacOS
                        ? (Get.width - 5.w)
                        : 135.w),
                height:
                    (Platform.isWindows || Platform.isLinux || Platform.isMacOS
                        ? 120.h
                        : 85.h),
                child: LineChart(lineChartData),
              ),
              if (!isTracking) ...[
                MainPresenter.to.sidePlot.value,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
