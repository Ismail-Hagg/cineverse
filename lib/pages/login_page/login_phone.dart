import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/login_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPhone extends StatelessWidget {
  const LoginPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.find<AuthController>().unfocusNodes(),
      child: Scaffold(
          backgroundColor: Get.theme.colorScheme.background,
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
                      height: height * 0.3,
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
                      height: 30,
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
                      height: 25,
                    ),
                    SizedBox(
                      width: width * 0.85,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary
                            // shape:
                            //     MaterialStateProperty.all<RoundedRectangleBorder>(
                            //   RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(10.0),
                            //   ),
                            // ),
                            ),
                        onPressed: () => controller.themeSwich(),
                        // controller.emailLogin(
                        //     context: context,
                        //     email: controller
                        //         .emailController.text
                        //         .trim(),
                        //     password: controller
                        //         .passWordController.text
                        //         .trim()),
                        child: controller.loading
                            ? CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.background,
                              )
                            : CustomText(
                                text: 'login'.tr,
                                size: width * 0.05,
                                color: Theme.of(context).colorScheme.background,
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Theme.of(context).colorScheme.primary,
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
                  ],
                ),
              ),
            );
          })),
    );
  }
}
