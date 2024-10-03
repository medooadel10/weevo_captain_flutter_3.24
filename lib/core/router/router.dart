import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Storage/shared_preference.dart';

class MagicRouter {
  static BuildContext currentContext = navigator.currentContext!;

  static Future<dynamic> navigateTo(Widget page) =>
      navigator.currentState!.push(_materialPageRoute(page));

  static Future<dynamic> navigateAndPopAll(Widget page) =>
      navigator.currentState!.pushAndRemoveUntil(
        _materialPageRoute(page),
        (_) => false,
      );

  static Future<dynamic> navigateAndPopUntilFirstPage(Widget page) => navigator
      .currentState!
      .pushAndRemoveUntil(_materialPageRoute(page), (route) => route.isFirst);

  static Future<dynamic> navigateAndPop(Widget page) =>
      navigator.currentState!.pushReplacement(_materialPageRoute(page));

  static bool get canPop => navigator.currentState!.canPop();

  static void pop({Object? data}) {
    navigator.currentState!.pop(data);
  }

  static Route<dynamic> _materialPageRoute(Widget page) => Platform.isIOS
      ? CupertinoPageRoute(builder: (_) => page)
      : MaterialPageRoute(builder: (_) => page);
}
