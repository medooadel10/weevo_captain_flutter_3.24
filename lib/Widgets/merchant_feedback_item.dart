import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Models/merchant_review.dart';
import '../Utilits/colors.dart';

class MerchantFeedbackItem extends StatelessWidget {
  final MerchantReview model;

  const MerchantFeedbackItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 1.5,
      shadowColor: Colors.grey[300],
      margin: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 6.0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: model.title == 'excellent' ||
                                      model.title == 'excelent'
                                  ? const Text('ممتاز')
                                  : model.title == 'very good'
                                      ? const Text('جيد جداً')
                                      : model.title == 'good'
                                          ? const Text('جيد')
                                          : model.title == 'bad'
                                              ? const Text('سئ')
                                              : const Text('سئ جداً')),
                          RatingBar.builder(
                            initialRating: model.rating!.toDouble(),
                            minRating: 1,
                            ignoreGestures: true,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 15.0,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: weevoLightYellow,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.grey, width: 2.0),
                              ),
                              padding: const EdgeInsets.all(4.0),
                              child: Center(
                                  child: Text(
                                '${model.rating}',
                                style: const TextStyle(
                                  color: weevoPrimaryOrangeColor,
                                  fontSize: 16.0,
                                ),
                              ))),
                        ],
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      const Divider(
                        height: 1.0,
                        thickness: 0.5,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(model.body!),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
