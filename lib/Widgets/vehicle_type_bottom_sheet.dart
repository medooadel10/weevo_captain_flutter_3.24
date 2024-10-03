import 'package:flutter/material.dart';

import '../../Utilits/constants.dart';

class VehicleBottomSheet extends StatelessWidget {
  final Function onTap;

  const VehicleBottomSheet({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: carTypes.length,
      itemBuilder: (BuildContext context, int i) => ListTile(
        title: Text(
          carTypes[i],
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        onTap: () => onTap(
          carTypes[i],
          carTypes.indexOf(
            carTypes[i],
          ),
        ),
      ),
    );
  }
}
