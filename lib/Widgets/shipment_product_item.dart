import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/Widgets/custom_image.dart';

import '../Models/product.dart';
import '../Providers/auth_provider.dart';
import '../Providers/shipment_provider.dart';
import '../core/networking/api_constants.dart';

class ShipmentProductItem extends StatelessWidget {
  final Product product;

  const ShipmentProductItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shipmentProvider =
        Provider.of<ShipmentProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            spreadRadius: 1.0,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
                child: CustomImage(
                  image: product.productInfo!.image!,
                  height: 150.0.h,
                  width: size.width,
                  radius: 0,
                ),
              ),
              Container(
                height: 40.0,
                width: 80.0,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                  ),
                ),
                child: Center(
                  child: Text('QTY: X${product.qty}'),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productInfo!.name!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              height: 1.0,
                            ),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            product.productInfo!.description!,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                            strutStyle: const StrutStyle(
                              forceStrutHeight: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    authProvider.getCatById(shipmentProvider.shipmentById!
                                .products![0].productInfo!.categoryId!) !=
                            null
                        ? Column(
                            children: [
                              CustomImage(
                                image:
                                    '${ApiConstants.baseUrl}${authProvider.getCatById(shipmentProvider.shipmentById!.products![0].productInfo!.categoryId!)!.image}',
                                height: 25.h,
                                width: 25.w,
                                radius: 0,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                '${authProvider.getCatById(shipmentProvider.shipmentById!.products![0].productInfo!.categoryId!)!.name}',
                                style: TextStyle(
                                  fontSize: 8.0.sp,
                                ),
                              )
                            ],
                          )
                        : Container(),
                  ],
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'assets/images/weevo_money.png',
                            fit: BoxFit.contain,
                            height: 25.h,
                            width: 25.w,
                          ),
                          Text(
                            '${product.price}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            strutStyle: const StrutStyle(
                              forceStrutHeight: true,
                            ),
                          ),
                          const Text(
                            'جنيه',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'assets/images/weevo_weight.png',
                            fit: BoxFit.contain,
                            width: 25.w,
                            height: 25.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${double.parse(product.productInfo!.weight!).toInt()}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                strutStyle: const StrutStyle(
                                  forceStrutHeight: true,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            'كيلو',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
