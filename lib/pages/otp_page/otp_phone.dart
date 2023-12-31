import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/square_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpPhone extends StatelessWidget {
  final String verificationId;
  const OtpPhone({super.key, required this.verificationId});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;

          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SquareButton(
                      isFilled: false,
                      function: () => Get.back(),
                      width: width * 0.1,
                      height: width * 0.1,
                      color: Theme.of(context).colorScheme.primary,
                      icon: controller.platform == TargetPlatform.iOS
                          ? CupertinoIcons.back
                          : Icons.arrow_back,
                      iconColor: Theme.of(context).colorScheme.background,
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                CustomText(
                  text: 'ver'.tr,
                  weight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                  size: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: CustomText(
                    text:
                        '${'codesend'.tr} ${controller.userModel.phoneNumber}',
                    //weight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 14,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 16),
                  child: SizedBox(
                    height: width * 0.3,
                    width: width,
                    child: PinFieldAutoFill(
                      controller: controller.otpController,
                      autoFocus: true,
                      decoration: UnderlineDecoration(
                        textStyle: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary),
                        colorBuilder: FixedColorBuilder(
                            Theme.of(context).colorScheme.secondary),
                      ),
                      currentCode: controller.otpController.text,
                      onCodeSubmitted: (code) {},
                      onCodeChanged: (code) => controller.onPtpChanged(
                          code: code,
                          context: context,
                          verificationId: verificationId),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.07,
                ),
                Expanded(
                  child: GetBuilder<AuthController>(
                    init: Get.find<AuthController>(),
                    builder: (build) => controller.loading
                        ? build.platform == TargetPlatform.iOS
                            ? CupertinoActivityIndicator(
                                color: Theme.of(context).colorScheme.secondary,
                                radius: 18,
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              )
                        : Container(),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
