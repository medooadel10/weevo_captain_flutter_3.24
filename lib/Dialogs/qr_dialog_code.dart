import 'package:flutter/material.dart';

import '../Models/refresh_qr_code.dart';
import '../Utilits/colors.dart';
import 'qr_code_display.dart';

class QrCodeDialog extends StatelessWidget {
  final RefreshQrcode data;
  final bool isWasully;
  const QrCodeDialog({super.key, required this.data, this.isWasully = false});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/weevo_scan_qr_code.gif'),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            isWasully
                ? 'عشان تسلم الطلب للتاجر هتخلي\nالتاجر يسكان الكود اللي هيظهرلك\nاو يكتب الكود القصير اللي هيظهرلك'
                : 'عشان تسلم الطلب للتاجر هتخلي\nالتاجر يسكان الكود اللي هيظهرلك\nاو يكتب الكود القصير اللي هيظهرلك',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[600],
              fontWeight: FontWeight.w300,
              height: 1.21,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all<Color>(weevoPrimaryOrangeColor),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => QrCodeDisplay(
                  data: data,
                ),
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
    );
  }
}
