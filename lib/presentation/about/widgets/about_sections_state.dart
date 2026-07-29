import 'package:Privio/constant/app_color.dart';
import 'package:Privio/presentation/about/widgets/about_section.dart';
import 'package:Privio/presentation/about/widgets/about_sections.dart';
import 'package:flutter/material.dart';

class AboutSectionsState extends State<AboutSections> {
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
          AboutSection(
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
