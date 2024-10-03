import 'package:flutter/material.dart';

import '../Utilits/colors.dart';

class WeevoDropDown extends StatelessWidget {
  final List<String> items;
  final Function(String?) onChange;
  final String Function(String?)? validator;
  final Function(String?) onSave;
  final String value;
  final String hintText;
  final Color? color;
  final double? radius;
  final double? fontSize;
  final FontWeight? fontWeight;

  const WeevoDropDown({
    super.key,
    required this.onChange,
    required this.hintText,
    required this.value,
    required this.items,
    required this.validator,
    required this.onSave,
    this.color,
    this.radius,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
      ),
      decoration: BoxDecoration(
        color: weevoGreyColor,
        borderRadius: radius != null
            ? BorderRadius.circular(
                radius!,
              )
            : BorderRadius.circular(
                20.0,
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            hintText,
            style: TextStyle(
              fontSize: fontSize ?? 18.0,
              color: color ?? Colors.black,
              fontWeight: fontWeight ?? FontWeight.w600,
            ),
          ),
          Expanded(
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                fillColor: weevoGreyColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                ),
              ),
              validator: validator,
              onSaved: onSave,
              style: const TextStyle(
                fontSize: 11.0,
                color: Colors.black,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_outlined,
              ),
              items: items
                  .map(
                    (String e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(
                        e,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              value: value,
              onChanged: onChange,
            ),
          ),
        ],
      ),
    );
  }
}
