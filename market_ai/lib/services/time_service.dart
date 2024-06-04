import 'package:intl/intl.dart';
import 'package:get/get.dart';

class TimeService extends GetxService {
  // Singleton implementation
  static final TimeService _instance = TimeService._();
  factory TimeService() => _instance;
  TimeService._();

  static TimeService get to => Get.find();

  Future<TimeService> init() async {
    return this;
  }

  int convertToUnixTimestamp(String dateString) {
    final DateFormat format = DateFormat('yyyy-MM-dd');
    final DateTime date = format.parse(dateString);
    final int timestamp = date.millisecondsSinceEpoch ~/ 1000;
    return timestamp;
  }

  bool isEasternDaylightTime(DateTime dateTime) {
    int year = dateTime.year;
    DateTime startDst =
        DateTime.utc(year, 3, 8 + (7 - DateTime.utc(year, 3, 1).weekday) % 7);
    DateTime endDst =
        DateTime.utc(year, 11, 1 + (7 - DateTime.utc(year, 11, 1).weekday) % 7);
    return dateTime.isAfter(startDst) && dateTime.isBefore(endDst);
  }

  bool isEasternStandardTime(DateTime dateTime) {
    return !isEasternDaylightTime(dateTime);
  }

  DateTime subtractHoursBasedOnTimezone(DateTime dateTime) {
    int hoursToSubtract = isEasternDaylightTime(dateTime) ? 4 : 5;
    Duration duration = Duration(hours: hoursToSubtract);
    DateTime subtractedDateTime = dateTime.subtract(duration);
    return subtractedDateTime;
  }
}
