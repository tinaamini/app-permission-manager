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
            ('داستان محصول', 'Privio برای کمک به شما ساخته شده است تا بدانید هر برنامه به چه مجوزهایی دسترسی دارد و بتوانید با خیال راحت‌تری از گوشی خود استفاده کنید.'),
            ('چرا رایگان است؟', 'حریم خصوصی و امنیت باید برای همه قابل دسترس باشد. Privio رایگان است تا هیچ‌کس برای محافظت از اطلاعات شخصی خود مجبور به پرداخت هزینه نباشد.'),
            ('مدیریت داده‌ها', 'اطلاعات بررسی مجوزها روی دستگاه شما پردازش می‌شود و ما آن‌ها را برای فروش، تبلیغات یا ردیابی شما جمع‌آوری نمی‌کنیم.'),
            ('تیم محصول', 'Privio توسط تیمی مستقل ساخته شده که تمرکزش طراحی ابزارهای ساده و شفاف برای امنیت و حریم خصوصی کاربران است.'),
            ('سیاست حریم خصوصی', 'ما فقط دسترسی‌های لازم برای نمایش وضعیت اپ‌ها و مجوزها را بررسی می‌کنیم. شما همیشه کنترل داده‌ها و تصمیم‌های امنیتی خود را در اختیار دارید.'),
          ]
        : const [
            ('Our story', 'Privio helps you understand what permissions each app uses, so you can use your phone with more confidence.'),
            ('Why is it free?', 'Privacy and security should be accessible to everyone. Privio is free so protecting personal information never depends on a subscription.'),
            ('How we handle data', 'Permission analysis is processed on your device. We do not collect your data for sale, advertising, or tracking.'),
            ('The team', 'Privio is built by an independent team focused on creating simple and transparent privacy and security tools.'),
            ('Privacy policy', 'We only inspect the access needed to show app and permission status. You remain in control of your data and security decisions.'),
          ];

    return BaseScreen(
      child: Column(
        children: [
          AppBarWidget(
            text: isFa ? 'درباره ما' : 'About us',
            ontap: () => context.pop(),
            showBack: true,
            showHome: true,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              children: [
                _AboutSection(
                  title: isFa
                      ? 'امنیت بهتر با شفافیت شروع می‌شود.'
                      : 'Better security starts with transparency.',
                  body: '',
                  highlight: true,
                ),
                const SizedBox(height: 16),
                ...sections.map(
                  (section) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _AboutSection(title: section.$1, body: section.$2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  final String title;
  final String body;
  final bool highlight;

  const _AboutSection({
    required this.title,
    required this.body,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.isDark ? AppColor.CartDark : AppColor.btnLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.isDark ? AppColor.CartDarkBorder : AppColor.borderLight,
        ),
      ),
      child: highlight
          ? Text(
              title,
              style: AppTextStyle.trustTitle(context),
              textAlign: TextAlign.center,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyle.greenFont(context)),
                const SizedBox(height: 8),
                Text(body, style: AppTextStyle.trustDescription(context)),
              ],
            ),
    );
  }
}
