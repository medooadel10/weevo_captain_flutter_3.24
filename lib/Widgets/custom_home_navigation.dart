import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weevo_captain_app/core/helpers/extensions.dart';

import '../core/helpers/spacing.dart';

class CustomHomeNavigation extends StatelessWidget {
  final String svgPicture;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String svgPictureSelected;
  const CustomHomeNavigation({
    super.key,
    required this.svgPicture,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.svgPictureSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 5.h,
            width: 48.w,
            decoration: BoxDecoration(
              color:
                  isSelected ? context.colorScheme.primary : Colors.transparent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
          ),
          verticalSpace(8),
          SvgPicture.asset(
            isSelected ? svgPictureSelected : svgPicture,
            width: 22.w,
            height: 22.h,
            colorFilter: ColorFilter.mode(
              isSelected
                  ? context.colorScheme.primary
                  : const Color(0xff9e9e9e),
              BlendMode.srcIn,
            ),
          ),
          verticalSpace(3),
          AnimatedDefaultTextStyle(
            style: TextStyle(
              fontSize: 12.sp,
              color: isSelected
                  ? context.colorScheme.primary
                  : const Color(0xff9e9e9e),
              fontWeight: FontWeight.w800,
            ),
            duration: const Duration(milliseconds: 300),
            child: Text(
              label,
            ),
          ),
        ],
      ),
    );
  }
}
