import 'package:flutter/material.dart';

import 'about_sections_state.dart';

class AboutSections extends StatefulWidget {
  final List<(String, String)> sections;

  const AboutSections({required this.sections});

  @override
  State<AboutSections> createState() => AboutSectionsState();
}
