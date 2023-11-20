// set initial language according to device
import 'package:flutter/material.dart';
import 'package:get/get.dart';

String languageDev() {
  return Get.deviceLocale.toString().substring(0, 2) == 'en'
      ? 'en_US'
      : Get.deviceLocale.toString().substring(0, 2) == 'ar'
          ? 'ar_SA'
          : 'ar_SA';
}

// firebase error messages
String getMessageFromErrorCode({required String errorMessage}) {
  switch (errorMessage) {
    case "ERROR_EMAIL_ALREADY_IN_USE":
    case "account-exists-with-different-credential":
    case "email-already-in-use":
      return "firealready".tr;
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      return "firewrong".tr;
    case "ERROR_USER_NOT_FOUND":
    case "user-not-found":
      return "fireuser".tr;
    case "ERROR_USER_DISABLED":
    case "user-disabled":
      return "firedis".tr;
    case "ERROR_TOO_MANY_REQUESTS":
    case "ERROR_OPERATION_NOT_ALLOWED":
    case "operation-not-allowed":
      return "fireserver".tr;
    case "ERROR_INVALID_EMAIL":
    case "invalid-email":
      return "fireemail".tr;
    case 'invalid-verification-code':
      return 'fireverification'.tr;
    case 'INVALID_LOGIN_CREDENTIALS':
      return 'invalidcred'.tr;
    default:
      return "firelogin".tr;
  }
}

// formatt movie length
String getTimeString(int value) {
  final int hour = value ~/ 60;
  final int minutes = value % 60;
  return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
}

// excede max lines
bool maxLines(
    {required String text, required double width, required int maxLines}) {
  final span = TextSpan(text: text);
  final tp = TextPainter(
      text: span, maxLines: maxLines, textDirection: TextDirection.ltr);
  tp.layout(maxWidth: width);
  return tp.didExceedMaxLines;
}

// determin if a date has passed
bool isDatePassed({required String time}) {
  if (time == '') {
    return false;
  } else {
    return DateTime.parse(time).isBefore(DateTime.now());
  }
}
