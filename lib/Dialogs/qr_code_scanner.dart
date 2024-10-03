import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utilits/colors.dart';
import '../Widgets/otp_input.dart';
import '../Widgets/qr_code_scan_widget.dart';
import '../core/helpers/spacing.dart';
import '../core/router/router.dart';

class QrCodeScanner extends StatefulWidget {
  final Function(String) onDataCallback;

  const QrCodeScanner({
    super.key,
    required this.onDataCallback,
  });

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  late FocusNode _bin1Node, _bin2Node, _bin3Node, _bin4Node;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  String _value = '';

  @override
  void initState() {
    super.initState();
    _bin1Node = FocusNode();
    _bin2Node = FocusNode();
    _bin3Node = FocusNode();
    _bin4Node = FocusNode();
  }

  @override
  void dispose() {
    _bin1Node.dispose();
    _bin2Node.dispose();
    _bin3Node.dispose();
    _bin4Node.dispose();
    super.dispose();
  }

  void nextFocus(String value, FocusNode node) {
    if (value.length == 1) {
      node.requestFocus();
    }
  }

  void perviousFocus(String value, FocusNode node) {
    if (value.isEmpty) {
      node.requestFocus();
    }
  }

  int _state = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Dialog(
        insetPadding: const EdgeInsets.all(20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _state == 1
                  ? Column(
                      children: [
                        const Text(
                          'اكتب الكود هنا',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: weevoGreyLighter,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Form(
                          key: formState,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OTPInput(
                                node: _bin1Node,
                                onSaved: (String? value) {
                                  _value += value ?? '';
                                },
                                onChange: (String? value) {
                                  nextFocus(value ?? '', _bin2Node);
                                },
                                autoFocus: true,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              OTPInput(
                                node: _bin2Node,
                                onSaved: (String? value) {
                                  _value += value ?? '';
                                },
                                onChange: (String? value) {
                                  value != null && value.isNotEmpty
                                      ? nextFocus(value, _bin3Node)
                                      : perviousFocus(value ?? '', _bin1Node);
                                },
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              OTPInput(
                                node: _bin3Node,
                                onSaved: (String? value) {
                                  _value += value ?? '';
                                },
                                onChange: (String? value) {
                                  value != null && value.isNotEmpty
                                      ? nextFocus(value, _bin4Node)
                                      : perviousFocus(value ?? '', _bin2Node);
                                },
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              OTPInput(
                                node: _bin4Node,
                                onSaved: (String? value) {
                                  _value += value ?? '';
                                },
                                onChange: (String? value) {
                                  value != null && value.isNotEmpty
                                      ? _bin4Node.unfocus()
                                      : perviousFocus(value ?? '', _bin3Node);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        const Text(
                          'اعمل مسح لل Qrcode',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: weevoGreyLighter,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 8),
                        QrCodeScanWidget(
                          onDataCallback: widget.onDataCallback,
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
              _state == 1 ? const SizedBox(height: 8) : Container(),
              _state == 1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                weevoPrimaryBlueColor),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          onPressed: () {
                            MagicRouter.pop();
                          },
                          child: const Text(
                            'إلغاء',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        horizontalSpace(10),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              weevoPrimaryOrangeColor,
                            ),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (_state == 1) {
                              formState.currentState!.save();
                              widget.onDataCallback(_value);
                              _value = '';
                              formState.currentState!.reset();
                            }
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
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
