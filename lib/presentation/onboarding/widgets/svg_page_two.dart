import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgPageTwo extends StatelessWidget {
  const SvgPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;


    return  Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _widgetContainer(context,color: AppColor.blue1, svg: 'assets/utils/elements.svg', text: l10n.photos),

          SvgPicture.asset(isDark ? 'assets/utils/Group 34 (4).svg': 'assets/utils/Group 34 (6).svg'),

          _widgetContainer(context,color: AppColor.green1, svg: 'assets/utils/comment-01.svg', text: l10n.permSmss),

        ]
      ),
    );
  }

  Widget _widgetContainer (

      BuildContext context,
  {
    required Color color,
    required String svg,
    required String text,
}
      ){
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    return Container(
      width: 100.w,
      height: 160.h,
      decoration: BoxDecoration(
        border: Border.all(width: 2.w, color: color),
      borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(svg),
         SizedBox(height: 10.h,),
         Text(
            text,
            style: AppTextStyle.nameApp(context)
                .copyWith(color: isDark ? AppColor.white : AppColor.black),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      
    );
}
}
