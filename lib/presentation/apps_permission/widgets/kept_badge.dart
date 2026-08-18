import 'package:Privio/constant/app_style.dart';
import 'package:flutter/material.dart';
import 'package:Privio/generated/app_localizations.dart';

class KeptBadge extends StatelessWidget {
  const KeptBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context)!;

    return Container(

      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(screenWidth * 0.01),
        border: Border.all(
          color: Colors.green,
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite,
              size: screenWidth * 0.04,
              color: Colors.green,
            ),
            SizedBox(width: screenWidth * 0.01),
            Text(
              l10n.kept,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.lastScan(context).copyWith(color: Colors.green,
              )
            ),
          ],
        ),
      ),
    );
  }
}