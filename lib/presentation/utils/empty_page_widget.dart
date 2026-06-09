import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/presentation/utils/app_size.dart';

class EmptyPageWidget extends StatelessWidget {
  final String text;

  const EmptyPageWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.width * 0.03,
          vertical: AppSize.height * 0.012,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              "assets/utils/emoji-sad.svg",
              width: AppSize.width * 0.25,
              height: AppSize.width * 0.25,
            ),
            SizedBox(height: AppSize.height * 0.022),
            Text(
              text,
              style: AppTextStyle.emptyPage(context),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}