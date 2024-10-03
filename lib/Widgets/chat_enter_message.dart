import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../Dialogs/image_picker_dialog.dart';
import '../Models/chat_data.dart';
import '../Providers/auth_provider.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import 'edit_text.dart';

class ChatEnterMessage extends StatefulWidget {
  final CollectionReference message;
  final ChatData chatData;
  final String conversionId;
  final ScrollController controller;

  const ChatEnterMessage({
    super.key,
    required this.message,
    required this.chatData,
    required this.conversionId,
    required this.controller,
  });

  @override
  State<ChatEnterMessage> createState() => _ChatEnterMessageState();
}

class _ChatEnterMessageState extends State<ChatEnterMessage> {
  late TextEditingController sendController;
  late FocusNode sendNode;
  bool _isLoading = false;
  int? type;

  @override
  void initState() {
    super.initState();
    sendController = TextEditingController();
    sendNode = FocusNode();
  }

  @override
  void dispose() {
    sendController.dispose();
    sendNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              if (sendController.text.trim().isNotEmpty) {
                String messageContent = sendController.text;
                sendController.clear();
                await auth.sendMessage(messageContent, Type.text.index,
                    widget.chatData, widget.conversionId);
                widget.controller.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.bounceIn,
                );
              }
            },
            child: CircleAvatar(
              radius: 25.0,
              backgroundColor: weevoPrimaryBlueColor,
              child: Transform.rotate(
                angle: pi,
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 5.0,
          ),
          Expanded(
            child: EditText(
              fillColor: Colors.white,
              radius: 20,
              maxLines: 5,
              type: TextInputType.multiline,
              borderSide: const BorderSide(width: 0.2),
              isPassword: false,
              isPhoneNumber: false,
              readOnly: false,
              hintColor: Colors.grey,
              controller: sendController,
              focusNode: sendNode,
              hintText: 'أكتب رسالتك هنا',
            ),
          ),
          const SizedBox(
            width: 5.0,
          ),
          GestureDetector(
            onTap: () async {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0))),
                builder: (context) => ImagePickerDialog(
                  onImageReceived: (XFile file) async {
                    Navigator.pop(context);
                    setState(() => _isLoading = true);
                    TaskSnapshot? task = await uploadImage(
                        uid: DateTime.now().millisecondsSinceEpoch.toString(),
                        path: file.path);
                    if (task == null) {
                      setState(() => _isLoading = false);
                      return;
                    }
                    String imageUrl = await task.ref.getDownloadURL();
                    setState(() => _isLoading = false);
                    await auth.sendMessage(imageUrl, Type.image.index,
                        widget.chatData, widget.conversionId);
                    widget.controller.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.bounceIn,
                    );
                  },
                ),
              );
            },
            child: CircleAvatar(
              radius: 25.0,
              backgroundColor: weevoPrimaryBlueColor,
              child: _isLoading
                  ? const SpinKitDoubleBounce(
                      color: Colors.white,
                      size: 20.0,
                    )
                  : const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
