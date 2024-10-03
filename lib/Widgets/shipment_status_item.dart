import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Models/shipment_tab_model.dart';
import '../Providers/shipment_provider.dart';
import '../Utilits/constants.dart';

class ShipmentStatusItem extends StatelessWidget {
  final ShipmentTab data;
  final Function onItemClick;
  final int index;
  final int selectedItem;

  const ShipmentStatusItem({
    super.key,
    required this.data,
    required this.onItemClick,
    required this.index,
    required this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    final ShipmentProvider shipmentProvider =
        Provider.of<ShipmentProvider>(context);
    return GestureDetector(
      onTap: () => onItemClick(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: selectedItem == index ? Colors.orange : Colors.grey[200],
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              data.image,
              height: 18.h,
              width: 18.w,
              color: index == selectedItem
                  ? Colors.white
                  : const Color(0xff575757),
            ),
            SizedBox(
              width: 6.0.w,
            ),
            Text(
              data.name,
              style: TextStyle(
                fontSize: 10.0.sp,
                color: index == selectedItem
                    ? Colors.white
                    : const Color(0xff575757),
              ),
            ),
            SizedBox(
              width: 6.0.w,
            ),
            index == selectedItem
                ? index == 0
                    ? shipmentProvider.courierAppliedState ==
                            NetworkState.success
                        ? Container(
                            height: 18.h,
                            width: 18.w,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: Text(
                              '${shipmentProvider.courierAppliedTotalItems}',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            )))
                        : Container()
                    : index == 1
                        ? Container(
                            height: 18.h,
                            width: 18.w,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: Text(
                              '${shipmentProvider.merchantAcceptedTotalItems}',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            )))
                        : index == 2
                            ? Container(
                                height: 18.h,
                                width: 18.w,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                    child: Text(
                                  '${shipmentProvider.courierOnHisWatToGetShipmentTotalItems}',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )))
                            : index == 3
                                ? Container(
                                    height: 18.h,
                                    width: 18.w,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                        child: Text(
                                      '${shipmentProvider.onDeliveryTotalItems}',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )))
                                : index == 4
                                    ? Container(
                                        height: 18.h,
                                        width: 18.w,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                            child: Text(
                                          '${shipmentProvider.deliveredTotalItems}',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )))
                                    : Container(
                                        height: 18.h,
                                        width: 18.w,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                            child: Text(
                                          '${shipmentProvider.returnedTotalItems}',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )))
                : Container(),
          ],
        ),
      ),
    );
  }
}
