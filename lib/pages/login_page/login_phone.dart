import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/login_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LoginPhone extends StatelessWidget {
  const LoginPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.find<AuthController>().unfocusNodes(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double height = constraints.maxHeight;
            double width = constraints.maxWidth;
            return SizedBox(
              height: height,
              width: width,
              child: GetBuilder<AuthController>(
                init: Get.find<AuthController>(),
                builder: (controller) => Column(
                  children: [
                    Container(
                      alignment: FractionalOffset.bottomCenter,
                      height: height * 0.33,
                      width: width,
                      child: Image.asset(
                        'assets/images/main_logo.png',
                        scale: 1.5,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    LoginInput(
                      width: width * 0.85,
                      height: width * 0.15,
                      focusNode:
                          controller.nodes[FieldType.loginEmail] as FocusNode,
                      hintText: 'Email',
                      controller:
                          controller.txtControllers[FieldType.loginEmail]
                              as TextEditingController,
                      leadingIcon: const Icon(Icons.email),
                      obscure: false,
                      type: TextInputType.emailAddress,
                      isSelected:
                          controller.flips[FieldType.loginEmail] as bool,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    LoginInput(
                      width: width * 0.85,
                      height: width * 0.15,
                      focusNode:
                          controller.nodes[FieldType.loginPass] as FocusNode,
                      hintText: 'Password',
                      controller: controller.txtControllers[FieldType.loginPass]
                          as TextEditingController,
                      leadingIcon: const Icon(Icons.email),
                      obscure: controller.passOb,
                      type: TextInputType.text,
                      isSelected: controller.flips[FieldType.loginPass] as bool,
                      suffex: GestureDetector(
                        onTap: () => controller.passObscure(),
                        child: controller.passOb
                            ? Icon(
                                controller.platform == TargetPlatform.android
                                    ? Icons.visibility_off
                                    : CupertinoIcons.eye_slash_fill,
                                color: Theme.of(context).colorScheme.secondary)
                            : Icon(
                                controller.platform == TargetPlatform.android
                                    ? Icons.visibility
                                    : CupertinoIcons.eye_fill,
                                color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: width * 0.85,
                      child: controller.platform == TargetPlatform.android
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary),
                              onPressed: () => controller.themeSwich(),
                              child: controller.loading
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    )
                                  : CustomText(
                                      text: 'login'.tr,
                                      size: width * 0.05,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                            )
                          : CupertinoButton(
                              padding: EdgeInsets.zero,
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10.0),
                              child: controller.loading
                                  ? CupertinoActivityIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    )
                                  : CustomText(
                                      text: 'login'.tr,
                                      size: width * 0.05,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                              onPressed: () => controller.themeSwich(),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 34, horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Theme.of(context).colorScheme.secondary,
                              thickness: 2,
                              height: 9,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              'or'.tr,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Theme.of(context).colorScheme.secondary,
                              thickness: 2,
                              height: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoginInput(
                          socialLog: () {
                            print('------------ social shit--------------');
                          },
                          height: width * 0.15,
                          width: width * 0.15,
                          obscure: false,
                          isSelected: true,
                          other: FaIcon(
                            FontAwesomeIcons.envelope,
                            color: Theme.of(context).colorScheme.secondary,
                            size: width * 0.08,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.1,
                        ),
                        LoginInput(
                          socialLog: () {
                            print('------------ social shit--------------');
                          },
                          height: width * 0.15,
                          width: width * 0.15,
                          obscure: false,
                          isSelected: true,
                          other: FaIcon(
                            FontAwesomeIcons.google,
                            color: Theme.of(context).colorScheme.secondary,
                            size: width * 0.08,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.1,
                        ),
                        LoginInput(
                          socialLog: () {
                            print('------------ social shit--------------');
                          },
                          height: width * 0.15,
                          width: width * 0.15,
                          obscure: false,
                          isSelected: true,
                          other: FaIcon(
                            FontAwesomeIcons.phone,
                            color: Theme.of(context).colorScheme.secondary,
                            size: width * 0.08,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
