import 'package:flutter/material.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';

class QuestionDialog extends StatelessWidget {
  final VoidCallback ontapManual;

  const QuestionDialog({
    super.key,
    required this.ontapManual,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: (size.width * 0.9).clamp(280.0, 520.0),
        maxHeight: (size.height * 0.6).clamp(220.0, 520.0),
      ),
      child: Container(
        padding: EdgeInsets.all(
          AppSize.width * 0.05,
        ),
        decoration: BoxDecoration(
          color: AppColor.BcGround,
          borderRadius: BorderRadius.circular(
            AppSize.width * 0.05,
          ),
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
              Text(
                "APP PERMISSION",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppSize.width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppSize.height * 0.015),
              Text(
                "Manual",
                style: TextStyle(
                  color: AppColor.green1,
                  fontSize: AppSize.width * 0.035,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: AppSize.height * 0.007,
              ),
              Text(
                "You will manually navigate through the system settings to manage app permissions.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.green2,
                  fontSize: AppSize.width * 0.03,
                ),
              ),
              SizedBox(
                height: AppSize.height * 0.025,
              ),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: ontapManual,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSize.height * 0.017,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.CartDark,
                      borderRadius: BorderRadius.circular(
                        AppSize.width * 0.05,
                      ),
                      border: Border.all(width: 1, color: AppColor.green1),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        color: AppColor.green1,
                        fontSize: AppSize.width * 0.035,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
