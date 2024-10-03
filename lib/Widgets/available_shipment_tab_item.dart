import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utilits/colors.dart';

class AvailableShipmentTabItem extends StatelessWidget {
  final String title;
  final String smallTitle;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  const AvailableShipmentTabItem({
    super.key,
    required this.title,
    required this.smallTitle,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: index == selectedIndex
                ? weevoPrimaryOrangeColor.withOpacity(0.2)
                : Colors.grey[200]),
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 6.0,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.0.sp,
                fontWeight: FontWeight.w700,
                color: index == selectedIndex ? Colors.black : Colors.grey[500],
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            index == selectedIndex
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: weevoPrimaryOrangeColor,
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      smallTitle,
                      style: TextStyle(
                          fontSize: 11.0.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    ));
  }
}
