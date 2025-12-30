import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';

import 'action_item.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColor.BcGround,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Header icon
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 32,
            ),
          ),

          SizedBox(height: 14.h),

          Text(
            'Security Actions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 6.h),

          Text(
            'Choose an action for this application',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 12.sp,
            ),
          ),

          SizedBox(height: 20.h),

          ActionItem(
            icon: Icons.settings_suggest_outlined,
            title: 'Apply Changes',
            subtitle: 'Open permission settings',
            color: Colors.orange,
            onTap: () {
              Navigator.pop(context);
              // TODO: open app permission settings
            },
          ),

          ActionItem(
            icon: Icons.stop_circle_outlined,
            title: 'Force Stop',
            subtitle: 'Stop the app immediately',
            color: Colors.red,
            onTap: () {
              Navigator.pop(context);
              // TODO: force stop via settings
            },
          ),

          ActionItem(
            icon: Icons.delete_outline,
            title: 'Uninstall',
            subtitle: 'Remove app from device',
            color: Colors.redAccent,
            onTap: () {
              Navigator.pop(context);
              // TODO: uninstall app
            },
          ),

          ActionItem(
            icon: Icons.push_pin_outlined,
            title: 'Keep App',
            subtitle: 'Add to safe list',
            color: Colors.green,
            onTap: () {
              Navigator.pop(context);
              // TODO: save to keep list
            },
          ),
        ],
      ),
    );
  }
}
