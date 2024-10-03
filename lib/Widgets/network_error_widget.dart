import 'package:flutter/material.dart';

import '../Utilits/colors.dart';

class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback onRetryCallback;

  const NetworkErrorWidget({
    super.key,
    required this.onRetryCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('برجاء المحاولة مرة اخري'),
          TextButton(
            onPressed: onRetryCallback,
            style: ButtonStyle(
              foregroundColor:
                  WidgetStateProperty.all<Color>(weevoPrimaryOrangeColor),
            ),
            child: const Text('حاول مرة اخري'),
          )
        ],
      ),
    );
  }
}
