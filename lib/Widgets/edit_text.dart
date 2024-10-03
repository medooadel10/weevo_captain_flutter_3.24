import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utilits/colors.dart';

class EditText extends StatefulWidget {
  final String? Function(String?)? validator;
  final bool? readOnly;
  final Function(String?)? onSave;
  final Function()? onTap;
  final bool? enabled;
  final BorderSide? borderSide;
  final Function(String?)? onChange;
  final String? labelText;
  final String? hintText;
  final FocusNode? focusNode;
  final bool? isFocus;
  final bool? isPassword;
  final TextInputType? type;
  final bool? isPhoneNumber;
  final Function(String?)? onFieldSubmit;
  final TextInputAction? action;
  final bool? shouldDisappear;
  final TextAlign? align;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final double? labelFontSize;
  final double? hintFontSize;
  final int? maxLength;
  final Color? labelColor;
  final Color? hintColor;
  final double? radius;
  final bool? upperTitle;
  final Color? fillColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool? filled;
  final TextEditingController? controller;
  final int? maxLines;
  final int? minLines;
  final List<String>? autofillHints;

  const EditText({
    super.key,
    this.validator,
    this.readOnly = false,
    this.onSave,
    this.onChange,
    this.borderSide,
    this.autofillHints,
    this.labelText,
    this.hintText,
    this.enabled = true,
    this.inputFormatters,
    this.onTap,
    this.maxLength,
    this.isFocus = false,
    this.focusNode,
    this.isPassword = false,
    this.isPhoneNumber = false,
    this.shouldDisappear = false,
    this.upperTitle = false,
    this.labelFontSize,
    this.labelColor,
    this.controller,
    this.filled = false,
    this.type,
    this.align,
    this.onFieldSubmit,
    this.action,
    this.suffix,
    this.hintColor,
    this.hintFontSize,
    this.prefix,
    this.radius,
    this.fillColor,
    this.fontSize,
    this.fontWeight,
    this.maxLines,
    this.minLines,
  });

  @override
  State<EditText> createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        autofillHints: widget.autofillHints,
        readOnly: widget.readOnly ?? false,
        enabled: widget.enabled,
        onTap: widget.onTap,
        inputFormatters: widget.inputFormatters,
        maxLines: widget.maxLines ?? 1,
        minLines: widget.minLines ?? 1,
        controller: widget.controller,
        textAlign: widget.align ?? TextAlign.start,
        onChanged: widget.onChange,
        onFieldSubmitted: widget.onFieldSubmit,
        textInputAction: widget.action,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          height: 1.0.h,
        ),
        obscureText: (widget.isPassword ?? false) ? _isObscure : false,
        focusNode: widget.focusNode,
        textDirection: TextDirection.rtl,
        maxLength: (widget.isPhoneNumber ?? false) ? 11 : widget.maxLength,
        keyboardType: widget.type ?? TextInputType.text,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          suffixIcon: (widget.isPassword ?? false)
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  icon: _isObscure
                      ? const Icon(
                          Icons.visibility_outlined,
                          color: weevoDarkGrey,
                        )
                      : const Icon(
                          Icons.visibility_off_outlined,
                          color: weevoDarkGrey,
                        ),
                )
              : widget.suffix,
          prefixIcon: widget.prefix,
          counterText: '',
          fillColor: widget.fillColor ?? kBackgroundColor,
          filled: (widget.filled ?? false)
              ? true
              : (widget.isFocus ?? false)
                  ? false
                  : true,
          hintText: widget.hintText,
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: widget.labelColor ?? Colors.grey,
            fontSize: widget.labelFontSize ?? 14.0.sp,
          ),
          hintStyle: TextStyle(
            color: widget.hintColor ?? Colors.grey,
            fontSize: widget.hintFontSize ?? 14.0.sp,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kBackgroundColor, width: 1.0),
            borderRadius: BorderRadius.circular(20.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: weevoPrimaryOrangeColor, width: 1.0),
            borderRadius: BorderRadius.circular(20.r),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: kBackgroundColor, width: 1.0),
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        validator: widget.validator,
        onSaved: widget.onSave,
      ),
    );
  }
}
