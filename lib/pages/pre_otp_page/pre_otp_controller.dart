import 'package:cineverse/pages/pre_otp_page/desktop_pre_otp.dart';
import 'package:cineverse/pages/pre_otp_page/phone_pre_otp.dart';
import 'package:cineverse/pages/pre_otp_page/tablet_pre_otp.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/cupertino.dart';

class PreOtpController extends StatelessWidget {
  const PreOtpController({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? const PreOtpPhone()
        : width > phoneSize && width <= tabletSize
            ? const PreOtpTablet()
            : const PreOtpDesktop();
  }
}
