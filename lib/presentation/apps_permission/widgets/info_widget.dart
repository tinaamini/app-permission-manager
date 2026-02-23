import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: (size.width * 0.9).clamp(280.0, 520.0),
        maxHeight: (size.height * 0.75).clamp(260.0, 700.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Icon
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.security_rounded,
                  color: Colors.orange,
                  size: 34,
                ),
              ),
              SizedBox(height: 14.h),

              Text(
                'Security Overview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),

              Text(
                'This app’s risk level is calculated based on the permissions you have granted.\n\n'
                    'Some permissions provide powerful access to your device. While they may be required for certain features, '
                    'they can increase potential impact if misused.\n\n'
                    'A higher risk does not mean the app is malicious — it means it has greater access.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                  height: 1.5,
                ),
              ),

              SizedBox(height: 20.h),

              _RiskLevelItem(
                icon: Icons.check_circle_outline,
                title: 'Low Risk',
                description: 'Limited permissions with minimal impact',
                color: Colors.green,
              ),
              _RiskLevelItem(
                icon: Icons.remove_circle_outline,
                title: 'Medium Risk',
                description: 'Sensitive permissions required for core features',
                color: Colors.orange,
              ),
              _RiskLevelItem(
                icon: Icons.warning_amber_rounded,
                title: 'High Risk',
                description:
                'Permissions that are unusual or unnecessary for this type of app',
                color: Colors.redAccent,
              ),

              SizedBox(height: 18.h),

              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      color: Colors.lightBlueAccent,
                      size: 22,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        'You can reduce risk by disabling permissions that are not actively used. '
                            'Permissions can be changed at any time from system settings.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12.sp,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _RiskLevelItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _RiskLevelItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}