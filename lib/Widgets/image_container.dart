import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_captain_app/core/widgets/custom_image.dart';

import '../Utilits/colors.dart';

class ImageContainer extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onImagePressed;
  final bool isLoading;

  const ImageContainer({
    super.key,
    required this.imagePath,
    required this.onImagePressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onImagePressed,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: weevoDarkGreyColor,
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                ),
                height: 150.h,
                width: 150.w,
                child: imagePath == null || imagePath!.isEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                          25.0,
                        ),
                        child: Image.asset(
                          'assets/images/profile_picture.png',
                        ),
                      )
                    : imagePath!.contains('storage/uploads/images')
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                              25.0,
                            ),
                            child: CustomImage(
                              image: imagePath!,
                              height: 150.h,
                              width: 150.w,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(
                              25.0,
                            ),
                            child: Image.file(
                              File(imagePath!),
                              fit: BoxFit.cover,
                            ),
                          ),
              ),
              isLoading
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: Container(
                        color: Colors.black.withOpacity(
                          0.6,
                        ),
                        height: 150.h,
                        width: 150.w,
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              weevoPrimaryOrangeColor,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              isLoading
                  ? Container()
                  : Positioned(
                      bottom: 0.0,
                      right: 0.0,
                      child: Container(
                        width: 30.0.w,
                        height: 30.0.h,
                        decoration: const BoxDecoration(
                          color: weevoPrimaryOrangeColor,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
