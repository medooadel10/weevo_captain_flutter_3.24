import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScanWidget extends StatefulWidget {
  final Function onDataCallback;

  const QrCodeScanWidget({super.key, required this.onDataCallback});

  @override
  State<QrCodeScanWidget> createState() => _QrCodeScanWidgetState();
}

class _QrCodeScanWidgetState extends State<QrCodeScanWidget> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController _controller;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      width: 200.0,
      child: QRView(
        key: _qrKey,
        onQRViewCreated: (QRViewController controller) async {
          setState(() {
            _controller = controller;
          });
          _controller.scannedDataStream.listen((Barcode barCode) async {
            log('barCode: ${barCode.code}');
            if (barCode.code != null || barCode.code?.isNotEmpty == true) {
              widget.onDataCallback(barCode.code!);
              await controller.stopCamera();
            }
          });
        },
        overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderLength: 30,
          borderWidth: 10,
          cutOutHeight: 300,
          cutOutWidth: 300,
        ),
      ),
    );
  }
}
