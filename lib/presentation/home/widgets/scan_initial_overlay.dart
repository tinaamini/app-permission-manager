import 'package:Privio/constant/app_style.dart';
import 'package:Privio/core/extensions/context_extension.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/logic/utils/scan/scan_cubit.dart';
import 'package:Privio/logic/utils/scan/scan_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constant/app_color.dart';

class ScanInitialOverlay extends StatelessWidget {
  const ScanInitialOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark= context.isDark;

    return  BlocBuilder<ScanCubit, ScanState>(
        builder: (context, state) {
        return GestureDetector(
          onTap:() => context.read<ScanCubit>().runScan() ,
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/main/Frame 31 (1).svg"),
                SizedBox(height: 20.h,),
                Text(l10n.startScan,      textAlign: TextAlign.center,
                  maxLines: 2,
                  style: AppTextStyle.onboardingDescription(context).copyWith(
                    color: isDark ? AppColor.white : AppColor.black,
                  ),)

              ],
            ),
          ),
        );
      }
    );
  }
}
