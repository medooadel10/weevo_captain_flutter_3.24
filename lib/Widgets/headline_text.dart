import 'package:flutter/material.dart';

import '../Utilits/colors.dart';

class HeadLineText extends StatelessWidget {
  final String title;

  const HeadLineText({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.03,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          color: weevoLightBlack,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
