import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/core/extensions/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutIntro extends StatelessWidget {
  final String title;

  const AboutIntro({required this.title});

  @override
  Widget build(BuildContext context) {
    final accent = context.isDark ? AppColor.green1 : AppColor.green3;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: .3)),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_rounded, color: accent, size: 28),
          const SizedBox(width: 13),
          Expanded(child: Text(title, style: AppTextStyle.trustTitle(context))),
        ],
      ),
    );
  }
}
