import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_captain_app/core/helpers/extensions.dart';

import '../../../../Utilits/colors.dart';
import '../../../../Widgets/edit_text.dart';
import '../../../../Widgets/weevo_button.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/router/router.dart';
import '../../../../core/widgets/custom_image.dart';
import '../../logic/cubit/wasully_details_cubit.dart';

class WasullyOfferDialog extends StatelessWidget {
  final int wasullyId;
  final String merchantName;
  final String merchantRating;
  final String price;
  final String merchantImage;
  const WasullyOfferDialog({
    super.key,
    required this.wasullyId,
    required this.merchantName,
    required this.merchantRating,
    required this.price,
    required this.merchantImage,
  });

  @override
  Widget build(BuildContext context) {
    WasullyDetailsCubit cubit = context.read();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Row(
                children: [
                  CustomImage(
                    image: merchantImage,
                    height: 50.h,
                    width: 50.h,
                    radius: 100.0,
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          merchantName,
                          style: TextStyle(
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_border,
                              color: weevoPrimaryOrangeColor,
                              size: 25.0,
                            ),
                            horizontalSpace(5),
                            Text(
                              double.parse(merchantRating).toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 16.0.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              verticalSpace(10),
              SizedBox(
                width: double.infinity,
                child: WeevoButton(
                  onTap: () {
                    cubit.applyShipment();
                  },
                  color: weevoPrimaryOrangeColor,
                  isStable: true,
                  title: 'قبول التوصيل ب ${price.toStringAsFixed0()} جنيه',
                ),
              ),
              verticalSpace(10),
              EditText(
                controller: cubit.offerController,
                onFieldSubmit: (_) {
                  cubit.sendOffer(wasullyId);
                },
                hintText: 'او قدم عرض التوصيل الخاص بك',
              ),
              verticalSpace(16),
              Row(
                children: [
                  Expanded(
                    child: WeevoButton(
                      onTap: () {
                        cubit.sendOffer(wasullyId);
                      },
                      color: weevoPrimaryBlueColor,
                      isStable: true,
                      title: 'إرسال عرض',
                    ),
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: WeevoButton(
                      onTap: () {
                        MagicRouter.pop();
                      },
                      color: weevoRedColor,
                      isStable: false,
                      title: 'إلغاء',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ).paddingSymmetric(
        horizontal: 10.0.w,
        vertical: 10.0.h,
      ),
    );
  }
}
