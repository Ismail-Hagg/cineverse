// set initial language according to device
import 'package:cineverse/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
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

//calculate actor's age
int calculateAge({required String birthDate}) {
  DateTime bDate = DateTime.parse(birthDate);
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - bDate.year;
  int month1 = currentDate.month;
  int month2 = bDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = bDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}

//calculate time ago
String timeAgo(DateTime d) {
  Duration diff = DateTime.now().difference(d);
  if (diff.inDays > 365) {
    return "${(diff.inDays / 365).floor()} y ago";
  }
  if (diff.inDays > 30) {
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
  }
  if (diff.inDays > 7) {
    return "${(diff.inDays / 7).floor()} w ago";
  }
  if (diff.inDays > 0) {
    return "${diff.inDays} d ago";
  }
  if (diff.inHours > 0) {
    return "${diff.inHours} h ago";
  }
  if (diff.inMinutes > 0) {
    return "${diff.inMinutes} m ago";
  }
  return "just now";
}

// show dialog old way
void platforMulti(
    {required bool isIos,
    required String title,
    required List<String> buttonTitle,
    required String body,
    required List<Function()> func,
    bool? field,
    TextEditingController? controller,
    String? hint,
    Widget? child,
    required BuildContext context}) {
  if (isIos) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
            title: Text(
              title,
            ),
            content: field == true
                ? child ??
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: CupertinoTextField(
                        placeholder: hint,
                        autofocus: true,
                        controller: controller,
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(8)),
                        clearButtonMode: OverlayVisibilityMode.editing,
                      ),
                    )
                : Text(
                    body,
                  ),
            actions: buttonTitle
                .map((e) => CupertinoDialogAction(
                      onPressed: func[buttonTitle.indexOf(e)],
                      child: Text(e),
                    ))
                .toList()));
  } else {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
            title: Text(title),
            content: field == true
                ? child ??
                    TextField(
                      autofocus: true,
                      controller: controller,
                      cursorColor: Theme.of(context).colorScheme.primary,
                      decoration: InputDecoration(
                        hintText: hint,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        fillColor: Theme.of(context).colorScheme.primary,
                        focusColor: Theme.of(context).colorScheme.primary,
                      ),
                    )
                : Text(body),
            actions: buttonTitle
                .map((e) => TextButton(
                      onPressed: func[buttonTitle.indexOf(e)],
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                              Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2))),
                      child: CustomText(
                        text: e,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ))
                .toList()));
  }
}
