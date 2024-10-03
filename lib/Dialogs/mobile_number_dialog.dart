import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utilits/colors.dart';
import '../Widgets/edit_text.dart';

class MobileNumberDialog extends StatefulWidget {
  final Function(String) phoneClick;

  const MobileNumberDialog({
    super.key,
    required this.phoneClick,
  });

  @override
  State<MobileNumberDialog> createState() => _MobileNumberDialogState();
}

class _MobileNumberDialogState extends State<MobileNumberDialog> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  late TextEditingController myOfferController;

  @override
  void initState() {
    super.initState();
    myOfferController = TextEditingController();
  }

  @override
  void dispose() {
    myOfferController.dispose();
    super.dispose();
  }

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
          child: Form(
            key: formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                EditText(
                  controller: myOfferController,
                  readOnly: false,
                  upperTitle: false,
                  type: TextInputType.number,
                  action: TextInputAction.done,
                  isPhoneNumber: true,
                  isPassword: false,
                  validator: (String? output) =>
                      output == null || output.isEmpty
                          ? 'من فضلك أدخل رقم المحفظة الخاصة بك'
                          : '',
                  labelText: 'رقم المحفظة الخاص بك',
                ),
                SizedBox(
                  height: 10.h,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formState.currentState!.validate()) {
                      Navigator.pop(context);
                      widget.phoneClick(myOfferController.text);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      weevoPrimaryBlueColor,
                    ),
                    padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 30.0)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17.0.r),
                      ),
                    ),
                  ),
                  child: Text(
                    'تأكيد',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 12.0.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
