import 'package:isar/isar.dart';

part 'collections.g.dart';

// After modification run: flutter pub run build_runner build

@Collection()
class SpyData {
  Id id = Isar.autoIncrement;

  late int timeKey;
  late double open;
  late double high;
  late double low;
  late double close;
  late double volume;

  SpyData();

  SpyData.fromJson(Map<String, dynamic> json)
      : timeKey = json['time_key'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        volume = json['volume'];

  Map<String, dynamic> toJson() => {
        'time_key': timeKey,
        'open': open,
        'high': high,
        'low': low,
        'close': close,
        'volume': volume,
      };
}

@Collection()
class QqqData {
  Id id = Isar.autoIncrement;

  late int timeKey;
  late double open;
  late double high;
  late double low;
  late double close;
  late double volume;

  QqqData();

  QqqData.fromJson(Map<String, dynamic> json)
      : timeKey = json['time_key'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        volume = json['volume'];

  Map<String, dynamic> toJson() => {
        'time_key': timeKey,
        'open': open,
        'high': high,
        'low': low,
        'close': close,
        'volume': volume,
      };
}

@Collection()
class UsoData {
  Id id = Isar.autoIncrement;

  late int timeKey;
  late double open;
  late double high;
  late double low;
  late double close;
  late double volume;

  UsoData();

  UsoData.fromJson(Map<String, dynamic> json)
      : timeKey = json['time_key'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        volume = json['volume'];

  Map<String, dynamic> toJson() => {
        'time_key': timeKey,
        'open': open,
        'high': high,
        'low': low,
        'close': close,
        'volume': volume,
      };
}

@Collection()
class GldData {
  Id id = Isar.autoIncrement;

  late int timeKey;
  late double open;
  late double high;
  late double low;
  late double close;
  late double volume;

  GldData();

  GldData.fromJson(Map<String, dynamic> json)
      : timeKey = json['time_key'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        volume = json['volume'];

  Map<String, dynamic> toJson() => {
        'time_key': timeKey,
        'open': open,
        'high': high,
        'low': low,
        'close': close,
        'volume': volume,
      };
}
