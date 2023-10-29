import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/pages/otp_page/otp_controller.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/login_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../utils/constants.dart';

class PreOtpPhone extends StatelessWidget {
  const PreOtpPhone({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: controller.platform == TargetPlatform.iOS
            ? CupertinoButton(
                child: Icon(CupertinoIcons.back,
                    color: Theme.of(context).colorScheme.primary),
                onPressed: () => Get.back(),
              )
            : IconButton(
                splashRadius: 15,
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back,
                  color: blackColor,
                ),
              ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          return SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.05,
                ),
                LoginInput(
                  height: width * 0.15,
                  width: width * 0.9,
                  obscure: false,
                  isSelected: true,
                  other: InternationalPhoneNumberInput(
                    autoFocus: true,
                    keyboardAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    hintText: 'enterphone'.tr,
                    initialValue: PhoneNumber(
                        isoCode: 'SA',
                        phoneNumber: controller.userModel.phoneNumber,
                        dialCode: '+966'),
                    inputBorder: InputBorder.none,
                    cursorColor: Colors.transparent,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.DIALOG,
                        useEmoji: true,
                        leadingPadding: 18,
                        setSelectorButtonAsPrefixIcon: true),
                    onInputChanged: (val) {
                      print('==== $val ====');
                    },
                  ),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            spreadRadius: 0.5,
                            blurRadius: 2,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      width: width * 0.85,
                      height: width * 0.14,
                      child: GetBuilder<AuthController>(
                        init: Get.find<AuthController>(),
                        builder: (build) => build.platform == TargetPlatform.iOS
                            ? CupertinoButton(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10.0),
                                child: build.loading
                                    ? CupertinoActivityIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        radius: 12,
                                      )
                                    : CustomText(
                                        text: 'login'.tr,
                                        align: TextAlign.left,
                                        size: width * 0.05,
                                      ),
                                onPressed: () {
                                  Get.to(() => const OtpController(
                                        verificationId: '',
                                      ));
                                }
                                // build.phoneLogin(context: context),
                                )
                            : ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                                child: build.loading
                                    ? CircularProgressIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      )
                                    : CustomText(
                                        text: 'login'.tr,
                                        size: width * 0.05,
                                        align: TextAlign.left,
                                      ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
