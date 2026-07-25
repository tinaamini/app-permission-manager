import 'package:Privio/constant/app_color.dart';
import 'package:Privio/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Search field used above app lists throughout the app.
class AppSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const AppSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isFa = Localizations.localeOf(context).languageCode == 'fa';
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 8),
      child: TextField(
        onChanged: onChanged,
        textDirection: isFa ? TextDirection.rtl : TextDirection.ltr,
        style: TextStyle(color: isDark ? Colors.white : AppColor.black),
        decoration: InputDecoration(
          hintText: isFa ? 'جستجوی اپ‌ها...' : 'Search apps...',
          hintStyle: TextStyle(
            color: isDark ? Colors.white54 : AppColor.textLight,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              'assets/utils/search_green_icon.svg',
              width: 24,
              height: 24,
            ),
          ),
          filled: true,
          fillColor: isDark ? const Color(0xFF171717) : AppColor.btnLight2,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(
              color: isDark ? Colors.white12 : AppColor.borderLight,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: AppColor.green1),
          ),
        ),
      ),
    );
  }
}
