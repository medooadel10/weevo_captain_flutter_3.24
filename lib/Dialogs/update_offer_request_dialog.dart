import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utilits/colors.dart';

class UpdateOfferRequestDialog extends StatelessWidget {
  final VoidCallback onBetterOfferCallback;
  final VoidCallback onCancelCallback;
  final String message;

  const UpdateOfferRequestDialog({
    super.key,
    required this.onBetterOfferCallback,
    required this.onCancelCallback,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: 20.0.w,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onBetterOfferCallback,
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              weevoPrimaryOrangeColor,
                            ),
                            padding: WidgetStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(0.0)),
                            fixedSize: WidgetStateProperty.all<Size>(
                                const Size(100.0, 60.0)),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                          child: Text(
                            'تقديم عرض أفضل',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onCancelCallback,
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              weevoPrimaryOrangeColor,
                            ),
                            padding: WidgetStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(0.0)),
                            fixedSize: WidgetStateProperty.all<Size>(
                                const Size(100.0, 60.0)),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                          child: Text(
                            'لا أرغب',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
