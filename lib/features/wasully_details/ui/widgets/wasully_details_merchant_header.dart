import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weevo_captain_app/Storage/shared_preference.dart';

import '../../../../Models/chat_data.dart';
import '../../../../Models/feedback_data_arg.dart';
import '../../../../Providers/auth_provider.dart';
import '../../../../Screens/chat_screen.dart';
import '../../../../Screens/merchant_feedback.dart';
import '../../../../Utilits/colors.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/widgets/custom_image.dart';
import '../../data/models/wasully_model.dart';
import '../../logic/cubit/wasully_details_cubit.dart';

class WasullyDetailsMerchantHeader extends StatelessWidget {
  const WasullyDetailsMerchantHeader({super.key});

  @override
  Widget build(BuildContext context) {
    WasullyDetailsCubit cubit = context.read<WasullyDetailsCubit>();
    WasullyModel data = cubit.wasullyModel!;
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
            image: data.merchant.photo != null
                ? data.merchant.photo!.contains(ApiConstants.baseUrl)
                    ? data.merchant.photo!
                    : '${ApiConstants.baseUrl}/${data.merchant.photo}'
                : '',
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
                  '${data.merchant.firstName} ${data.merchant.lastName}',
                  style: TextStyle(
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (data.merchant.cachedAverageRating != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RatingBar.builder(
                        initialRating:
                            double.parse(data.merchant.cachedAverageRating!),
                        minRating: 1,
                        ignoreGestures: true,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 18.0,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: weevoLightYellow,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        data.merchant.cachedAverageRating?.substring(0, 3) ??
                            '0.0',
                        style: TextStyle(
                          fontSize: 10.0.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                verticalSpace(5),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.pushNamed(context, MerchantFeedback.id,
                            arguments: FeedbackDataArg(
                                username: data.merchant.name!,
                                userId: data.merchant.id!));
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
                        DocumentSnapshot userToken = await FirebaseFirestore
                            .instance
                            .collection('merchant_users')
                            .doc(data.merchant.id.toString())
                            .get();
                        String merchantNationalId = userToken['national_id'];
                        Navigator.pushNamed(
                            navigator.currentContext!, ChatScreen.id,
                            arguments: ChatData(
                                currentUserImageUrl: authProvider.photo,
                                peerNationalId: merchantNationalId,
                                currentUserNationalId:
                                    authProvider.getNationalId,
                                currentUserId: authProvider.id,
                                currentUserName: authProvider.name,
                                shipmentId: data.id,
                                peerId: data.merchant.id.toString(),
                                peerUserName:
                                    '${data.merchant.firstName} ${data.merchant.lastName}',
                                peerImageUrl: data.merchant.photo));
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
                        await launchUrl(
                          Uri.parse('tel:${data.merchant.phone}'),
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
