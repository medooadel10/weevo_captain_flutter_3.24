import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utilits/colors.dart';

class SlideDotes extends StatelessWidget {
  final bool isActive;

  const SlideDotes(this.isActive, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.only(right: 10),
      height: 8,
      width: isActive ? 20 : 8,
      decoration: BoxDecoration(
        color: isActive ? weevoPrimaryOrangeColor : Colors.grey,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}

class CategoryDotes extends StatelessWidget {
  final bool isActive;
  final bool isPlus;

  const CategoryDotes({
    super.key,
    required this.isActive,
    required this.isPlus,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      height: 7.h,
      width: 7.w,
      decoration: BoxDecoration(
        color: isActive
            ? isPlus
                ? weevoGoldYellow
                : weevoPrimaryOrangeColor
            : Colors.grey,
        borderRadius: BorderRadius.all(
          Radius.circular(
            12.r,
          ),
        ),
      ),
    );
  }
}
