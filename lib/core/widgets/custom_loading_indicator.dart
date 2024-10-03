import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../Utilits/colors.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitDoubleBounce(
        size: 30.0,
        color: weevoPrimaryOrangeColor,
      ),
    );
  }
}
