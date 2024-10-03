import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_image.dart';

class WasullyDetailsImage extends StatelessWidget {
  final String image;
  const WasullyDetailsImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return CustomImage(
      image: image,
      width: double.infinity,
      height: 200,
      radius: 12,
    );
  }
}
