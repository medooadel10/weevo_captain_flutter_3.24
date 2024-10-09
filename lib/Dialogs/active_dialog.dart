import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';
import '../Widgets/custom_button.dart';

class ActiveDialog extends StatelessWidget {
  final String title;
  final String? name;
  final String? content;
  final bool isInterview;

  const ActiveDialog({
    super.key,
    required this.title,
    this.content,
    this.name,
    required this.isInterview,
  });

  _sendWhatsApp() async {
    var url = "https://wa.me/+201070009192";
    await canLaunchUrlString(url)
        ? await launchUrlString(url)
        : log('No WhatsAPP');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 14.0.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/isActive_img.png'),
                Text(
                  'أهلا بيك ${Preferences.instance.getUserName.split(' ')[0]}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Text(
                  content ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                  ),
                ),
                if (isInterview)
                  SizedBox(
                    height: 12.h,
                  ),
                if (isInterview)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomBtn(
                        text: 'لتفعيل حسابك',
                        onChange: () {
                          _sendWhatsApp();
                        },
                        showImage: true,
                        backgroundColor: weevoPrimaryOrangeColor,
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 10.sp),
                        image: 'assets/images/whatapp.png',
                        height: 32.h,
                        width: 110.w,
                        imageHieght: 15.h,
                        elevation: 0.0,
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      InkWell(
                        child: Image.asset(
                          'assets/images/messenger.png',
                          height: 35.h,
                          width: 40.w,
                        ),
                        onTap: () async {
                          await launchUrlString('https://m.me/weevosupport');
                        },
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      InkWell(
                        child: Image.asset(
                          'assets/images/whatswithback.png',
                          height: 35.h,
                          width: 40.w,
                        ),
                        onTap: () async {
                          await launchUrlString('tel:+201070009192');
                        },
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
