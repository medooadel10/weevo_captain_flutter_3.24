import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:weevo_captain_app/Widgets/weevo_button.dart';
import 'package:weevo_captain_app/core/helpers/extensions.dart';
import 'package:weevo_captain_app/core/helpers/toasts.dart';

import '../Utilits/colors.dart';
import '../Widgets/qr_code_scan_widget.dart';
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
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController _pinController = TextEditingController();

  int _state = 0;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

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
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildContentBasedOnState(),
              const SizedBox(height: 8),
              _buildStateSwitcher(),
              const SizedBox(height: 16),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build the state-based content (either QR code scanner or PIN input)
  Widget _buildContentBasedOnState() {
    if (_state == 1) {
      return _buildPinCodeInput();
    } else {
      return _buildQrCodeScanner();
    }
  }

  // Widget for QR code scanner
  Widget _buildQrCodeScanner() {
    return Column(
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
        QrCodeScanWidget(onDataCallback: widget.onDataCallback),
      ],
    );
  }

  // Widget for PIN code input
  Widget _buildPinCodeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'اكتب الكود هنا',
          style: TextStyle(
            fontSize: 18.0.sp,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        PinCodeTextField(
          appContext: context,
          length: 4,
          obscureText: false,
          animationType: AnimationType.fade,
          textStyle: TextStyle(
            fontSize: 18.sp,
            color: Colors.black,
          ),
          hintStyle: TextStyle(
            fontSize: 18.sp,
            color: Colors.black,
          ),
          showCursor: true,
          autoFocus: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enablePinAutofill: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textInputAction: TextInputAction.done,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            activeColor: context.colorScheme.primary,
            selectedColor: context.colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
            fieldHeight: 50.h,
            fieldWidth: 50.w,
            activeFillColor: context.colorScheme.onPrimary,
            selectedFillColor: context.colorScheme.primary,
            disabledColor: Colors.grey.shade700,
            inactiveColor: Colors.grey.shade700,
            inactiveFillColor: context.colorScheme.onPrimary,
          ),
          animationDuration: const Duration(milliseconds: 300),
          enableActiveFill: false,
          controller: _pinController,
          onCompleted: (v) {
            context.unfocus();
            _onConfirmPressed();
          },
          onChanged: (value) {},
          beforeTextPaste: (text) => true,
        ).paddingSymmetric(horizontal: 16.0),
      ],
    );
  }

  // Widget for switching between PIN input and QR scanner
  Widget _buildStateSwitcher() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStateButton(
          isActive: _state == 1,
          assetPath: 'assets/images/dail.png',
          onTap: () {
            setState(
              () => _state = 1,
            );
          },
        ),
        _buildStateButton(
          isActive: _state == 0,
          assetPath: 'assets/images/qr_code.png',
          onTap: () {
            _pinController = TextEditingController();
            setState(() => _state = 0);
          },
        ),
      ],
    );
  }

  // Reusable button widget for switching state
  Widget _buildStateButton({
    required bool isActive,
    required String assetPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: isActive ? Border.all(color: Colors.black, width: 1.5) : null,
        ),
        child: Image.asset(
          assetPath,
          height: 50.0,
          width: 50.0,
        ),
      ),
    );
  }

  // Widget for the action buttons (Confirm/Cancel)
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: WeevoButton(
            onTap: () => MagicRouter.pop(),
            color: weevoPrimaryBlueColor,
            title: 'إلغاء',
          ),
        ),
      ],
    );
  }

  // Handle confirmation action
  void _onConfirmPressed() {
    if (_pinController.text.length == 4) {
      widget.onDataCallback(_pinController.text);
      _pinController.clear();
    } else {
      showToast('يرجى ادخال رمز التحقق', isError: true);
    }
  }
}
