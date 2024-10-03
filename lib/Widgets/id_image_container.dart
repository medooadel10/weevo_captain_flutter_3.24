import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_captain_app/core/widgets/custom_image.dart';

import '../Utilits/colors.dart';

class IDImageContainer extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onImagePressed;
  final bool isLoading;
  final String text;

  const IDImageContainer({
    super.key,
    required this.imagePath,
    required this.onImagePressed,
    required this.isLoading,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onImagePressed,
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: weevoDarkGreyColor,
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                ),
                height: 200.h,
                width: double.infinity,
                child: imagePath == null
                    ? isLoading
                        ? Container()
                        : const Icon(
                            Icons.add,
                            size: 50.0,
                          )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(
                          16.0,
                        ),
                        child: CustomImage(
                          image: imagePath ?? '',
                          height: 200.h,
                          width: double.infinity,
                        ),
                      ),
              ),
              isLoading
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: Container(
                        height: 200.h,
                        width: double.infinity,
                        color: Colors.black.withOpacity(
                          0.6,
                        ),
                        // height: size.width * 0.4,
                        // width: size.width * 0.4,
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              weevoLightPurpleColor,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
