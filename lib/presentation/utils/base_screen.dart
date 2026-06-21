import 'package:Privio/logic/utils/theme/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_size.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;

  const BaseScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(
          image: DecorationImage(
            image: isDark ?AssetImage('assets/main/bg.png'): AssetImage('assets/main/bgLight.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: child,
        ),
      ),
    );
  }
}
