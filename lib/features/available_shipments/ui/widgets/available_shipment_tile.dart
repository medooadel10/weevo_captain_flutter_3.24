import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../Providers/auth_provider.dart';
import '../../../../Screens/child_shipment_details.dart';
import '../../../../Screens/shipment_details_display.dart';
import '../../../../Storage/shared_preference.dart';
import '../../../../Utilits/colors.dart';
import '../../../../Widgets/slide_dotes.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/router/router.dart';
import '../../../../core/widgets/custom_image.dart';
import '../../../products/data/models/shipment_product_model.dart';
import '../../../wasully_details/ui/wasully_details_screen.dart';
import '../../data/models/available_shipment_model.dart';
import 'available_shipment_image.dart';
import 'available_shipment_info.dart';
import 'available_shipment_locations.dart';
import 'available_shipment_price_conatiner.dart';
import 'available_shipment_request_order_button.dart';

class AvailableShipmentTile extends StatefulWidget {
  final AvailableShipmentModel availableShipment;
  const AvailableShipmentTile({
    super.key,
    required this.availableShipment,
  });

  @override
  State<AvailableShipmentTile> createState() => _AvailableShipmentTileState();
}

class _AvailableShipmentTileState extends State<AvailableShipmentTile> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220.h,
      child: widget.availableShipment.products == null ||
              widget.availableShipment.products!.isEmpty
          ? (widget.availableShipment.children != null &&
                  widget.availableShipment.children!.isNotEmpty)
              ? _buildBulkShipmentCartItem(context, widget.availableShipment)
              : _buildCartItem(context, null)
          : CarouselSlider.builder(
              options: CarouselOptions(
                autoPlay: false,
                enableInfiniteScroll: false,
                viewportFraction: 1.0,
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                aspectRatio: 1.0,
                initialPage: 0,
                height: double.infinity,
                scrollDirection: Axis.horizontal,
              ),
              itemBuilder: (context, index, realIndex) {
                ShipmentProductModel product =
                    widget.availableShipment.products![index];

                return _buildCartItem(context, product);
              },
              itemCount: widget.availableShipment.products!.length,
            ),
    );
  }

  Widget _buildCartItem(BuildContext context, ShipmentProductModel? product) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (widget.availableShipment.slug != null) {
            MagicRouter.navigateTo(
                WasullyDetailsScreen(id: widget.availableShipment.id));
          } else {
            MagicRouter.navigateTo(ShipmentDetailsDisplay(
              shipmentId: widget.availableShipment.id,
            ));
          }
        },
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 2,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 120.h,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AvailableShipmentImage(
                          image: widget.availableShipment.image ??
                              product!.productInfo.image,
                        ),
                        Positioned(
                          bottom: -10.h,
                          right: 0,
                          left: 0,
                          child: AvailableShipmentRequestOrderButton(
                            model: widget.availableShipment,
                          ),
                        ),
                      ],
                    ),
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AvailableShipmentInfo(
                          shipment: widget.availableShipment,
                          product: product,
                        ),
                        verticalSpace(5),
                        AvailableShipmentLocations(
                          shipment: widget.availableShipment,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              verticalSpace(16),
              AvailableShipmentPriceContainer(
                shipment: widget.availableShipment,
                product: product,
              ),
            ],
          ).paddingSymmetric(
            vertical: 10.h,
            horizontal: 10.w,
          ),
        ),
      );

  Widget _buildBulkShipmentCartItem(
    BuildContext context,
    AvailableShipmentModel shipment,
  ) {
    AuthProvider authProvider = context.read<AuthProvider>();
    return Stack(
      children: [
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 2,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: CarouselSlider.builder(
            options: CarouselOptions(
                autoPlay: false,
                enableInfiniteScroll: false,
                viewportFraction: 1.0,
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                aspectRatio: 1.0,
                initialPage: 0,
                height: double.infinity,
                onPageChanged: (int index, CarouselPageChangedReason reason) {
                  setState(() {
                    currentIndex = index;
                  });
                }),
            itemCount: shipment.children!.length,
            itemBuilder: (context, i, realIndex) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                MagicRouter.navigateTo(ChildShipmentDetails(
                  shipmentId: widget.availableShipment.id,
                ));
              },
              child: Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 120.h,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Stack(
                                  children: [
                                    CustomImage(
                                      image: shipment.children![i].products![0]
                                          .productInfo.image,
                                    ),
                                    shipment.children!.length > 1
                                        ? Container(
                                            padding: const EdgeInsets.all(6.0),
                                            height: 40.h,
                                            margin: const EdgeInsets.only(
                                                top: 20.0),
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                    'assets/images/clip_path_background.png',
                                                  ),
                                                  fit: BoxFit.fill),
                                            ),
                                            child: Text(
                                              '${shipment.children!.length} شحنة',
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                                Positioned(
                                  bottom: -10.h,
                                  right: 0,
                                  left: 0,
                                  child: AvailableShipmentRequestOrderButton(
                                    model: widget.availableShipment,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              shipment.children![i].products![0]
                                                  .productInfo.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              shipment.children![i].products![0]
                                                  .productInfo.description,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      horizontalSpace(8),
                                      Image.asset(
                                        shipment.children![i].paymentMethod ==
                                                'cod'
                                            ? 'assets/images/shipment_cod_icon.png'
                                            : 'assets/images/shipment_online_icon.png',
                                        height: 35.h,
                                        width: 35.w,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6.h,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: weevoPrimaryOrangeColor,
                                        ),
                                        height: 8.h,
                                        width: 8.w,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${authProvider.getStateNameById(int.parse(shipment.children![i].receivingState ?? '0'))} - ${authProvider.getCityNameById(int.parse(shipment.children![i].receivingState ?? '0'), int.parse(shipment.children![i].receivingCity ?? '0'))}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 16.0.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 2.5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: List.generate(
                                        3,
                                        (index) => Container(
                                          margin: const EdgeInsets.only(top: 1),
                                          height: 3,
                                          width: 3,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(1.5),
                                            color: index < 3
                                                ? weevoPrimaryOrangeColor
                                                : weevoPrimaryBlueColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: weevoPrimaryBlueColor,
                                        ),
                                        height: 8.h,
                                        width: 8.w,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${authProvider.getStateNameById(int.parse(shipment.children![i].deliveringState ?? '0'))} - ${authProvider.getCityNameById(int.parse(shipment.children![i].deliveringState ?? '0'), int.parse(shipment.children![i].deliveringCity ?? '0'))}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 16.0.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      verticalSpace(20),
                      Container(
                        height: 40.h,
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
                                      child: Text(
                                        '${double.parse(shipment.children![i].amount!).toInt()} جنيه',
                                        style: TextStyle(
                                          fontSize: 12.0.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            horizontalSpace(5),
                            if (Preferences.instance.getUserFlags ==
                                'freelance')
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
                                      child: Text(
                                        '${double.parse(shipment.children![i].agreedShippingCostAfterDiscount ?? shipment.children![i].agreedShippingCost ?? shipment.children![i].expectedShippingCost ?? '0').toInt()} جنيه',
                                        style: TextStyle(
                                          fontSize: 12.0.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (shipment.tip != null && shipment.tip != 0) ...[
                              horizontalSpace(5),
                              Expanded(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/tip_black.png',
                                      fit: BoxFit.contain,
                                      color: const Color(0xff091147),
                                      height: 20.h,
                                      width: 20.w,
                                    ),
                                    horizontalSpace(5),
                                    Expanded(
                                      child: Text(
                                        '${shipment.tip.toString().toStringAsFixed0()} جنية',
                                        style: TextStyle(
                                          fontSize: 12.0.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ).paddingSymmetric(
                    vertical: 10.h,
                    horizontal: 10.w,
                  ),
                ],
              ),
            ),
          ),
        ),
        shipment.children!.length > 1
            ? Positioned(
                left: 0,
                right: 0,
                bottom: 10.w,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      shipment.children!.length,
                      (index) => currentIndex == index
                          ? const CategoryDotes(
                              isActive: true,
                              isPlus: true,
                            )
                          : const CategoryDotes(
                              isActive: false,
                              isPlus: true,
                            ),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
