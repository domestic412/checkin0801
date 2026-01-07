import 'dart:ui';

import 'package:checkin/constant/global.dart';
import 'package:dio/dio.dart';

Future<void> sendCheckin({
  required String checkinId,
  required bool isChecked,
  required int numP,
  required String remark,
  required VoidCallback refresh,
}) async {
  final uri = '$SERVER/CheckIn/Attendance';
  var dataSend = {
    "checkinId": checkinId,
    "isChecked": isChecked,
    "numP": numP,
    "remark": remark,
  };
  final res = await dio.post(
    uri,
    data: dataSend,
    options: Options(
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST",
        "Content-Type": "application/json",
      },
    ),
  );

  if (res.statusCode! < 200 || res.statusCode! >= 300) {
    throw Exception('API error ${res.statusCode}: ${res.data}');
  }
  if (res.statusCode == 200) {
    refresh();
  }
}
