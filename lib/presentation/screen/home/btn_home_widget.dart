import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';

class BtnHomeWidget extends StatelessWidget {
  final String image;
  final String text;
  final VoidCallback ontap;
  const BtnHomeWidget({super.key, required this.image, required this.text, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(width: 150.w,height:100.w ,
        decoration: BoxDecoration(
          color: AppColor.CartDark,
          borderRadius: BorderRadius.circular(8.w),
            border: Border.all(width: 1.w,color: AppColor.white1)
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(image,width: 150.w,height: 50.w,),
            Center(child: Text(text,style: AppTextStyle.btnHome,))
          ],
        ),
      ),
    );
  }
}
