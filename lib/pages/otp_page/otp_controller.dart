import 'package:cineverse/pages/otp_page/otp_desktop.dart';
import 'package:cineverse/pages/otp_page/otp_phone.dart';
import 'package:cineverse/pages/otp_page/otp_tablet.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/cupertino.dart';

class OtpController extends StatelessWidget {
  final String verificationId;
  const OtpController({super.key, required this.verificationId});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? OtpPhone(
            verificationId: verificationId,
          )
        : width > phoneSize && width <= tabletSize
            ? const OtpTablet()
            : const OtpDesktop();
  }
}
