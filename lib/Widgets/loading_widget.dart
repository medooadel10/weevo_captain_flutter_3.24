import 'package:flutter/material.dart';

import '../Utilits/colors.dart';

class LoadingWidget extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const LoadingWidget({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        isLoading
            ? Container(
                color: Colors.black.withOpacity(
                  0.6,
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      weevoPrimaryOrangeColor,
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
