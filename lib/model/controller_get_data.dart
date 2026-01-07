import 'package:get/get.dart';

final CheckinController checkinController = Get.put(CheckinController());

class CheckinController extends GetxController {
  var numAll = 0.obs;
  var numCheck = 0.obs;
  var numChecked = 0.obs;
  var numP_checked = 0.obs;
  var numP_check = 0.obs;

  updateNumCheck({
    required int numAll,
    required int numCheck,
    required int numChecked,
    required int numP_checked,
    required int numP_check,
  }) {
    this.numAll.value = numAll;
    this.numCheck.value = numCheck;
    this.numChecked.value = numChecked;
    this.numP_checked.value = numP_checked;
    this.numP_check.value = numP_check;
  }
}
