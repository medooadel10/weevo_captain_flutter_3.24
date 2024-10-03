import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utilits/constants.dart';

class ColorBottomSheet extends StatelessWidget {
  final Function onItemClick;
  final int selectedItem;

  const ColorBottomSheet({
    super.key,
    required this.onItemClick,
    required this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: colorList.length,
      itemBuilder: (context, int i) => ListTile(
        leading: Container(
          height: 15.0,
          width: 15.0,
          decoration: BoxDecoration(
            border: Border.all(
              color: colorList[i].color == Colors.grey
                  ? Colors.black
                  : Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(25.0),
            color: colorList[i].color,
          ),
        ),
        onTap: () => onItemClick(
          colorList[i],
          colorList.indexOf(colorList[i]),
        ),
        title: Text(
          colorList[i].name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: selectedItem == colorList.indexOf(colorList[i])
            ? const Icon(
                Icons.done,
                color: Colors.black,
              )
            : const SizedBox(
                height: 24.0,
                width: 24.0,
              ),
      ),
    );
  }
}
