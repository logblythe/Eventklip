import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

Duration convertTimeSpanToDuration(String timespan) {
  if (timespan == null) return Duration(seconds: 0);
  final timespanList = timespan.split(":");
  return timespanList.length < 3
      ? Duration(
      seconds: int.parse(timespanList.last),
      minutes: int.parse(timespanList.first))
      : Duration(
      seconds: int.parse(timespanList.last),
      minutes: int.parse(timespanList[1]),
      hours: int.parse(timespanList.first));
}

String formatTimeSpan(String timespan) {
  if (timespan == null) return "00:00";
  final timespanList = timespan.split(":");
  final seconds = timespanList.last;
  if (timespanList.length < 3) {
    final minutes = timespanList.first;
    final formattedSeconds = seconds.length == 2 ? seconds : "0$seconds";
    final formattedMinutes = minutes.length == 2 ? minutes : "0$minutes";
    return "$formattedMinutes:$formattedSeconds";
  }
  final minutes = timespanList[1];
  final hours = timespanList.first;
  final formattedSeconds = seconds.length == 2 ? seconds : "0$seconds";
  final formattedMinutes = minutes.length == 2 ? minutes : "0$minutes";
  final formattedHours = hours.length == 2 ? hours : "0$hours";
  return "$formattedHours:$formattedMinutes:$formattedSeconds";
}

String getInitials(String fullName) {
  final splittedName = fullName.split(" ");
  if (splittedName.length > 1) {
    return "${splittedName.first[0]}${splittedName.last[0]}";
  }
  return splittedName.isEmpty ? "-" : splittedName.first[0];
}

Color stringToHslColor(String str, s, l) {
  int hash = 0;
  for (var i = 0; i < str.length; i++) {
    hash = str.codeUnitAt(i) + ((hash << 5) - hash);
  }

  double h = (hash % 360).toDouble();
  return HSLColor.fromAHSL(1, h, s, l).toColor();
}

Future<Uint8List> getThumbData(File file) async {
  return await VideoThumbnail.thumbnailData(
    video: file.path,
    imageFormat: ImageFormat.JPEG,
    maxWidth: 200,
    quality: 25,
  );
}
