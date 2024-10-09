import 'dart:io';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:market_ai/styles/styles.dart';
import 'package:get/get.dart';

import 'package:market_ai/models/models.dart';
import 'package:market_ai/presenters/presenters.dart';
import 'package:market_ai/utils/utils.dart';
import 'package:market_ai/views/trendmatch_view.dart';

class AdjustedLineChart extends StatefulWidget {
  final bool isLockTrend;
  final bool isTracking;
  final LineChartData? initialLineChartData;

  const AdjustedLineChart({
    super.key,
    this.initialLineChartData,
    required this.isLockTrend,
    this.isTracking = false,
  });

  @override
  State<AdjustedLineChart> createState() => _AdjustedLineChartState();
}

class _AdjustedLineChartState extends State<AdjustedLineChart> {
  late Future<LineChartData> lineChartDataFuture;

  @override
  void initState() {
    super.initState();
    lineChartDataFuture = widget.initialLineChartData != null
        ? Future.value(widget.initialLineChartData)
        : TrendMatch().getDefaultAdjustedLineChartData(
            isLockTrend: widget.isLockTrend,
            isTracking: widget.isTracking,
          );
  }

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
                width: !widget.isTracking
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
                child: FutureBuilder<LineChartData>(
                  future: lineChartDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return TrendMatchView().showCircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}',
                          style: const TextTheme().sp5);
                    } else if (snapshot.hasData) {
                      return LineChart(snapshot.data!);
                    } else {
                      return Text('No data available',
                          style: const TextTheme().sp5);
                    }
                  },
                ),
              ),
              if (!widget.isTracking) ...[
                MainPresenter.to.sidePlot.value,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
