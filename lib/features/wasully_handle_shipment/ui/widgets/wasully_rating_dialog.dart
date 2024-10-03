import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_captain_app/core/widgets/custom_image.dart';

import '../../../../Dialogs/action_dialog.dart';
import '../../../../Dialogs/loading.dart';
import '../../../../Models/shipment_tracking_model.dart';
import '../../../../Screens/home.dart';
import '../../../../Storage/shared_preference.dart';
import '../../../../Utilits/colors.dart';
import '../../../../Widgets/edit_text.dart';
import '../../../../Widgets/weevo_button.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/router/router.dart';
import '../../logic/cubit/wasully_handle_shipment_cubit.dart';

class WasullyRatingDialog extends StatefulWidget {
  final ShipmentTrackingModel model;

  const WasullyRatingDialog({
    super.key,
    required this.model,
  });

  @override
  State<WasullyRatingDialog> createState() => _WasullyRatingDialogState();
}

class _WasullyRatingDialogState extends State<WasullyRatingDialog> {
  late TextEditingController _ratingController;
  late FocusNode _focusNode;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  bool _isFocus = false;
  double? _ratePoint;

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
    final WasullyHandleShipmentCubit wasullyHandleShipmentCubit =
        context.read<WasullyHandleShipmentCubit>();
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
          top: 10.0,
          bottom: 20,
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
                    borderRadius: BorderRadius.circular(50.0),
                    child: widget.model.merchantImage != null &&
                            widget.model.merchantImage!.isNotEmpty
                        ? CustomImage(
                            image: widget.model.merchantImage!
                                    .contains(ApiConstants.baseUrl)
                                ? widget.model.merchantImage!
                                : '${ApiConstants.baseUrl}${widget.model.merchantImage}',
                            height: 100.0,
                            width: 100.0,
                            radius: 0,
                          )
                        : Image.asset(
                            'assets/images/profile_picture.png',
                            height: 100.0,
                            width: 100.0,
                          ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                'كيف كانت شحنتك مع التاجر ${widget.model.merchantName}',
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
                                  fontWeight: FontWeight.w600, fontSize: 16.0),
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
                  validator: (v) {
                    return null;
                  },
                  filled: false,
                  radius: 12.0.r,
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
                      builder: (context) => BlocConsumer<
                              WasullyHandleShipmentCubit,
                              WasullyHandleShipmentState>(
                            listener: (context, state) {
                              if (state
                                  is WasullyHandleShipmentReviewMerchantSuccess) {
                                MagicRouter.pop();
                                showDialog(
                                    context: navigator.currentContext!,
                                    builder: (context) => Dialog(
                                        insetPadding:
                                            const EdgeInsets.all(20.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20.0),
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
                                                      WidgetStateProperty.all<
                                                              Color>(
                                                          weevoPrimaryOrangeColor),
                                                  shape: WidgetStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  MagicRouter.pop();
                                                  MagicRouter.pop();
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                    context,
                                                    Home.id,
                                                    (route) => false,
                                                  );
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
                              }
                              if (state
                                  is WasullyHandleShipmentReviewMerchantError) {
                                MagicRouter.pop();
                                showDialog(
                                    context: navigator.currentContext!,
                                    barrierDismissible: false,
                                    builder: (context) => ActionDialog(
                                          content:
                                              'حدث خطأ من فضلك حاول مرة اخري',
                                          cancelAction: 'حسناً',
                                          onCancelClick: () {
                                            MagicRouter.pop();
                                          },
                                        ));
                              }
                            },
                            builder: (context, state) {
                              return const Loading();
                            },
                          ));
                  await wasullyHandleShipmentCubit.reviewMerchant(
                      shipmentId: widget.model.shipmentId,
                      rating: _ratePoint?.toInt() ?? 0,
                      body: _ratingController.text.isEmpty
                          ? 'لا تعليق'
                          : _ratingController.text,
                      recommend: 'Yes',
                      title: _ratePoint == 1.0
                          ? 'very bad'
                          : _ratePoint == 2.0
                              ? 'bad'
                              : _ratePoint == 3.0
                                  ? 'good'
                                  : _ratePoint == 4.0
                                      ? 'very good'
                                      : 'excellent');
                },
                color: weevoPrimaryOrangeColor,
                isStable: true,
                title: 'ارسال التقييم',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
