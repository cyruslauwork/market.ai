import 'dart:io';
import 'package:get/get.dart';

enum Flavor {
  dev('DEV', 'https://xxx.dev/api/v1/'),
  uat('UAT', 'https://xxx.dev/api/v1/'),
  prod('PROD', 'https://xxx.dev/api/v1/');

  const Flavor(this.name, this.configUrl);

  final String name;
  final String configUrl;

  bool get isDev => this == dev;
  bool get isUat => this == uat;
  bool get isProd => this == prod;
}

class FlavorService extends GetxService {
  // Singleton implementation
  static FlavorService? _instance;
  factory FlavorService() {
    _instance ??= FlavorService._();
    return _instance!;
  }
  FlavorService._();

  static FlavorService get to => Get.find();

  late final Flavor flavor;
  String version = "";
  String platform = "";
  String uuid = "";
  String fcmToken = "";

  Future<FlavorService> init(Flavor flavor) async {
    this.flavor = flavor;

    platform = Platform.isAndroid ? 'android' : 'ios';
    return this;
  }
}

enum RouteName {
  mainView('/mainview'),
  searchView('/searchview'),
  chatView('/chatview');

  const RouteName(this.path);

  final String path;
}

enum SrcFileType {
  csv,
  json;
}

enum Question {
  affecting,
  challenges;

  static String getQuestionText(Question question) {
    switch (question) {
      case Question.affecting:
        return 'question1'.tr;
      case Question.challenges:
        return 'question2'.tr;
    }
  }
}

enum Err {
  apiKey('Invalid API key'),
  invalidJson('Invalid JSON response');

  const Err(this.name);

  final String name;
}
