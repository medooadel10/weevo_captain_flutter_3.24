import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Utilits/colors.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/widgets/custom_shimmer.dart';

class ShipmentsLoading extends StatelessWidget {
  final int? itemCount;
  const ShipmentsLoading({super.key, this.itemCount});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 2,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 100.w,
                    height: 100.h,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const CustomShimmer(),
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomShimmer(
                                    height: 8.h,
                                  ),
                                  verticalSpace(6),
                                  CustomShimmer(
                                    height: 8.h,
                                  ),
                                ],
                              ),
                            ),
                            horizontalSpace(10),
                            CustomShimmer(
                              height: 35.h,
                              width: 35.w,
                            ),
                          ],
                        ),
                        verticalSpace(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 10.0.h,
                                  width: 10.0.w,
                                  decoration: const BoxDecoration(
                                    color: weevoPrimaryOrangeColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                horizontalSpace(5),
                                Expanded(
                                  child: CustomShimmer(
                                    height: 8.h,
                                  ),
                                ),
                              ],
                            ),
                            verticalSpace(3),
                            const CircleAvatar(
                              backgroundColor: weevoPrimaryOrangeColor,
                              radius: 3.0,
                            ).paddingOnly(
                              right: 2.3.w,
                            ),
                            verticalSpace(3),
                            const CircleAvatar(
                              backgroundColor: weevoPrimaryOrangeColor,
                              radius: 3.0,
                            ).paddingOnly(
                              right: 2.3.w,
                            ),
                            verticalSpace(3),
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: weevoPrimaryBlueColor,
                                  radius: 5.0,
                                ),
                                horizontalSpace(5),
                                Expanded(
                                  child: CustomShimmer(
                                    height: 8.h,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ).paddingOnly(
                          left: 50.w,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              verticalSpace(10),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color(0xffD8F3FF),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/money_icon.png',
                              fit: BoxFit.contain,
                              color: const Color(0xff091147),
                              height: 20.h,
                              width: 20.w,
                            ),
                            horizontalSpace(5),
                            Expanded(
                              child: CustomShimmer(
                                height: 8.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    horizontalSpace(5),
                    Expanded(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/van_icon.png',
                            fit: BoxFit.contain,
                            color: const Color(0xff091147),
                            height: 20.h,
                            width: 20.w,
                          ),
                          horizontalSpace(5),
                          Expanded(
                            child: CustomShimmer(
                              height: 8.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                    horizontalSpace(5),
                    Expanded(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/tip.png',
                            fit: BoxFit.contain,
                            color: const Color(0xff091147),
                            height: 20.h,
                            width: 20.w,
                          ),
                          horizontalSpace(5),
                          Expanded(
                            child: CustomShimmer(
                              height: 8.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).paddingSymmetric(
            vertical: 10.h,
            horizontal: 10.w,
          ),
        );
      },
      separatorBuilder: (context, index) => verticalSpace(10.0),
      itemCount: itemCount ?? 5,
    );
  }
}
