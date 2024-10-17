import 'package:flutter/material.dart';

import '../Models/refresh_qr_code.dart';
import '../Utilits/colors.dart';
import '../core/networking/api_constants.dart';
import '../core/widgets/custom_image.dart';

class QrCodeDisplay extends StatefulWidget {
  final RefreshQrcode data;

  const QrCodeDisplay({super.key, required this.data});

  @override
  State<QrCodeDisplay> createState() => _QrCodeDisplayState();
}

class _QrCodeDisplayState extends State<QrCodeDisplay> {
  int _state = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _state == 1
                ? Column(
                    children: [
                      const Text(
                        'خلي الكابتن يكتب الكود ده عنده',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: weevoGreyLighter,
                          fontWeight: FontWeight.w500,
                          //height: 1.43,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: widget.data.code
                              .toString()
                              .split('')
                              .map(
                                (e) => Text(
                                  e,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      const Text(
                        'خلي التاجر يعمل\nسكان للكود ده',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: weevoGreyLighter,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      CustomImage(
                        image: '${ApiConstants.baseUrl}${widget.data.path}',
                        height: 150.0,
                        width: 150.0,
                        radius: 0,
                      ),
                    ],
                  ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _state = 1;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: _state == 1
                          ? Border.all(color: Colors.black, width: 1.5)
                          : null,
                    ),
                    child: Image.asset(
                      'assets/images/dail.png',
                      height: 50.0,
                      width: 50.0,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _state = 0;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      border: _state == 0
                          ? Border.all(color: Colors.black, width: 1.5)
                          : null,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Image.asset(
                      'assets/images/qr_code.png',
                      height: 50.0,
                      width: 50.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  weevoPrimaryOrangeColor,
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
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
      ),
    );
  }
}
