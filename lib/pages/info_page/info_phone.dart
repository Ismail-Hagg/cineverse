import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cineverse/widgets/avatar_widget.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/login_input.dart';
import 'package:cineverse/widgets/square_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class InfoPhone extends StatelessWidget {
  const InfoPhone({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find<AuthController>();
    return GestureDetector(
      onTap: () => controller.unfocusNodes(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double width = constraints.maxWidth;

            return SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: GetBuilder<AuthController>(
                  init: Get.find<AuthController>(),
                  builder: (control) => Column(
                    children: [
                      Row(
                        children: [
                          SquareButton(
                            function: () => controller.infoBack(),
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
                      Stack(children: [
                        GestureDetector(
                          onTap: () => control.themeSwich(),
                          child: Avatar(
                            height: width * 0.35,
                            width: width * 0.35,
                            isBorder: true,
                            type: control.userModel.avatarType as AvatarType,
                            boxFit: BoxFit.cover,
                            shadow:
                                control.userModel.avatarType == AvatarType.none
                                    ? false
                                    : true,
                            link:
                                control.userModel.avatarType == AvatarType.local
                                    ? control.userModel.localPicPath
                                    : control.userModel.avatarType ==
                                            AvatarType.online
                                        ? control.userModel.onlinePicPath
                                        : '',
                            borderColor: Theme.of(context).colorScheme.primary,
                            isIos: controller.platform == TargetPlatform.iOS,
                            iconAndroid: FontAwesomeIcons.user,
                            iconIos: CupertinoIcons.person,
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            iconColor: Theme.of(context).colorScheme.primary,
                            iconSize: width * 0.1,
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 7,
                          child: GestureDetector(
                            onTap: () =>
                                control.userModel.avatarType == AvatarType.none
                                    ? control.selectPic(save: false)
                                    : control.deletePic(save: false),
                            child: Avatar(
                              isIos: control.platform == TargetPlatform.iOS,
                              iconAndroid: control.userModel.avatarType ==
                                      AvatarType.none
                                  ? FontAwesomeIcons.plus
                                  : FontAwesomeIcons.trashCan,
                              iconIos: control.userModel.avatarType ==
                                      AvatarType.none
                                  ? FontAwesomeIcons.plus
                                  : FontAwesomeIcons.trashCan,
                              iconColor:
                                  Theme.of(context).colorScheme.background,
                              iconSize: 16,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              height: width * 0.07,
                              width: width * 0.07,
                              isBorder: true,
                              type: AvatarType.none,
                              boxFit: BoxFit.cover,
                              shadow: false,
                              borderColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        )
                      ]),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: LoginInput(
                          action: TextInputAction.next,
                          width: width,
                          height: width * 0.15,
                          focusNode: controller.nodes[FieldType.signupUser]
                              as FocusNode,
                          hintText: 'username'.tr,
                          controller:
                              controller.txtControllers[FieldType.signupUser]
                                  as TextEditingController,
                          leadingIcon: const Icon(FontAwesomeIcons.user),
                          obscure: false,
                          type: TextInputType.text,
                          isSelected:
                              controller.flips[FieldType.signupUser] as bool,
                        ),
                      ),
                      if (control.userModel.method != LoginMethod.phone) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: LoginInput(
                            action: TextInputAction.next,
                            width: width,
                            height: width * 0.15,
                            focusNode: controller.nodes[FieldType.signupEmail]
                                as FocusNode,
                            hintText: 'email'.tr,
                            controller:
                                controller.txtControllers[FieldType.signupEmail]
                                    as TextEditingController,
                            leadingIcon: const Icon(FontAwesomeIcons.envelope),
                            obscure: false,
                            type: TextInputType.emailAddress,
                            isSelected:
                                controller.flips[FieldType.signupEmail] as bool,
                          ),
                        ),
                      ],
                      if (control.userModel.method == LoginMethod.email) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: LoginInput(
                            action: TextInputAction.next,
                            width: width,
                            height: width * 0.15,
                            focusNode: controller.nodes[FieldType.signupPass]
                                as FocusNode,
                            hintText: 'password'.tr,
                            controller:
                                controller.txtControllers[FieldType.signupPass]
                                    as TextEditingController,
                            leadingIcon: const Icon(FontAwesomeIcons.lock),
                            obscure: false,
                            type: TextInputType.emailAddress,
                            isSelected:
                                controller.flips[FieldType.signupPass] as bool,
                          ),
                        )
                      ],
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: LoginInput(
                          suffex: control.txtControllers[FieldType.signupBirth]!
                                      .text !=
                                  ''
                              ? control.platform != TargetPlatform.iOS
                                  ? IconButton(
                                      splashRadius: 15,
                                      onPressed: () => control.setBirth(
                                          birth: DateTime.now(), clear: true),
                                      icon: const Icon(FontAwesomeIcons.xmark))
                                  : CupertinoButton(
                                      child: const Icon(FontAwesomeIcons.xmark),
                                      onPressed: () => control.setBirth(
                                          birth: DateTime.now(), clear: true))
                              : null,
                          onTap: () => control.datePicker(
                            iosDate: Container(
                              color: Theme.of(context).colorScheme.background,
                              height: width * 0.9,
                              child: CupertinoDatePicker(
                                initialDateTime: DateTime.now(),
                                onDateTimeChanged: (dateTime) => control
                                    .setBirth(birth: dateTime, clear: false),
                                mode: CupertinoDatePickerMode.date,
                              ),
                            ),
                            context: context,
                          ),
                          readOnly: true,
                          width: width,
                          height: width * 0.15,
                          focusNode: controller.nodes[FieldType.signupBirth]
                              as FocusNode,
                          hintText: 'birth'.tr,
                          controller:
                              controller.txtControllers[FieldType.signupBirth]
                                  as TextEditingController,
                          leadingIcon: const Icon(FontAwesomeIcons.calendar),
                          obscure: false,
                          isSelected:
                              controller.flips[FieldType.signupBirth] as bool,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: LoginInput(
                          width: width,
                          height: width * 0.15,
                          hintNoLable: 'gender'.tr,
                          leadingIcon: const Icon(FontAwesomeIcons.user),
                          obscure: false,
                          isSelected: false,
                          readOnly: true,
                          suffex: SizedBox(
                            width: width * 0.6,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.02),
                                  child: GestureDetector(
                                    onTap: () =>
                                        control.setGender(gender: Gender.male),
                                    child: Chip(
                                      backgroundColor:
                                          control.userModel.gender ==
                                                  Gender.male
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                      shadowColor:
                                          Theme.of(context).colorScheme.shadow,
                                      elevation: control.userModel.gender ==
                                              Gender.male
                                          ? 5
                                          : 0,
                                      side: BorderSide(
                                          color: control.userModel.gender ==
                                                  Gender.male
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                      padding: const EdgeInsets.all(12.0),
                                      label: CustomText(
                                          text: 'male'.tr,
                                          color: control.userModel.gender ==
                                                  Gender.male
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .background
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.02),
                                  child: GestureDetector(
                                    onTap: () => control.setGender(
                                        gender: Gender.female),
                                    child: Chip(
                                      backgroundColor:
                                          control.userModel.gender ==
                                                  Gender.female
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                      shadowColor:
                                          Theme.of(context).colorScheme.shadow,
                                      elevation: control.userModel.gender ==
                                              Gender.female
                                          ? 5
                                          : 0,
                                      side: BorderSide(
                                          color: control.userModel.gender ==
                                                  Gender.female
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                      padding: const EdgeInsets.all(12.0),
                                      label: CustomText(
                                          text: 'female'.tr,
                                          color: control.userModel.gender ==
                                                  Gender.female
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .background
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 18),
                        child: SizedBox(
                          width: width,
                          child: control.platform == TargetPlatform.android
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  onPressed: () =>
                                      control.afterInfo(context: context),
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
                                          text: 'signup'.tr,
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
                                  child: control.loading
                                      ? CupertinoActivityIndicator(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                        )
                                      : CustomText(
                                          text: 'signup'.tr,
                                          size: width * 0.05,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                        ),
                                  onPressed: () =>
                                      control.afterInfo(context: context),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
