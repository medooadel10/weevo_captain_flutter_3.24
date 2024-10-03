import 'package:flutter/material.dart';

import '../Utilits/colors.dart';

class DoneDialog extends StatelessWidget {
  final VoidCallback callback;
  final String content;

  const DoneDialog({
    super.key,
    required this.callback,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
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
                Text(
                  content,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.center,
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
                  onPressed: callback,
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
          )),
    );
  }
}
