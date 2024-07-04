import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:market_ai/presenters/presenters.dart';
import 'package:market_ai/styles/styles.dart';
import 'package:market_ai/utils/utils.dart';
import 'package:market_ai/views/herophotoview_routewrapper.dart';
import 'package:market_ai/services/prefs/prefs.dart';

class SubsequentAnalyticsView extends StatelessWidget {
  final BuildContext? context;

  // const SubsequentAnalyticsView({super.key, required this.context});

  // Singleton implementation
  static SubsequentAnalyticsView? _instance;
  factory SubsequentAnalyticsView({Key? key, BuildContext? context}) {
    _instance ??= SubsequentAnalyticsView._(
      key: key,
      context: context,
    );
    return _instance!;
  }
  const SubsequentAnalyticsView._({super.key, this.context});

  @override
  Widget build(BuildContext context) {
    return Center(child: MainPresenter.to.showSa());
  }

  Widget showSaChart() {
    String? img1 =
        PrefsService.to.prefs.getString(SharedPreferencesConstant.img1);
    Uint8List img1Bytes = ((img1 != null || img1 != '')
        ? base64Decode(img1!)
        : MainPresenter.to.img1Bytes.value);
    String? img2 =
        PrefsService.to.prefs.getString(SharedPreferencesConstant.img2);
    Uint8List img2Bytes = ((img2 != null || img2 != '')
        ? base64Decode(img2!)
        : MainPresenter.to.img2Bytes.value);
    String? img3 =
        PrefsService.to.prefs.getString(SharedPreferencesConstant.img3);
    Uint8List img3Bytes = ((img3 != null || img3 != '')
        ? base64Decode(img3!)
        : MainPresenter.to.img3Bytes.value);
    String? img4 =
        PrefsService.to.prefs.getString(SharedPreferencesConstant.img4);
    Uint8List img4Bytes = ((img4 != null || img4 != '')
        ? base64Decode(img4!)
        : MainPresenter.to.img4Bytes.value);
    String? img8 =
        PrefsService.to.prefs.getString(SharedPreferencesConstant.img8);
    Uint8List img8Bytes = ((img8 != null || img8 != '')
        ? base64Decode(img8!)
        : MainPresenter.to.img8Bytes.value);
    return Column(
      children: [
        Obx(
          () => (MainPresenter.to.alwaysShowSdDistPlot.value
              ? GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context!,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: HeroPhotoViewRouteWrapper(
                            imageProvider: MemoryImage(
                              img8Bytes,
                            ),
                            minScale: 0.48,
                          ),
                        );
                      },
                    );
                  },
                  child: Hero(tag: 'img8', child: Image.memory(img8Bytes)),
                )
              : const SizedBox.shrink()),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context!,
              builder: (BuildContext context) {
                return Dialog(
                  child: HeroPhotoViewRouteWrapper(
                    imageProvider: MemoryImage(
                      img1Bytes,
                    ),
                    minScale: 0.48,
                  ),
                );
              },
            );
          },
          child: Hero(tag: 'img1', child: Image.memory(img1Bytes)),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context!,
              builder: (BuildContext context) {
                return Dialog(
                  child: HeroPhotoViewRouteWrapper(
                    imageProvider: MemoryImage(
                      img2Bytes,
                    ),
                  ),
                );
              },
            );
          },
          child: Hero(tag: 'img2', child: Image.memory(img2Bytes)),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context!,
              builder: (BuildContext context) {
                return Dialog(
                  child: HeroPhotoViewRouteWrapper(
                    imageProvider: MemoryImage(
                      img3Bytes,
                    ),
                  ),
                );
              },
            );
          },
          child: Hero(tag: 'img3', child: Image.memory(img3Bytes)),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context!,
              builder: (BuildContext context) {
                return Dialog(
                  child: HeroPhotoViewRouteWrapper(
                    imageProvider: MemoryImage(
                      img4Bytes,
                    ),
                  ),
                );
              },
            );
          },
          child: Hero(tag: 'img4', child: Image.memory(img4Bytes)),
        ),
        SizedBox(height: 5.h),
      ],
    );
  }

  Widget showSaDevChart() {
    String? img5 =
        PrefsService.to.prefs.getString(SharedPreferencesConstant.img5);
    Uint8List img5Bytes = ((img5 != null || img5 != '')
        ? base64Decode(img5!)
        : MainPresenter.to.img5Bytes.value);
    String? img6 =
        PrefsService.to.prefs.getString(SharedPreferencesConstant.img6);
    Uint8List img6Bytes = ((img6 != null || img6 != '')
        ? base64Decode(img6!)
        : MainPresenter.to.img6Bytes.value);
    String? img7 =
        PrefsService.to.prefs.getString(SharedPreferencesConstant.img7);
    Uint8List img7Bytes = ((img7 != null || img7 != '')
        ? base64Decode(img7!)
        : MainPresenter.to.img7Bytes.value);
    String? img9 =
        PrefsService.to.prefs.getString(SharedPreferencesConstant.img9);
    Uint8List img9Bytes = ((img9 != null || img9 != '')
        ? base64Decode(img9!)
        : MainPresenter.to.img9Bytes.value);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context!,
              builder: (BuildContext context) {
                return Dialog(
                  child: HeroPhotoViewRouteWrapper(
                    imageProvider: MemoryImage(
                      img9Bytes,
                    ),
                    minScale: 0.77,
                  ),
                );
              },
            );
          },
          child: Hero(tag: 'img9', child: Image.memory(img9Bytes)),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context!,
              builder: (BuildContext context) {
                return Dialog(
                  child: HeroPhotoViewRouteWrapper(
                    imageProvider: MemoryImage(
                      MainPresenter.to.img5Bytes.value,
                    ),
                  ),
                );
              },
            );
          },
          child: Hero(tag: 'img5', child: Image.memory(img5Bytes)),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context!,
              builder: (BuildContext context) {
                return Dialog(
                  child: HeroPhotoViewRouteWrapper(
                    imageProvider: MemoryImage(
                      MainPresenter.to.img6Bytes.value,
                    ),
                  ),
                );
              },
            );
          },
          child: Hero(tag: 'img6', child: Image.memory(img6Bytes)),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context!,
              builder: (BuildContext context) {
                return Dialog(
                  child: HeroPhotoViewRouteWrapper(
                    imageProvider: MemoryImage(
                      MainPresenter.to.img7Bytes.value,
                    ),
                  ),
                );
              },
            );
          },
          child: Hero(tag: 'img7', child: Image.memory(img7Bytes)),
        ),
        SizedBox(height: 5.h),
      ],
    );
  }

  Widget showError() {
    return Text(
      MainPresenter.to.subsequentAnalyticsErr.value,
      style: const TextTheme().sp5,
    );
  }

  Widget showCircularProgressIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LoadingAnimationWidget.discreteCircle(
          color: ThemeColor.primary.value,
          secondRingColor: ThemeColor.secondary.value,
          thirdRingColor: ThemeColor.tertiary.value,
          size: 20.w,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Text('sub_analyzing'.tr, style: const TextTheme().sp5),
        ),
        SizedBox(height: 5.h),
      ],
    );
  }
}
