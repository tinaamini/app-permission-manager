import 'package:flutter/material.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review your app permissions',
          style: TextStyle(
            fontSize: AppSize.width * 0.05,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),

        SizedBox(height: AppSize.height * 0.008),

        Text(
          'Understand your permissions. Stay in control.',
          style: TextStyle(
            fontSize: AppSize.width * 0.033,
            color: Colors.white70,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}