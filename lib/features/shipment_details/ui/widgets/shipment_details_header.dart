import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_captain_app/core/helpers/extensions.dart';

import '../../../../Utilits/colors.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/widgets/custom_image.dart';
import '../../logic/cubit/shipment_details_cubit.dart';
import 'shipment_details_price_info.dart';

class ShipmentDetailsHeader extends StatelessWidget {
  final String image;
  const ShipmentDetailsHeader({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentDetailsCubit, ShipmentDetailsState>(
      builder: (context, state) {
        final cubit = context.read<ShipmentDetailsCubit>();
        return CarouselSlider.builder(
          itemCount: cubit.shipmentDetails!.products.length,
          itemBuilder: (context, index, realIndex) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      CustomImage(
                        image: cubit
                            .shipmentDetails!.products[index].productInfo.image,
                        width: double.infinity,
                        height: 120.h,
                        radius: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  cubit.shipmentDetails!.products[index]
                                      .productInfo.name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              horizontalSpace(10),
                              Row(
                                children: [
                                  CustomImage(
                                    image: cubit
                                        .shipmentDetails!
                                        .products[index]
                                        .productInfo
                                        .productCategory
                                        .image,
                                    width: 20.w,
                                    height: 20.h,
                                    fit: BoxFit.contain,
                                  ),
                                  horizontalSpace(5),
                                  Text(
                                    cubit.shipmentDetails!.products[index]
                                        .productInfo.productCategory.name,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            cubit.shipmentDetails!.products[index].productInfo
                                .description,
                            style: TextStyle(
                              fontSize: 14.0.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          verticalSpace(5),
                          Row(
                            children: [
                              ShipmentDetailsPriceInfo(
                                priceImage: 'weevo_money',
                                price: cubit
                                        .shipmentDetails?.products[index].price
                                        .toString() ??
                                    '',
                                title: 'قيمة الطلب',
                              ),
                              horizontalSpace(10),
                              Text(
                                '|',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              horizontalSpace(10),
                              ShipmentDetailsPriceInfo(
                                priceImage: 'van_icon',
                                price: cubit.shipmentDetails?.products[index]
                                        .productInfo.weight ??
                                    '',
                                title: 'الوزن',
                                subTitle: 'كيلو',
                              ),
                            ],
                          ),
                        ],
                      ).paddingSymmetric(
                        horizontal: 10.0.w,
                        vertical: 10.0.h,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0.w,
                      vertical: 5.0.h,
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.0),
                      ),
                      color: weevoPrimaryOrangeColor,
                    ),
                    child: Text(
                      'الكمية : ${cubit.shipmentDetails?.products[index].qty}',
                      style: TextStyle(
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          options: CarouselOptions(
            autoPlay: false,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              cubit.changeProductIndex(index);
            },
            height: 260.h,
          ),
        );
      },
    );
  }
}
