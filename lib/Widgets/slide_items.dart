import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'slide.dart';

class SlideItems extends StatelessWidget {
  final int index;

  const SlideItems(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: const Color(0xFFF2FBFF),
      padding: const EdgeInsets.only(
          left: 30.0, right: 30.0, bottom: 16.0, top: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            slideList[index].title,
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.end,
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            slideList[index].desc,
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.grey[400],
            ),
            textAlign: TextAlign.end,
          ),
          Expanded(
            child: Image.asset(
              slideList[index].image,
              width: size.width,
            ),
          ),
        ],
      ),
    );
  }
}
