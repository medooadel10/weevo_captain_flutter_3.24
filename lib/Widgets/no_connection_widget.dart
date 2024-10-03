import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoConnectionWidget extends StatelessWidget {
  const NoConnectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.signal_wifi_off,
            size: 50,
            color: Colors.grey,
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            'لا يوجد انترنت',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 6.h,
          ),
          Text(
            'تأكد من أتصالك بالأنترنت',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
