import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/Storage/shared_preference.dart';

import '../Models/shipment_tracking_model.dart';
import '../Providers/shipment_tracking_provider.dart';
import '../Screens/home.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import '../Widgets/edit_text.dart';
import '../Widgets/weevo_button.dart';
import '../core/helpers/spacing.dart';
import '../core/networking/api_constants.dart';
import '../core/router/router.dart';
import '../core/widgets/custom_image.dart';
import 'action_dialog.dart';
import 'loading.dart';

class RatingDialog extends StatefulWidget {
  final ShipmentTrackingModel model;

  const RatingDialog({
    super.key,
    required this.model,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  late TextEditingController _ratingController;
  late FocusNode _focusNode;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  bool _isFocus = false;
  double? _ratePoint;
  final bool _value = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _ratingController = TextEditingController();
    _focusNode.addListener(() {
      setState(() {
        _isFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShipmentTrackingProvider trackingProvider =
        Provider.of<ShipmentTrackingProvider>(context);
    if (true) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'تقييم التاجر',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: weevoPrimaryOrangeColor,
            ),
            onPressed: () {
              MagicRouter.navigateAndPopAll(const Home());
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            right: 30.0,
            left: 30.0,
            top: 20.0,
            bottom: 20.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                verticalSpace(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: CustomImage(
                        image: widget.model.courierImage != null
                            ? widget.model.courierImage!
                                    .contains(ApiConstants.baseUrl)
                                ? widget.model.courierImage!
                                : '${ApiConstants.baseUrl}${widget.model.courierImage}'
                            : '',
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  'كيف كانت شحنتك مع التاجر ${widget.model.courierName}',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Center(
                  child: RatingBar.builder(
                    itemBuilder: (BuildContext ctx, int i) => const Icon(
                      Icons.star_rounded,
                      color: weevoPrimaryOrangeColor,
                    ),
                    glowColor: weevoPrimaryOrangeColor.withOpacity(0.1),
                    onRatingUpdate: (double v) {
                      setState(() {
                        _ratePoint = v;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                _ratePoint == 1.0
                    ? const Text(
                        'سئ جداً',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.0),
                        textAlign: TextAlign.center,
                      )
                    : _ratePoint == 2.0
                        ? const Text(
                            'سئ',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16.0),
                            textAlign: TextAlign.center,
                          )
                        : _ratePoint == 3.0
                            ? const Text(
                                'جيد',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0),
                                textAlign: TextAlign.center,
                              )
                            : _ratePoint == 4.0
                                ? const Text(
                                    'جيد جداً',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0),
                                    textAlign: TextAlign.center,
                                  )
                                : _ratePoint == 5.0
                                    ? const Text(
                                        'ممتاز',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.0),
                                        textAlign: TextAlign.center,
                                      )
                                    : Container(),
                const SizedBox(
                  height: 8.0,
                ),
                Form(
                  key: _formState,
                  child: EditText(
                    controller: _ratingController,
                    readOnly: false,
                    isFocus: _isFocus,
                    type: TextInputType.multiline,
                    minLines: 2,
                    maxLines: 4,
                    filled: false,
                    radius: 12.0.r,
                    validator: (v) {
                      return null;
                    },
                    focusNode: _focusNode,
                    labelColor: Colors.grey,
                    labelFontSize: 15.0.sp,
                    align: TextAlign.start,
                    action: TextInputAction.done,
                    isPhoneNumber: false,
                    isPassword: false,
                    labelText: 'التقييم',
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                WeevoButton(
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: (context) => const Loading());
                    await trackingProvider.reviewMerchant(
                        shipmentId: widget.model.shipmentId,
                        rating: _ratePoint?.toInt(),
                        body: _ratingController.text.isEmpty
                            ? '.'
                            : _ratingController.text,
                        recommend: _value ? 'Yes' : 'No',
                        title: _ratePoint == 1.0
                            ? 'very bad'
                            : _ratePoint == 2.0
                                ? 'bad'
                                : _ratePoint == 3.0
                                    ? 'good'
                                    : _ratePoint == 4.0
                                        ? 'very good'
                                        : 'excellent');
                    if (trackingProvider.state == NetworkState.success) {
                      Navigator.pop(navigator.currentContext!);
                      showDialog(
                          context: navigator.currentContext!,
                          builder: (context) => Dialog(
                              insetPadding: const EdgeInsets.all(20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/images/done_icon.png',
                                      color: weevoPrimaryOrangeColor,
                                      height: 150.0,
                                      width: 150.0,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Text(
                                      'تم ارسال التقييم',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                                weevoPrimaryOrangeColor),
                                        shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, Home.id, (route) => false);
                                      },
                                      child: const Text(
                                        'حسناً',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )));
                    } else if (trackingProvider.state == NetworkState.error) {
                      showDialog(
                          context: navigator.currentContext!,
                          barrierDismissible: false,
                          builder: (context) => ActionDialog(
                                content: 'حدث خطأ من فضلك حاول مرة اخري',
                                cancelAction: 'حسناً',
                                onCancelClick: () {
                                  Navigator.pop(context);
                                },
                              ));
                    }
                  },
                  title: 'ارسال التقييم',
                  color: weevoPrimaryOrangeColor,
                  isStable: true,
                )
              ],
            ),
          ),
        ),
      );
    }
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.stretch,
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         ClipRRect(
    //           borderRadius: BorderRadius.circular(100.0),
    //           child: CustomImage(
    //             image: widget.model.courierImage,
    //             height: 50.0,
    //             width: 50.0,
    //           ),
    //         ),
    //       ],
    //     ),
    //     SizedBox(
    //       height: 8.0,
    //     ),
    //     Text(
    //       'كيف كانت شحنتك مع الكابتن ${widget.model.courierName}',
    //       textDirection: TextDirection.rtl,
    //       textAlign: TextAlign.center,
    //       style: TextStyle(
    //         fontSize: 16.0,
    //         fontWeight: FontWeight.w600,
    //       ),
    //     ),
    //     SizedBox(
    //       height: 8.0,
    //     ),
    //     Center(
    //       child: RatingBar.builder(
    //         itemBuilder: (BuildContext ctx, int i) => Icon(
    //           Icons.star_rounded,
    //           color: weevoPrimaryOrangeColor,
    //         ),
    //         glowColor: weevoPrimaryOrangeColor.withOpacity(0.1),
    //         onRatingUpdate: (double v) {
    //           setState(() {
    //             _ratePoint = v;
    //           });
    //         },
    //       ),
    //     ),
    //     SizedBox(
    //       height: 8.0,
    //     ),
    //     _ratePoint == 1.0
    //         ? Text(
    //             'سئ جداً',
    //             style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
    //             textAlign: TextAlign.center,
    //           )
    //         : _ratePoint == 2.0
    //             ? Text(
    //                 'سئ',
    //                 style:
    //                     TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
    //                 textAlign: TextAlign.center,
    //               )
    //             : _ratePoint == 3.0
    //                 ? Text(
    //                     'جيد',
    //                     style: TextStyle(
    //                         fontWeight: FontWeight.w600, fontSize: 16.0),
    //                     textAlign: TextAlign.center,
    //                   )
    //                 : _ratePoint == 4.0
    //                     ? Text(
    //                         'جيد جداً',
    //                         style: TextStyle(
    //                             fontWeight: FontWeight.w600, fontSize: 16.0),
    //                         textAlign: TextAlign.center,
    //                       )
    //                     : _ratePoint == 5.0
    //                         ? Text(
    //                             'ممتاز',
    //                             style: TextStyle(
    //                                 fontWeight: FontWeight.w600,
    //                                 fontSize: 16.0),
    //                             textAlign: TextAlign.center,
    //                           )
    //                         : Container(),
    //     SizedBox(
    //       height: 8.0,
    //     ),
    //     Form(
    //       key: _formState,
    //       child: EditText(
    //         controller: _ratingController,
    //         readOnly: false,
    //         isFocus: _isFocus,
    //         type: TextInputType.multiline,
    //         minLines: 2,
    //         maxLines: 4,
    //         filled: false,
    //         radius: 12.0.r,
    //         focusNode: _focusNode,
    //         labelColor: Colors.grey,
    //         labelFontSize: 15.0.sp,
    //         align: TextAlign.start,
    //         action: TextInputAction.done,
    //         isPhoneNumber: false,
    //         isPassword: false,
    //         labelText: 'التقييم',
    //       ),
    //     ),
    //     SizedBox(
    //       height: 12.0,
    //     ),
    //     SwitchListTile(
    //       value: _value,
    //       onChanged: (bool v) {
    //         setState(() {
    //           _value = v;
    //         });
    //       },
    //       activeColor: weevoPrimaryOrangeColor,
    //       title: Text('توصي به'),
    //       subtitle: Text(_value ? 'نعم' : 'لا'),
    //     ),
    //     SizedBox(
    //       height: 12.0,
    //     ),
    //     TextButton(
    //       style: ButtonStyle(
    //         backgroundColor:
    //             MaterialStateProperty.all<Color>(weevoPrimaryOrangeColor),
    //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //           RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(8),
    //           ),
    //         ),
    //       ),
    //       onPressed: () async {
    //         if (_ratingController.text.isNotEmpty &&
    //             _ratePoint != null &&
    //             _value != null) {
    //           showDialog(context: context, builder: (context) => Loading());
    //           await trackingProvider.reviewCourier(
    //               shipmentId: widget.model.shipmentId,
    //               rating: _ratePoint.toInt(),
    //               body: _ratingController.text,
    //               recommend: _value ? 'Yes' : 'No',
    //               title: _ratePoint == 1.0
    //                   ? 'very bad'
    //                   : _ratePoint == 2.0
    //                       ? 'bad'
    //                       : _ratePoint == 3.0
    //                           ? 'good'
    //                           : _ratePoint == 4.0
    //                               ? 'very good'
    //                               : 'excellent');
    //           if (trackingProvider.state == NetworkState.SUCCESS) {
    //             Navigator.pop(context);
    //             showDialog(
    //                 context: context,
    //                 builder: (context) => Dialog(
    //                     insetPadding: EdgeInsets.all(20.0),
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(20),
    //                     ),
    //                     child: Padding(
    //                       padding: EdgeInsets.symmetric(vertical: 20.0),
    //                       child: Column(
    //                         mainAxisSize: MainAxisSize.min,
    //                         children: [
    //                           Image.asset(
    //                             'assets/images/done_icon.png',
    //                             color: weevoPrimaryOrangeColor,
    //                             height: 150.0,
    //                             width: 150.0,
    //                             fit: BoxFit.cover,
    //                           ),
    //                           SizedBox(
    //                             height: 8,
    //                           ),
    //                           Text(
    //                             'تم ارسال التقييم',
    //                             style: TextStyle(
    //                               color: Colors.black,
    //                               fontSize: 18.0,
    //                             ),
    //                             textAlign: TextAlign.center,
    //                           ),
    //                           TextButton(
    //                             style: ButtonStyle(
    //                               backgroundColor:
    //                                   MaterialStateProperty.all<Color>(
    //                                       weevoPrimaryOrangeColor),
    //                               shape: MaterialStateProperty.all<
    //                                   RoundedRectangleBorder>(
    //                                 RoundedRectangleBorder(
    //                                   borderRadius: BorderRadius.circular(20),
    //                                 ),
    //                               ),
    //                             ),
    //                             onPressed: () {
    //                               Navigator.pop(context);
    //                               Navigator.pop(context);
    //                               Navigator.pushNamedAndRemoveUntil(
    //                                   context, Home.id, (route) => false);
    //                             },
    //                             child: Text(
    //                               'حسناً',
    //                               style: TextStyle(
    //                                 fontSize: 12.0,
    //                                 color: Colors.white,
    //                                 fontWeight: FontWeight.w500,
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     )));
    //           } else if (trackingProvider.state == NetworkState.ERROR) {
    //             showDialog(
    //                 context: context,
    //                 barrierDismissible: false,
    //                 builder: (context) => ActionDialog(
    //                       content: 'حدث خطأ من فضلك حاول مرة اخري',
    //                       cancelAction: 'حسناً',
    //                       onCancelClick: () {
    //                         Navigator.pop(context);
    //                       },
    //                     ));
    //           }
    //         } else {
    //           showDialog(
    //               context: context,
    //               builder: (context) => ContentDialog(
    //                   content: 'أدخل القيم بطريقة صحيحة',
    //                   callback: () {
    //                     Navigator.pop(context);
    //                   }));
    //         }
    //       },
    //       child: Text(
    //         'أرسال التقييم',
    //         style: TextStyle(
    //           fontSize: 16.0,
    //           color: Colors.white,
    //           fontWeight: FontWeight.w600,
    //         ),
    //         textAlign: TextAlign.center,
    //       ),
    //     ),
    //   ],
    // );
  }
}
