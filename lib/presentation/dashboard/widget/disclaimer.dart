import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Disclaimer extends StatelessWidget {
  const Disclaimer();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'This dashboard shows current permission settings and highlights '
          'potentially sensitive configurations. It does not track or display '
          'how often permissions are used.',
      style: TextStyle(
        fontSize: 12,
        color: Colors.white38,
      ),
      textAlign: TextAlign.center,
    );
  }
}
