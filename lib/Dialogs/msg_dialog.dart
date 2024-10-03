import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Utilits/colors.dart';

class MsgDialog extends StatelessWidget {
  final String content;

  const MsgDialog({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: 200.0,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(content,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                )),
            const SizedBox(
              height: 10.0,
            ),
            const SpinKitDoubleBounce(
              color: weevoPrimaryOrangeColor,
            ),
          ],
        ),
      ),
    );
  }
}
