import 'package:get/get.dart';

class ChatController extends GetxController {
  String rec = '';

  @override
  void onInit() {
    super.onInit();
    rec = Get.arguments ?? 'nothing';
  }
}
