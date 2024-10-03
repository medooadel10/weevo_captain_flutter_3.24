import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_captain_app/core/widgets/custom_image.dart';

import '../Models/cars/car_sub_model.dart';
import '../Utilits/constants.dart';

class CarSubModelBottomSheet extends StatelessWidget {
  final Function onItemClick;
  final List<CarSubModels> subModels;
  final String parentImageUrl;

  const CarSubModelBottomSheet({
    super.key,
    required this.onItemClick,
    required this.subModels,
    required this.parentImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: subModels.length,
      itemBuilder: (context, int i) => ListTile(
        leading: CustomImage(
          image: '$carIconLoadUrl$parentImageUrl',
          height: 30.0,
          width: 30.0,
          radius: 25,
        ),
        onTap: () => onItemClick(
          subModels[i],
          subModels.indexOf(subModels[i]),
        ),
        title: Text(
          subModels[i].name!,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
