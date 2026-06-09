import 'package:flutter/material.dart';
import 'package:Privio/generated/app_localizations.dart';

class TrustedBadge extends StatelessWidget {
  const TrustedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(right: screenWidth * 0.05),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02,
          vertical: screenHeight * 0.0037,
        ),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          border: Border.all(
            color: Colors.blueAccent,
            width: 0.8,
          ),
        ),
        child: Row(
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
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: screenWidth * 0.025,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}