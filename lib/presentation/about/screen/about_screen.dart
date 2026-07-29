import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/core/extensions/context_extension.dart';
import 'package:Privio/presentation/utils/app_bar.dart';
import 'package:Privio/presentation/utils/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isFa = Localizations.localeOf(context).languageCode == 'fa';
    final sections = isFa
        ? const [
            (
              'معرفی برنامه',
              'Privio به شما کمک می‌کند تا مجوزهای برنامه‌های نصب‌شده روی دستگاه خود را به‌سادگی بررسی کنید و با آگاهی بیشتری درباره امنیت و حریم خصوصی خود تصمیم بگیرید.',
            ),
            (
              'چرا رایگان است؟',
              'ما باور داریم امنیت و حریم خصوصی باید برای همه در دسترس باشد؛ به همین دلیل تمام قابلیت‌های فعلی Privio به‌صورت رایگان ارائه می‌شوند.',
            ),
            (
              'حریم خصوصی و داده‌ها',
              'حریم خصوصی شما برای ما اهمیت دارد. تمامی بررسی‌ها و پردازش‌ها فقط روی دستگاه شما انجام می‌شود و هیچ اطلاعاتی به سرورهای ما ارسال یا ذخیره نمی‌شود.',
            ),
            (
              'درباره MicroDev',
              'ما روی ساخت ابزارهای ساده، کاربردی و قابل اعتماد کار می‌کنیم؛ ابزارهایی که انجام کارهای روزمره را آسان‌تر می‌کنند و تجربه بهتری برای کاربران می‌سازند.',
            ),
            (
              'دسترسی‌های موردنیاز',
              'Privio فقط از مجوزهای لازم برای بررسی و نمایش وضعیت دسترسی برنامه‌ها استفاده می‌کند. کنترل اطلاعات و تصمیم‌گیری درباره حریم خصوصی، همیشه در اختیار شماست.',
            ),
          ]
        : const [
            (
              'About the app',
              'Privio helps you easily review the permissions used by apps installed on your device, so you can make more informed decisions about your security and privacy.',
            ),
            (
              'Why is it free?',
              'We believe security and privacy should be accessible to everyone. That is why all current Privio features are provided completely free of charge.',
            ),
            (
              'Privacy and data',
              'Your privacy matters to us. All checks and processing happen on your device. No information is sent to or stored on our servers.',
            ),
            (
              'About MicroDev',
              'We build simple, useful, and trustworthy tools that make everyday tasks easier and create a better experience for users.',
            ),
            (
              'Required access',
              'Privio only uses the permissions needed to inspect and display app access status. You always remain in control of your information and privacy decisions.',
            ),
          ];

    return BaseScreen(
      child: Column(
        children: [
          AppBarWidget(
            text: isFa ? 'درباره Privio' : 'About Privio',
            ontap: () => context.pop(),
            showBack: true,
            showHome: true,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              children: [
                _AboutIntro(
                  title: isFa
                      ? 'امنیت بهتر با شفافیت آغاز می‌شود.'
                      : 'Better security starts with transparency.',
                ),
                const SizedBox(height: 16),
                _AboutSections(sections: sections),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutIntro extends StatelessWidget {
  final String title;

  const _AboutIntro({required this.title});

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

class _AboutSections extends StatefulWidget {
  final List<(String, String)> sections;

  const _AboutSections({required this.sections});

  @override
  State<_AboutSections> createState() => _AboutSectionsState();
}

class _AboutSectionsState extends State<_AboutSections> {
  int? _openIndex;

  static const _accents = [
    AppColor.aboutAccentGreen,
    AppColor.aboutAccentBlue,
    AppColor.aboutAccentOrange,
    AppColor.aboutAccentPurple,
    AppColor.aboutAccentPink,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < widget.sections.length; index++) ...[
          _AboutSection(
            title: widget.sections[index].$1,
            body: widget.sections[index].$2,
            accent: _accents[index % _accents.length],
            isOpen: _openIndex == index,
            onTap: () => setState(
              () => _openIndex = _openIndex == index ? null : index,
            ),
          ),
          if (index != widget.sections.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  final String title;
  final String body;
  final Color accent;
  final bool isOpen;
  final VoidCallback onTap;

  const _AboutSection({
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
