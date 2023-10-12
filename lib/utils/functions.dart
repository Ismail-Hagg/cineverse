// set initial language according to device
import 'package:get/get.dart';

String languageDev() {
  return Get.deviceLocale.toString().substring(0, 2) == 'en'
      ? 'en_US'
      : Get.deviceLocale.toString().substring(0, 2) == 'ar'
          ? 'ar_SA'
          : 'ar_SA';
}
