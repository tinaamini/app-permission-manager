import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  final String title;
  final String body;
  final Color accent;
  final bool isOpen;
  final VoidCallback onTap;

  const AboutSection({
    required this.title,
    required this.body,
    required this.accent,
    required this.isOpen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final cardColor = isDark ? AppColor.aboutCardOverlay : AppColor.btnLight;
    final radius = BorderRadius.circular(24);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: radius,
        border: Border.all(
          color: isOpen
              ? accent
              : (isDark ? AppColor.CartDarkBorder : AppColor.borderLight),
          width: isOpen ? 1.5 : 1,
        ),
        boxShadow: isOpen
            ? [
          BoxShadow(
            color: accent.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ]
            : const [],
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
            child: Column(
              children: [
                SizedBox(
                  height: 34,
                  child: Row(
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        color: accent,
                        size: 25,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyle.greenFont(context).copyWith(
                            color: isOpen
                                ? accent
                                : (isDark ? AppColor.white : AppColor.black),
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: isOpen ? .5 : 0,
                        duration: const Duration(milliseconds: 220),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: isDark ? AppColor.white : AppColor.black,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOut,
                  child: isOpen
                      ? Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      body,
                      style:
                      AppTextStyle.trustDescription(context).copyWith(
                        color: isDark ? AppColor.white : AppColor.black,
                        fontSize: 14,
                        height: 1.65,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
