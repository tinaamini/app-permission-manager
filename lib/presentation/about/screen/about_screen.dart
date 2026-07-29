import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/core/extensions/context_extension.dart';
import 'package:Privio/presentation/about/widgets/about_intro.dart';
import 'package:Privio/presentation/about/widgets/about_sections.dart';
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
                AboutIntro(
                  title: isFa
                      ? 'امنیت بهتر با شفافیت آغاز می‌شود.'
                      : 'Better security starts with transparency.',
                ),
                const SizedBox(height: 16),
                AboutSections(sections: sections),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




