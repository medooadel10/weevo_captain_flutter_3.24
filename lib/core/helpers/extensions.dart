import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension NavigationEx on BuildContext {
  void push(String routeName, {Object? arguments}) {
    Navigator.pushNamed(this, routeName, arguments: arguments);
  }

  void pushReplacement(String routeName, {Object? arguments}) {
    Navigator.pushReplacementNamed(this, routeName, arguments: arguments);
  }

  void pop() {
    Navigator.pop(this);
  }

  void unfocus() {
    FocusScope.of(this).unfocus();
  }
}

extension PaddingEx on Widget {
  Widget paddingAll(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }

  Widget paddingSymmetric({double vertical = 0, double horizontal = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: vertical,
        horizontal: horizontal,
      ),
      child: this,
    );
  }

  Widget paddingOnly(
      {double top = 0, double right = 0, double bottom = 0, double left = 0}) {
    return Padding(
      padding: EdgeInsets.only(
        top: top,
        right: right,
        bottom: bottom,
        left: left,
      ),
      child: this,
    );
  }

  Widget paddingFromLTRB(double left, double top, double right, double bottom) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: this,
    );
  }
}

extension ThemeEx on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}

extension MediaQueryEx on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get height => mediaQuery.size.height;

  double get width => mediaQuery.size.width;
}

extension PriceEx on String {
  String toStringAsFixed0() => num.parse(this).toStringAsFixed(0);
  int toInt() => int.parse(this);
}

extension StringEx on String {
  bool isInt() {
    return int.tryParse(this) != null;
  }

  String arabicToEnglishNumbers() {
    const arabicNumbers = '٠١٢٣٤٥٦٧٨٩';
    const englishNumbers = '0123456789';
    String input = this;
    for (int i = 0; i < arabicNumbers.length; i++) {
      input.replaceAll(arabicNumbers[i], englishNumbers[i]);
    }
    return input;
  }

  String get dateLabel {
    DateTime shipmentDate = DateTime.parse(this);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

    if (shipmentDate == today) {
      return 'اليوم';
    } else if (shipmentDate == tomorrow) {
      return 'غداً';
    } else if (shipmentDate == yesterday) {
      return 'أمس';
    } else {
      return DateFormat('dd MMM yyyy', 'ar-EG').format(shipmentDate);
    }
  }
}
