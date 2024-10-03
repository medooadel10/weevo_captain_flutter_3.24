import 'package:flutter/material.dart';

import '../Utilits/colors.dart';

class ChatLoading extends StatelessWidget {
  const ChatLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(weevoPrimaryOrangeColor),
      ),
    );
  }
}
