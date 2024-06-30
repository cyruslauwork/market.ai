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
  late int volume;

  SpyData();

  SpyData.fromJson(Map<String, dynamic> json)
      : timeKey = json['time_key'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        volume =
            (json['volume'] is int) ? json['volume'] : json['volume'].toInt();

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
  late int volume;

  QqqData();

  QqqData.fromJson(Map<String, dynamic> json)
      : timeKey = json['time_key'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        volume =
            (json['volume'] is int) ? json['volume'] : json['volume'].toInt();

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
  late int volume;

  UsoData();

  UsoData.fromJson(Map<String, dynamic> json)
      : timeKey = json['time_key'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        volume =
            (json['volume'] is int) ? json['volume'] : json['volume'].toInt();

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
  late int volume;

  GldData();

  GldData.fromJson(Map<String, dynamic> json)
      : timeKey = json['time_key'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        volume =
            (json['volume'] is int) ? json['volume'] : json['volume'].toInt();

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
class SlvData {
  Id id = Isar.autoIncrement;

  late int timeKey;
  late double open;
  late double high;
  late double low;
  late double close;
  late int volume;

  SlvData();

  SlvData.fromJson(Map<String, dynamic> json)
      : timeKey = json['time_key'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        volume =
            (json['volume'] is int) ? json['volume'] : json['volume'].toInt();

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
class IwmData {
  Id id = Isar.autoIncrement;

  late int timeKey;
  late double open;
  late double high;
  late double low;
  late double close;
  late int volume;

  IwmData();

  IwmData.fromJson(Map<String, dynamic> json)
      : timeKey = json['time_key'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        volume =
            (json['volume'] is int) ? json['volume'] : json['volume'].toInt();

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
class XlkData {
  Id id = Isar.autoIncrement;

  late int timeKey;
  late double open;
  late double high;
  late double low;
  late double close;
  late int volume;

  XlkData();

  XlkData.fromJson(Map<String, dynamic> json)
      : timeKey = json['time_key'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        volume =
            (json['volume'] is int) ? json['volume'] : json['volume'].toInt();

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
class AaplData {
  Id id = Isar.autoIncrement;

  late int timeKey;
  late double open;
  late double high;
  late double low;
  late double close;
  late int volume;

  AaplData();

  AaplData.fromJson(Map<String, dynamic> json)
      : timeKey = json['time_key'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        volume =
            (json['volume'] is int) ? json['volume'] : json['volume'].toInt();

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
class BaData {
  Id id = Isar.autoIncrement;

  late int timeKey;
  late double open;
  late double high;
  late double low;
  late double close;
  late int volume;

  BaData();

  BaData.fromJson(Map<String, dynamic> json)
      : timeKey = json['time_key'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        volume =
            (json['volume'] is int) ? json['volume'] : json['volume'].toInt();

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
class BacData {
  Id id = Isar.autoIncrement;

  late int timeKey;
  late double open;
  late double high;
  late double low;
  late double close;
  late int volume;

  BacData();

  BacData.fromJson(Map<String, dynamic> json)
      : timeKey = json['time_key'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        volume =
            (json['volume'] is int) ? json['volume'] : json['volume'].toInt();

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
class McdData {
  Id id = Isar.autoIncrement;

  late int timeKey;
  late double open;
  late double high;
  late double low;
  late double close;
  late int volume;

  McdData();

  McdData.fromJson(Map<String, dynamic> json)
      : timeKey = json['time_key'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        volume =
            (json['volume'] is int) ? json['volume'] : json['volume'].toInt();

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
class NvdaData {
  Id id = Isar.autoIncrement;

  late int timeKey;
  late double open;
  late double high;
  late double low;
  late double close;
  late int volume;

  NvdaData();

  NvdaData.fromJson(Map<String, dynamic> json)
      : timeKey = json['time_key'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        volume =
            (json['volume'] is int) ? json['volume'] : json['volume'].toInt();

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
class MsftData {
  Id id = Isar.autoIncrement;

  late int timeKey;
  late double open;
  late double high;
  late double low;
  late double close;
  late int volume;

  MsftData();

  MsftData.fromJson(Map<String, dynamic> json)
      : timeKey = json['time_key'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        volume =
            (json['volume'] is int) ? json['volume'] : json['volume'].toInt();

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
class GskData {
  Id id = Isar.autoIncrement;

  late int timeKey;
  late double open;
  late double high;
  late double low;
  late double close;
  late int volume;

  GskData();

  GskData.fromJson(Map<String, dynamic> json)
      : timeKey = json['time_key'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        volume =
            (json['volume'] is int) ? json['volume'] : json['volume'].toInt();

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
class TslaData {
  Id id = Isar.autoIncrement;

  late int timeKey;
  late double open;
  late double high;
  late double low;
  late double close;
  late int volume;

  TslaData();

  TslaData.fromJson(Map<String, dynamic> json)
      : timeKey = json['time_key'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        volume =
            (json['volume'] is int) ? json['volume'] : json['volume'].toInt();

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
class AmznData {
  Id id = Isar.autoIncrement;

  late int timeKey;
  late double open;
  late double high;
  late double low;
  late double close;
  late int volume;

  AmznData();

  AmznData.fromJson(Map<String, dynamic> json)
      : timeKey = json['time_key'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        volume =
            (json['volume'] is int) ? json['volume'] : json['volume'].toInt();

  Map<String, dynamic> toJson() => {
        'time_key': timeKey,
        'open': open,
        'high': high,
        'low': low,
        'close': close,
        'volume': volume,
      };
}
