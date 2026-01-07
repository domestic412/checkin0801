class CheckinGuest {
  final String checkinId;
  final int seq;
  final String name;
  final bool isChecked;
  final int numP;
  final String remark;
  final String updateTime;

  CheckinGuest({
    required this.checkinId,
    required this.seq,
    required this.name,
    required this.isChecked,
    required this.numP,
    required this.remark,
    required this.updateTime,
  });

  factory CheckinGuest.fromJson(Map<String, dynamic> json) {
    return CheckinGuest(
      checkinId: (json['checkinId'] ?? '').toString(),
      seq: (json['seq'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? '').toString(),
      isChecked: json['isChecked'] == true,
      numP: (json['numP'] as num?)?.toInt() ?? 0,
      remark: (json['remark'] ?? '').toString(),
      updateTime: (json['updateTime'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'checkinId': checkinId,
      'seq': seq,
      'name': name,
      'isChecked': isChecked,
      'numP': numP,
      'remark': remark,
      'updateTime': updateTime,
    };
  }
}

// Future<List<CheckinGuest>> fetchData() async {
//   try {
//     var url = '$SERVER/CheckIn/GetAll';
//     final response = await dio.get(
//       url,
//       options: Options(headers: {"Content-Type": "application/json"}),
//     );
//     switch (response.statusCode) {
//       case 200:
//         // EasyLoading.dismiss();
//         List<dynamic> body = response.data;
//         List<CheckinGuest> data = body
//             .map((data) => CheckinGuest.fromJson(data))
//             .toList();
//         print('Get all id');
//         int numAll = body.length;
//         int numCheck = 0;
//         int numChecked = 0;
//         int numP_checked = 0;
//         int numP_check = 0;

//         for (var list in data) {
//           if (list.isChecked == true) {
//             numChecked = numChecked + 1;
//             numP_checked = numP_checked + list.numP;
//           } else {
//             numCheck = numCheck + 1;
//             numP_check = numP_check + list.numP;
//           }
//           // numAll = numAll + 1;
//         }
//         checkinController.updateNumCheck(
//           numAll: numAll,
//           numCheck: numCheck,
//           numChecked: numChecked,
//           numP_checked: numP_checked,
//           numP_check: numP_check,
//         );
//         return data;
//       default:
//         // EasyLoading.dismiss();
//         throw Exception('Error: GetData ${response.statusCode}');
//     }
//   } on Exception catch (e) {
//     // EasyLoading.dismiss();
//     throw Exception('Error: $e GetData');
//   }
// }
