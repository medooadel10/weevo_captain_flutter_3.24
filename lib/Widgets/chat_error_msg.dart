import 'package:flutter/material.dart';

class ChatErrorMessage extends StatelessWidget {
  const ChatErrorMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('تأكد من التصال بالانترنت'),
    );
  }
}
