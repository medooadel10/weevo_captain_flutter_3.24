import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Utilits/colors.dart';

class WalletTab extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;
  final String tabTitle;
  final int selectedIndex;
  final int itemIndex;
  final String imageIcon;

  const WalletTab({
    super.key,
    required this.onTap,
    required this.color,
    required this.tabTitle,
    required this.selectedIndex,
    required this.itemIndex,
    required this.imageIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(
                5.0,
              ),
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: color,
                  ),
                  child: Image.asset(
                    imageIcon,
                    height: 30.0,
                    width: 30.0,
                  ),
                ),
              ),
            ),
            selectedIndex == itemIndex
                ? Positioned(
                    right: 0.0,
                    top: 0.0,
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: color,
                    ),
                  )
                : Container(),
          ],
        ),
        Text(
          tabTitle,
          style: const TextStyle(
            fontSize: 15.0,
            color: weevoTransGrey,
            fontWeight: FontWeight.w600,
          ),
          strutStyle: const StrutStyle(
            height: 1.5,
            forceStrutHeight: true,
          ),
          textAlign: TextAlign.center,
        ),
        selectedIndex == itemIndex
            ? SizedBox(
                height: 15.h,
              )
            : Container(),
      ],
    );
  }
}
