import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permissions_app/routs/rout.dart';

import 'logic/app_permission/app_permission_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('session');
  runApp(MainApp(


  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {


  @override
  Widget build(BuildContext context) {
    return   MultiBlocProvider(
        providers: [
          BlocProvider<AppPermissionCubit>(
            create: (_) => AppPermissionCubit()..loadApps(),
          ),
        ],
        child:  ScreenUtilInit(
            designSize: const Size(364, 917),
            minTextAdapt: true,
            builder: (context, child) {
              return MaterialApp.router(
                routerConfig: router,
                debugShowCheckedModeBanner: false,


              );
            },
        ),

    );
  }
}

