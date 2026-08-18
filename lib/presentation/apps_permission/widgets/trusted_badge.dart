import 'package:Privio/constant/app_style.dart';
import 'package:flutter/material.dart';
import 'package:Privio/generated/app_localizations.dart';

class TrustedBadge extends StatelessWidget {
  const TrustedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final l10n = AppLocalizations.of(context)!;

    return Container(

      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(screenWidth * 0.01),
        border: Border.all(
          color: Colors.blueAccent,
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.verified_rounded,
              size: screenWidth * 0.03,
              color: Colors.blueAccent,
            ),
            SizedBox(width: screenWidth * 0.01),
            Text(
              l10n.trusted,
           style: AppTextStyle.lastScan(context).copyWith(color: Colors.blueAccent,)

            ),
          ],
        ),
      ),
    );
  }
}