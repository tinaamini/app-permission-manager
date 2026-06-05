import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';

Widget description(String text) => Padding(
  padding: EdgeInsets.only(
    bottom: AppSize.height * 0.015,
  ),
  child: Text(
    text,
    style: TextStyle(
      color: Colors.white60,
      fontSize: AppSize.width * 0.03,
    ),
    textAlign: TextAlign.start,
    softWrap: true,
  ),
);