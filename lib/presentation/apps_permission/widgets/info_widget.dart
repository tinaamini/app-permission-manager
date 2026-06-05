import 'package:flutter/material.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: (AppSize.width * 0.9).clamp(280.0, 520.0),
        maxHeight: (AppSize.height * 0.75).clamp(260.0, 700.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.width * 0.05,
          vertical: AppSize.height * 0.02,),
        decoration: BoxDecoration(
          color: AppColor.BcGround,
          borderRadius: BorderRadius.circular(AppSize.width * 0.05),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: AppSize.width * 0.05,
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
                width: AppSize.width * 0.15,
                height: AppSize.width * 0.15,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child:  Icon(
                  Icons.security_rounded,
                  color: Colors.orange,
                  size: AppSize.width * 0.085,                ),
              ),
              SizedBox(height: AppSize.height * 0.02),

              Text(
                'Security Overview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppSize.width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppSize.height * 0.01),

              Text(
                'This app’s risk level is calculated based on the permissions you have granted.\n\n'
                    'Some permissions provide powerful access to your device. While they may be required for certain features, '
                    'they can increase potential impact if misused.\n\n'
                    'A higher risk does not mean the app is malicious — it means it has greater access.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: AppSize.width * 0.03,
                  height: 1.5,
                ),
              ),

              SizedBox(height: AppSize.height * 0.025),

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

              SizedBox(height: AppSize.height * 0.02),

              Container(
                padding: EdgeInsets.all(AppSize.width * 0.035),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(AppSize.width * 0.035),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Icon(
                      Icons.lock_outline,
                      color: Colors.lightBlueAccent,
                      size: AppSize.width * 0.055,                    ),
                    SizedBox(width: AppSize.width * 0.025),
                    Expanded(
                      child: Text(
                        'You can reduce risk by disabling permissions that are not actively used. '
                            'Permissions can be changed at any time from system settings.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: AppSize.width * 0.03,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSize.height * 0.015),
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
      padding: EdgeInsets.only(
        bottom: AppSize.height * 0.012,
      ),
      child: Row(
        children: [
          Icon(icon,  color: color,
            size: AppSize.width * 0.055,
          ),
          SizedBox(
            width: AppSize.width * 0.025,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: AppSize.width * 0.032,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: AppSize.width * 0.028,
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