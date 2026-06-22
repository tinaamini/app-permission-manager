import 'package:Privio/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/core/servises/usage_access_service.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/presentation/utils/app_size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UsageAccessScreen extends StatefulWidget {
  const UsageAccessScreen({super.key});

  @override
  State<UsageAccessScreen> createState() => _UsageAccessScreenState();
}

class _UsageAccessScreenState extends State<UsageAccessScreen>
    with WidgetsBindingObserver {
  bool _openedSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) return;
    if (!_openedSettings) return;

    final granted = await UsageAccessService.isUsageAccessGranted();
    if (!mounted) return;

    if (granted) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n=AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(   AppSize.width * 0.05,),
      decoration: BoxDecoration(
        color: context.isDark ?AppColor.bcGround:AppColor.btnLight2,
        borderRadius: BorderRadius.circular(   AppSize.width * 0.05,),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSize.width*0.15,
            height: AppSize.height * 0.15,
            decoration: BoxDecoration(
              color:context.isDark? AppColor.CartDark:AppColor.white,
              shape: BoxShape.circle,
                border: Border.all(color: Colors.white12, width: 1.2),
                boxShadow: [
            BoxShadow(
            color: Colors.blue.withValues(alpha: 0.35),
        blurRadius: AppSize.width * 0.04,
        offset: const Offset(0, 0),
      ),]
            ),

            child: const Icon(
              Icons.data_usage,
              color: Colors.blue,
              size: 34,
            ),
          ),

          Text(
            l10n.enableUsageAccessMessage,
            textAlign: TextAlign.center,
            style: AppTextStyle.usage(context)
          ),

          SizedBox(height: AppSize.height * 0.03),

          GestureDetector(
            onTap: () async {
              _openedSettings = true;
              await UsageAccessService.openUsageAccessSettings();
            },
            child: Container(
              width: AppSize.width * 0.5,
              height: AppSize.height * 0.06,
              decoration: BoxDecoration(
                color: context.isDark? AppColor.CartDark:AppColor.white,
                borderRadius: BorderRadius.circular(                  AppSize.width * 0.04,
                ),
                border: Border.all(color: Colors.white12, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.35),
                    blurRadius: AppSize.width * 0.03,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    l10n.openUsageAccessSettings,
                    style: AppTextStyle.btnUsage(context),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}