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
  final isLockTrend = false;

  AdjustedLineChart(
      {super.key, LineChartData? lineChartData, required bool isLockTrend})
      : lineChartData = lineChartData ??
            TrendMatch()
                .getDefaultAdjustedLineChartData(isLockTrend: isLockTrend);

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
                width: MainPresenter.to.tmChartWidth.value,
                height:
                    (Platform.isWindows || Platform.isLinux || Platform.isMacOS
                        ? 120.h
                        : 85.h),
                child: LineChart(lineChartData),
              ),
              MainPresenter.to.sidePlot.value,
            ],
          ),
        ),
      ),
    );
  }
}
