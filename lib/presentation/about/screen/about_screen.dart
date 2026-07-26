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
            ('Ø¯Ø§Ø³ØªØ§Ù† Ù…Ø­ØµÙˆÙ„', 'Privio Ø¨Ø±Ø§ÛŒ Ú©Ù…Ú© Ø¨Ù‡ Ø´Ù…Ø§ Ø³Ø§Ø®ØªÙ‡ Ø´Ø¯Ù‡ Ø§Ø³Øª ØªØ§ Ø¨Ø¯Ø§Ù†ÛŒØ¯ Ù‡Ø± Ø¨Ø±Ù†Ø§Ù…Ù‡ Ø¨Ù‡ Ú†Ù‡ Ù…Ø¬ÙˆØ²Ù‡Ø§ÛŒÛŒ Ø¯Ø³ØªØ±Ø³ÛŒ Ø¯Ø§Ø±Ø¯ Ùˆ Ø¨ØªÙˆØ§Ù†ÛŒØ¯ Ø¨Ø§ Ø®ÛŒØ§Ù„ Ø±Ø§Ø­Øªâ€ŒØªØ±ÛŒ Ø§Ø² Ú¯ÙˆØ´ÛŒ Ø®ÙˆØ¯ Ø§Ø³ØªÙØ§Ø¯Ù‡ Ú©Ù†ÛŒØ¯.'),
            ('Ú†Ø±Ø§ Ø±Ø§ÛŒÚ¯Ø§Ù† Ø§Ø³ØªØŸ', 'Ø­Ø±ÛŒÙ… Ø®ØµÙˆØµÛŒ Ùˆ Ø§Ù…Ù†ÛŒØª Ø¨Ø§ÛŒØ¯ Ø¨Ø±Ø§ÛŒ Ù‡Ù…Ù‡ Ù‚Ø§Ø¨Ù„ Ø¯Ø³ØªØ±Ø³ Ø¨Ø§Ø´Ø¯. Privio Ø±Ø§ÛŒÚ¯Ø§Ù† Ø§Ø³Øª ØªØ§ Ù‡ÛŒÚ†â€ŒÚ©Ø³ Ø¨Ø±Ø§ÛŒ Ù…Ø­Ø§ÙØ¸Øª Ø§Ø² Ø§Ø·Ù„Ø§Ø¹Ø§Øª Ø´Ø®ØµÛŒ Ø®ÙˆØ¯ Ù…Ø¬Ø¨ÙˆØ± Ø¨Ù‡ Ù¾Ø±Ø¯Ø§Ø®Øª Ù‡Ø²ÛŒÙ†Ù‡ Ù†Ø¨Ø§Ø´Ø¯.'),
            ('Ù…Ø¯ÛŒØ±ÛŒØª Ø¯Ø§Ø¯Ù‡â€ŒÙ‡Ø§', 'Ø§Ø·Ù„Ø§Ø¹Ø§Øª Ø¨Ø±Ø±Ø³ÛŒ Ù…Ø¬ÙˆØ²Ù‡Ø§ Ø±ÙˆÛŒ Ø¯Ø³ØªÚ¯Ø§Ù‡ Ø´Ù…Ø§ Ù¾Ø±Ø¯Ø§Ø²Ø´ Ù…ÛŒâ€ŒØ´ÙˆØ¯ Ùˆ Ù…Ø§ Ø¢Ù†â€ŒÙ‡Ø§ Ø±Ø§ Ø¨Ø±Ø§ÛŒ ÙØ±ÙˆØ´ØŒ ØªØ¨Ù„ÛŒØºØ§Øª ÛŒØ§ Ø±Ø¯ÛŒØ§Ø¨ÛŒ Ø´Ù…Ø§ Ø¬Ù…Ø¹â€ŒØ¢ÙˆØ±ÛŒ Ù†Ù…ÛŒâ€ŒÚ©Ù†ÛŒÙ….'),
            ('ØªÛŒÙ… Ù…Ø­ØµÙˆÙ„', 'Privio ØªÙˆØ³Ø· ØªÛŒÙ…ÛŒ Ù…Ø³ØªÙ‚Ù„ Ø³Ø§Ø®ØªÙ‡ Ø´Ø¯Ù‡ Ú©Ù‡ ØªÙ…Ø±Ú©Ø²Ø´ Ø·Ø±Ø§Ø­ÛŒ Ø§Ø¨Ø²Ø§Ø±Ù‡Ø§ÛŒ Ø³Ø§Ø¯Ù‡ Ùˆ Ø´ÙØ§Ù Ø¨Ø±Ø§ÛŒ Ø§Ù…Ù†ÛŒØª Ùˆ Ø­Ø±ÛŒÙ… Ø®ØµÙˆØµÛŒ Ú©Ø§Ø±Ø¨Ø±Ø§Ù† Ø§Ø³Øª.'),
            ('Ø³ÛŒØ§Ø³Øª Ø­Ø±ÛŒÙ… Ø®ØµÙˆØµÛŒ', 'Ù…Ø§ ÙÙ‚Ø· Ø¯Ø³ØªØ±Ø³ÛŒâ€ŒÙ‡Ø§ÛŒ Ù„Ø§Ø²Ù… Ø¨Ø±Ø§ÛŒ Ù†Ù…Ø§ÛŒØ´ ÙˆØ¶Ø¹ÛŒØª Ø§Ù¾â€ŒÙ‡Ø§ Ùˆ Ù…Ø¬ÙˆØ²Ù‡Ø§ Ø±Ø§ Ø¨Ø±Ø±Ø³ÛŒ Ù…ÛŒâ€ŒÚ©Ù†ÛŒÙ…. Ø´Ù…Ø§ Ù‡Ù…ÛŒØ´Ù‡ Ú©Ù†ØªØ±Ù„ Ø¯Ø§Ø¯Ù‡â€ŒÙ‡Ø§ Ùˆ ØªØµÙ…ÛŒÙ…â€ŒÙ‡Ø§ÛŒ Ø§Ù…Ù†ÛŒØªÛŒ Ø®ÙˆØ¯ Ø±Ø§ Ø¯Ø± Ø§Ø®ØªÛŒØ§Ø± Ø¯Ø§Ø±ÛŒØ¯.'),
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
            text: isFa ? 'Ø¯Ø±Ø¨Ø§Ø±Ù‡ Ù…Ø§' : 'About us',
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
                      ? 'Ø§Ù…Ù†ÛŒØª Ø¨Ù‡ØªØ± Ø¨Ø§ Ø´ÙØ§ÙÛŒØª Ø´Ø±ÙˆØ¹ Ù…ÛŒâ€ŒØ´ÙˆØ¯.'
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
        color: accent.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(.3)),
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

  static const _icons = [
    Icons.auto_stories_rounded,
    Icons.volunteer_activism_rounded,
    Icons.insights_rounded,
    Icons.groups_rounded,
    Icons.verified_user_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < widget.sections.length; index++) ...[
          _AboutSection(
            title: widget.sections[index].$1,
            body: widget.sections[index].$2,
            icon: _icons[index % _icons.length],
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
  final IconData icon;
  final bool isOpen;
  final VoidCallback onTap;

  const _AboutSection({
    required this.title,
    required this.body,
    required this.icon,
    required this.isOpen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final accent = isDark ? AppColor.green1 : AppColor.green3;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isDark ? AppColor.CartDark : AppColor.btnLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOpen ? accent.withOpacity(.75) :
              (isDark ? AppColor.CartDarkBorder : AppColor.borderLight),
          width: isOpen ? 1.4 : 1,
        ),
        boxShadow: isOpen
            ? [BoxShadow(color: accent.withOpacity(.12), blurRadius: 18, offset: const Offset(0, 6))]
            : const [],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: accent.withOpacity(isOpen ? .2 : .12),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(icon, color: accent, size: 23),
                    ),
                    const SizedBox(width: 13),
                    Expanded(child: Text(title, style: AppTextStyle.greenFont(context))),
                    AnimatedRotation(
                      turns: isOpen ? .5 : 0,
                      duration: const Duration(milliseconds: 220),
                      child: Icon(Icons.keyboard_arrow_down_rounded,
                          color: isDark ? Colors.white70 : AppColor.textLight, size: 27),
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOut,
                  child: isOpen
                      ? Padding(
                          padding: const EdgeInsetsDirectional.only(start: 55, top: 13, end: 4),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(body, style: AppTextStyle.trustDescription(context)),
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

