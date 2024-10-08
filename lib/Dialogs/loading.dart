import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Utilits/colors.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Dialog(
        child: Container(
          height: 80.0,
          padding: const EdgeInsets.all(20.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('برجاء الأنتظار',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  )),
              SpinKitDoubleBounce(
                size: 30,
                color: weevoPrimaryOrangeColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
