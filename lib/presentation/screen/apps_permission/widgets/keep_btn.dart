// import 'package:flutter/cupertino.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:permissions_app/constant/app_color.dart';
// import 'package:permissions_app/constant/app_style.dart';
//
// class KeepBtn extends StatelessWidget {
//
//
//   final VoidCallback ontap;
//   const KeepBtn({super.key,required this.ontap});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:  EdgeInsets.only(left: 20.w),
//       child: GestureDetector(
//         onTap: ontap,
//         child: Container(width: 100.w,height:50.w ,
//           decoration: BoxDecoration(
//               color: AppColor.bntKeepY,
//               borderRadius: BorderRadius.circular(8.w),
//               border: Border.all(width: 1.w,color: AppColor.white1)
//           ),
//           child: Column(crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Image.asset("assets/app_permission/keep.png",width: 50.w,height: 30.w,),
//               Center(child: Text("Keep app",style: AppTextStyle.keepbtn,))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';

class KeepAppButton extends StatelessWidget {
  final bool isKept;
  final VoidCallback onTap;

  const KeepAppButton({
    super.key,
    required this.isKept,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isKept
              ? Colors.green.withOpacity(0.15)
              : AppColor.CartDark,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isKept ? Colors.green : Colors.white12,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isKept ? Icons.verified_rounded : Icons.push_pin_outlined,
              color: isKept ? Colors.green : Colors.white70,
              size: 22,
            ),
            SizedBox(width: 10.w),
            Text(
              isKept ? 'App is Kept' : 'Keep App',
              style: TextStyle(
                color: isKept ? Colors.green : Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
