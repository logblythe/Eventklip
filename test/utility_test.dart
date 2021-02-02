
import 'package:eventklip/utils/utility.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("convertTimeSpanToDuration test", (){
    final timespan="01:12";
    final timespan2="1:1";
    final timespan3="1:1:2";
    final expected = Duration(minutes: 1,seconds: 12);
    final expected2 = Duration(minutes: 1,seconds: 1);
    final expected3 = Duration(hours:1,minutes: 1,seconds: 2);
    test("timespan to duration test", () {
      Duration calculated = convertTimeSpanToDuration(timespan);
      expect(expected, calculated);
    });

    test("timespan to duration test 2 ", () {
      Duration calculated2 = convertTimeSpanToDuration(timespan2);
      expect(expected2, calculated2);
    });
    test("timespan to duration with hours",(){
      Duration calculated3 = convertTimeSpanToDuration(timespan3);
      expect(expected3, calculated3);
    });
  });
  group("formatTimeSpan test", (){
    final timespan="01:12";
    final timespan2="1:1";
    final timespan3="1:1:2";
    final expected="01:12";
    final expected2 ="01:01";
    final expected3 = "01:01:02";

    test("formatTimeSpan for null returns default", () {
      String calculated = formatTimeSpan(null);
      expect("00:00", calculated);
    });

    test("formatTimeSpan test", () {
      String calculated = formatTimeSpan(timespan);
      expect(expected, calculated);
    });

    test("formatTimeSpan test 2 ", () {
      String calculated2 = formatTimeSpan(timespan2);
      expect(expected2, calculated2);
    });
    test("formatTimeSpan with hours",(){
      String calculated3 = formatTimeSpan(timespan3);
      expect(expected3, calculated3);
    });
  });

}
