import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/custom_image.dart';

class AvailableShipmentImage extends StatelessWidget {
  final String image;
  const AvailableShipmentImage({super.key, required this.image});
  @override
  Widget build(BuildContext context) {
    return CustomImage(
      image: image,
      width: 120.w,
      height: double.infinity,
    );
  }
}
