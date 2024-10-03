import 'package:flutter/material.dart';

import '../helpers/spacing.dart';
import 'custom_shimmer.dart';

class CustomShimmerList extends StatelessWidget {
  final int itemCount;
  final double? height;
  final Widget? child;
  const CustomShimmerList({
    super.key,
    this.itemCount = 20,
    this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return SizedBox(
          width: double.infinity,
          height: height,
          child: child ?? const CustomShimmer(),
        );
      },
      separatorBuilder: (context, index) => verticalSpace(10.0),
      itemCount: itemCount,
    );
  }
}
