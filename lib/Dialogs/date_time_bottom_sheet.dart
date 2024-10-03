import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateTimeBottomSheet<E> extends StatelessWidget {
  final Function onItemClick;
  final List<E> data;

  const DateTimeBottomSheet({super.key, 
    required this.onItemClick,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext ctx, int i) => ListTile(
        onTap: () => onItemClick(
          data[i],
          i,
        ),
        title: Text(
          data[i].toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      itemCount: data.length,
    );
  }
}
