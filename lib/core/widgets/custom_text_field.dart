import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/extensions.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? title;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final VoidCallback? onSuffixIcon;
  final Function(String?)? onSubmit;
  final Function(String?)? onChange;
  final bool? obscureText;
  final String errorMsg;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Function()? onTap;
  final bool readOnly;
  final Color? suffixIconColor;
  final int maxLines;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final int? minValue;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixWidget;
  final int? maxLength;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText,
    required this.errorMsg,
    required this.keyboardType,
    this.onSuffixIcon,
    this.suffixIcon,
    this.onChange,
    this.onSubmit,
    required this.textInputAction,
    this.prefixIcon,
    this.onTap,
    this.title,
    this.readOnly = false,
    this.suffixIconColor,
    this.maxLines = 1,
    this.validator,
    this.focusNode,
    this.minValue,
    this.inputFormatters,
    this.suffixWidget,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onFieldSubmitted: onSubmit,
      onTap: onTap,
      readOnly: readOnly,
      focusNode: focusNode,
      cursorColor: context.colorScheme.primary,
      textInputAction: textInputAction,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        counterText: '',
        floatingLabelAlignment: FloatingLabelAlignment.start,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        alignLabelWithHint: true,
        floatingLabelStyle: TextStyle(
          fontSize: 14.sp,
          color: context.colorScheme.primary,
        ),
        errorMaxLines: 5,
        errorStyle: TextStyle(
          fontSize: 12.sp,
          color: context.colorScheme.error,
        ),
        labelText: hintText,
        labelStyle: TextStyle(
          fontSize: 14.sp,
          color: Colors.grey[600],
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: context.colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: context.colorScheme.error),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: context.colorScheme.primary),
        ),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        suffixIcon: GestureDetector(
          onTap: onSuffixIcon ?? () {},
          child: suffixWidget ??
              Icon(
                suffixIcon,
                color: suffixIconColor ?? context.colorScheme.primary,
              ),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 15.0.h,
          horizontal: 10.0.w,
        ),
      ),
      style: TextStyle(
        fontSize: 16.0.sp,
        color: Colors.black,
      ),
      maxLines: maxLines,
      textAlign: TextAlign.start,
      obscureText: obscureText ?? false,
      validator: validator ??
          (errorMsg == ''
              ? null
              : (value) {
                  if (value == null || value.isEmpty) {
                    return errorMsg;
                  }
                  return null;
                }),
      onChanged: onChange,
    );
  }
}
