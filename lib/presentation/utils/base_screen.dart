import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;

  const BaseScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/main/bg.png'),
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
