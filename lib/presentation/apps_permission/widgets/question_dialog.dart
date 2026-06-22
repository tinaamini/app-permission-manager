import 'package:Privio/constant/app_style.dart';
import 'package:Privio/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/presentation/utils/app_size.dart';

class QuestionDialog extends StatelessWidget {
  final VoidCallback ontapManual;

  const QuestionDialog({
    super.key,
    required this.ontapManual,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: (size.width * 0.9).clamp(280.0, 520.0),
        maxHeight: (size.height * 0.6).clamp(220.0, 520.0),
      ),
      child: Container(
        padding: EdgeInsets.all(AppSize.width * 0.05),
        decoration: BoxDecoration(
          color:context.isDark?AppColor.bcGround:AppColor.white,
          borderRadius: BorderRadius.circular(AppSize.width * 0.05),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withValues(alpha: 0.6),
          //     blurRadius: AppSize.width * 0.05,
          //     offset: const Offset(0, 10),
          //   ),
          // ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.appPermission,
                textAlign: TextAlign.center,
                style: AppTextStyle.questionTitle(context)
              ),
              SizedBox(height: AppSize.height * 0.015),
              Text(
                l10n.manual,
                style: AppTextStyle.questionTitle2(context)),
              SizedBox(height: AppSize.height * 0.007),
              Text(
                l10n.youWillManuallyNavigate,
                textAlign: TextAlign.center,
                style: AppTextStyle.questionDescription(context)
              ),
              SizedBox(height: AppSize.height * 0.025),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: ontapManual,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSize.height * 0.017,
                    ),
                    decoration: BoxDecoration(
                      color:context.isDark? AppColor.CartDark:AppColor.white,
                      borderRadius: BorderRadius.circular(AppSize.width * 0.05),
                      border: Border.all(width: 1.5, color:context.isDark? AppColor.green1:AppColor.green3),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      l10n.continueBtn,
                      style: AppTextStyle.questionTitle2(context)
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