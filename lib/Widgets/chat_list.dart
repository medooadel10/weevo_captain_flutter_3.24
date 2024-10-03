import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_bubble.dart';

class ChatList extends StatelessWidget {
  final List<QueryDocumentSnapshot> data;
  final ScrollController controller;
  final String conversionId;

  const ChatList({
    super.key,
    required this.data,
    required this.controller,
    required this.conversionId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: controller,
        shrinkWrap: true,
        reverse: true,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int i) =>
            MyChatBubble(data: data[i], conversionId: conversionId));
  }
}
