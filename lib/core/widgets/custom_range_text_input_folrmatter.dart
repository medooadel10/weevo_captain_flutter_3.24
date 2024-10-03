import 'package:flutter/services.dart';

class CustomRangeTextInputFormatter extends TextInputFormatter {
  final double max;

  CustomRangeTextInputFormatter(this.max);
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') {
      return const TextEditingValue();
    } else if (int.parse(newValue.text) < max) {
      return const TextEditingValue().copyWith(text: max.toString());
    }
    return newValue;
  }
}
