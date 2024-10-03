import 'package:flutter/material.dart';

class OTPInput extends StatelessWidget {
  final FocusNode? node;
  final Function(String?) onSaved;
  final Function(String?) onChange;
  final bool? autoFocus;

  const OTPInput({
    super.key,
    this.node,
    required this.onSaved,
    required this.onChange,
    this.autoFocus,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: TextFormField(
        autofocus: autoFocus ?? false,
        onSaved: onSaved,
        onChanged: onChange,
        focusNode: node,
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              18,
            ),
          ),
        ),
      ),
    );
  }
}
