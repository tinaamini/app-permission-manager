import 'package:flutter/material.dart';
import 'package:permissions_app/generated/app_localizations.dart';

class KeptBadge extends StatelessWidget {
  const KeptBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(right: screenWidth * 0.0625),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.025,
          vertical: screenHeight * 0.0037,
        ),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          border: Border.all(
            color: Colors.green,
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.push_pin,
              size: screenWidth * 0.03,
              color: Colors.green,
            ),
            SizedBox(width: screenWidth * 0.01),
            Text(
              l10n.kept,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.green,
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