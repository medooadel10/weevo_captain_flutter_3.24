import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Utilits/colors.dart';
import 'weevo_button.dart';

class DigitsCodeWidget extends StatefulWidget {
  final Function onDataCallback;

  const DigitsCodeWidget({super.key, required this.onDataCallback});

  @override
  State<DigitsCodeWidget> createState() => _DigitsCodeWidgetState();
}

class _DigitsCodeWidgetState extends State<DigitsCodeWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(
        20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 20.h,
          ),
          WeevoButton(
            isStable: true,
            color: weevoPrimaryOrangeColor,
            title: 'استمرار',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
