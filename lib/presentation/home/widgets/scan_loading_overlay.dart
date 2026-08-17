import 'package:Privio/constant/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScanLoadingOverlay extends StatelessWidget {
  const ScanLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              "assets/main/safe_alert.svg",
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 180,
              child: LinearProgressIndicator(
                backgroundColor: Colors.white24,
                color: AppColor.blue1,
                minHeight: 4,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}