import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Screens/weevo_web_view_preview.dart';
import '../Utilits/colors.dart';

class WeevoCheckbox extends StatefulWidget {
  final bool value;
  final Function onCheck;
  final String content;

  const WeevoCheckbox({
    super.key,
    required this.value,
    required this.onCheck,
    required this.content,
  });

  @override
  State<WeevoCheckbox> createState() => _WeevoCheckboxState();
}

class _WeevoCheckboxState extends State<WeevoCheckbox> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isChecked = !isChecked;
            });
            widget.onCheck(isChecked);
          },
          child: Container(
            width: size.height * 0.04,
            height: size.height * 0.04,
            decoration: BoxDecoration(
                color: isChecked ? weevoPrimaryBlueColor : Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey[400]!, width: 2.0)),
            child: isChecked
                ? const Icon(
                    Icons.done,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
        Expanded(
            child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'أوافق علي',
                style: TextStyle(fontSize: 15.0.sp, color: Colors.black),
              ),
              TextSpan(
                text: ' سياسة الخصوصية',
                style: TextStyle(
                    fontSize: 15.0.sp,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, WeevoWebViewPreview.id,
                        arguments: 'https://weevo.net/privacy-policy/');
                  },
              ),
              TextSpan(
                text: ' و',
                style: TextStyle(fontSize: 15.0.sp, color: Colors.black),
              ),
              TextSpan(
                text: ' الشروط والأحكام',
                style: TextStyle(
                    fontSize: 15.0.sp,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, WeevoWebViewPreview.id,
                        arguments: 'https://weevo.net/terms-conditions/');
                  },
              ),
            ],
          ),
          textAlign: TextAlign.center,
        )),
      ],
    );
  }
}
