import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../networking/api_constants.dart';
import 'custom_shimmer.dart';

class CustomImage extends StatelessWidget {
  final String? image;
  final double height;
  final double width;
  final double radius;
  final BoxFit fit;
  const CustomImage({
    super.key,
    required this.image,
    this.height = 100,
    this.width = 100,
    this.radius = 8.0,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height.h,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: CachedNetworkImage(
        imageUrl: image != null
            ? image!.contains('eg.api.weevoapp')
                ? image!
                : '${ApiConstants.baseUrl}$image'
            : '',
        width: width.w,
        fit: fit,
        placeholder: (context, url) => const CustomShimmer(),
        errorWidget: (context, url, error) => Container(
          width: width.w,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Icon(
            Icons.image,
            size: height / 1.2,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
