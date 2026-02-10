import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class MainScreen extends StatelessWidget {
  final Widget child;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MainScreen({super.key, required this.child});


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: const AssetImage('assets/main/bg.svg'),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: Stack(
            children: [
              SvgPicture.asset('assets/main/bg.svg',  fit: BoxFit.cover,),
              Positioned.fill(
                  child: Column(
                    children: [
                      Expanded(child: child),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

}
