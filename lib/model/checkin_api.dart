import 'package:checkin/constant/global.dart';
import 'package:checkin/model/controller_get_data.dart';
import 'package:checkin/model/model_get_data.dart';

class CheckinApi {
  Future<List<CheckinGuest>> fetchCheckins() async {
    final uri = '$SERVER/CheckIn/GetAll';
    final res = await dio.get(uri);

    if (res.statusCode! < 200 || res.statusCode! >= 300) {
      throw Exception('API error ${res.statusCode}: ${res.data}');
    }

    final data = res.data;
    if (data is! List) return [];
    List<dynamic> body = res.data;
    List<CheckinGuest> dataCheckin = body
        .map((data) => CheckinGuest.fromJson(data))
        .toList();
    int numAll = dataCheckin.length;
    int numCheck = 0;
    int numChecked = 0;
    int numP_checked = 0;
    int numP_check = 0;

    for (var list in dataCheckin) {
      if (list.isChecked == true) {
        numChecked = numChecked + 1;
        numP_checked = numP_checked + list.numP;
      } else {
        numCheck = numCheck + 1;
        numP_check = numP_check + list.numP;
      }
      // numAll = numAll + 1;
    }
    checkinController.updateNumCheck(
      numAll: numAll,
      numCheck: numCheck,
      numChecked: numChecked,
      numP_checked: numP_checked,
      numP_check: numP_check,
    );

    return data
        .whereType<Map<String, dynamic>>()
        .map(CheckinGuest.fromJson)
        .toList();
  }
}
