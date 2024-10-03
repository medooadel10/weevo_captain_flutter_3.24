import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utilits/constants.dart';

class GenderBottomSheet extends StatelessWidget {
  final Function onItemClick;
  final int selectedItem;

  const GenderBottomSheet({
    super.key,
    required this.onItemClick,
    required this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: genders
          .map(
            (item) => Column(
              children: [
                ListTile(
                  onTap: () => onItemClick(
                    item,
                    genders.indexOf(item),
                  ),
                  title: Text(
                    item,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: selectedItem == genders.indexOf(item)
                      ? const Icon(
                          Icons.done,
                          color: Colors.black,
                        )
                      : const SizedBox(
                          height: 24.0,
                          width: 24.0,
                        ),
                ),
                genders.indexOf(item) != genders.length - 1
                    ? Divider(
                        height: 5.0.h,
                        thickness: 0.7,
                        indent: 20.0,
                        endIndent: 20.0,
                        color: Colors.black,
                      )
                    : Container(),
              ],
            ),
          )
          .toList(),
    );
  }
}
