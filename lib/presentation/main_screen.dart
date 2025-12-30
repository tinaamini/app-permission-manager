
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';

class MainScreen extends StatelessWidget {
  final Widget child;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MainScreen({super.key, required this.child});

  // int _getIndexFromLocation(String location) {
  //   if (location == '/' || location.startsWith('/home')) return 0;
  //   // if (location.startsWith('/enhance')) return 1;
  //   // if (location.startsWith('/style')) return 2;
  //   // if (location.startsWith('/user')) return 3;
  //   return -1;
  // }

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(context).routeInformationProvider.value.uri;


    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/main/13045dfa-7f40-4f81-98ac-8d4d00b0a8da-md.jpeg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.darken,
              ),
            ),
          ),
          child: Stack(
            children: [
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
