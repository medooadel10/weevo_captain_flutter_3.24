import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../Models/chat_data.dart';
import '../../../../Models/feedback_data_arg.dart';
import '../../../../Providers/auth_provider.dart';
import '../../../../Screens/chat_screen.dart';
import '../../../../Screens/merchant_feedback.dart';
import '../../../../Storage/shared_preference.dart';
import '../../../../Utilits/colors.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/widgets/custom_image.dart';
import '../../data/models/shipment_details_model.dart';
import '../../logic/cubit/shipment_details_cubit.dart';

class ShipmentDetailsMerchantHeader extends StatelessWidget {
  const ShipmentDetailsMerchantHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ShipmentDetailsCubit cubit = context.read<ShipmentDetailsCubit>();
    ShipmentDetailsModel? data = cubit.shipmentDetails;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.0.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10.0,
            spreadRadius: 1.0,
            color: Colors.black.withOpacity(0.1),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8.0.w,
        vertical: 5.0.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomImage(
            image: data?.merchant?.photo,
            height: 60.h,
            width: 60.h,
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${data!.merchant!.firstName} ${data.merchant!.lastName}',
                  style: TextStyle(
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                verticalSpace(5),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.pushNamed(context, MerchantFeedback.id,
                            arguments: FeedbackDataArg(
                                username: data.merchant!.name,
                                userId: data.merchant!.id));
                      },
                      child: Container(
                        height: 32.h,
                        width: 32.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffFFE9DF),
                        ),
                        child: const Icon(
                          Icons.star,
                          size: 20.0,
                          color: weevoPrimaryOrangeColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pushNamed(
                          navigator.currentContext!,
                          ChatScreen.id,
                          arguments: ChatData(
                            currentUserNationalId: '',
                            peerNationalId: data.merchant!.phone,
                            currentUserImageUrl: authProvider.photo!,
                            currentUserId: authProvider.id!,
                            currentUserName: authProvider.name!,
                            peerId: data.courierId.toString(),
                            peerUserName: data.merchant!.name,
                            shipmentId: data.id,
                            peerImageUrl: data.merchant!.photo!,
                          ),
                        );
                      },
                      child: Container(
                        height: 32.h,
                        width: 32.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffFFE9DF),
                        ),
                        child: Image.asset(
                          'assets/images/new_chat_icon.png',
                          color: weevoPrimaryOrangeColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () async {
                        await launchUrlString(
                          'tel:${data.merchant!.phone}',
                        );
                      },
                      child: Container(
                        height: 32.h,
                        width: 32.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffFFE9DF),
                        ),
                        child: Image.asset(
                          'assets/images/new_call_icon.png',
                          color: weevoPrimaryOrangeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
