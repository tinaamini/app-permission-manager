import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


class CustomDotsLoader extends StatefulWidget {
  final String svgPath1;
  final String svgPath2;
  final String? svgPath3;
  final String? svgPath4;
  const CustomDotsLoader({super.key, required this.svgPath1, required this.svgPath2,  this.svgPath3,  this.svgPath4});

  @override
  State<CustomDotsLoader> createState() => _SvgLoaderAnimationState();
}

class _SvgLoaderAnimationState extends State<CustomDotsLoader> {

  late List<String> svgPaths;

  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    svgPaths = [
      widget.svgPath1,
      widget.svgPath2,
      if (widget.svgPath3 != null) widget.svgPath3!,
      if (widget.svgPath4 != null) widget.svgPath4!,
    ];


    _timer = Timer.periodic(const Duration(milliseconds:200), (timer) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % svgPaths.length;
      });
    });
  }



  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svgPaths[_currentIndex],
      height: 32,
      width: 32,
      color: null,
    );
  }
}
