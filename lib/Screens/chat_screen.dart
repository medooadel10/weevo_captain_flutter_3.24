import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/core/widgets/custom_image.dart';

import '../Models/chat_data.dart';
import '../Providers/auth_provider.dart';
import '../Utilits/colors.dart';
import '../Widgets/chat_enter_message.dart';
import '../Widgets/chat_error_msg.dart';
import '../Widgets/chat_list.dart';
import '../Widgets/chat_loading.dart';
import '../Widgets/connectivity_widget.dart';
import '../core/networking/api_constants.dart';
import '../core/router/router.dart';
import '../features/shipment_details/ui/shipment_details_screen.dart';
import 'home.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'ChatScreen';
  final ChatData chatData;

  const ChatScreen({super.key, required this.chatData});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _controller;
  late ScrollController _listController;
  CollectionReference? messages;
  late FocusNode _chatFieldNode;
  bool isFocused = false;
  String? groupChatId;
  late AuthProvider _authProvider;
  StreamSubscription? stream;
  String? _currentStatus;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _authProvider.setCurrentWidget(widget.runtimeType.toString());

    // _shipmentProvider = Provider.of<ShipmentProvider>(context, listen: false);
    // debugPrint(_shipmentProvider.shipmentById.merchant
    //     .phone);
    initializeDateFormatting('ar_EG');
    _controller = TextEditingController();
    _chatFieldNode = FocusNode();
    _listController = ScrollController();
    _chatFieldNode.addListener(() {
      isFocused = _chatFieldNode.hasFocus;
    });
    if (_authProvider.fromOutsideNotification) {
      groupChatId = widget.chatData.conversionId;
    } else {
      if (widget.chatData.currentUserNationalId.hashCode >=
          widget.chatData.peerNationalId.hashCode) {
        groupChatId =
            '${widget.chatData.currentUserNationalId}-${widget.chatData.peerNationalId}-${widget.chatData.shipmentId}';
      } else {
        groupChatId =
            '${widget.chatData.peerNationalId}-${widget.chatData.currentUserNationalId}-${widget.chatData.shipmentId}';
      }
    }
    messages = FirebaseFirestore.instance
        .collection('messages/$groupChatId/$groupChatId/');
    FirebaseFirestore.instance
        .collection('locations')
        .doc(groupChatId)
        .snapshots()
        .listen((data) {
      if (data.exists) {
        if (mounted) {
          setState(() {
            _currentStatus = data['status'];
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _authProvider.setCurrentWidget('');
    _controller.dispose();
    _chatFieldNode.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);
    // final shipmentProvider = Provider.of<ShipmentProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        if (_authProvider.fromOutsideNotification) {
          _authProvider.setFromOutsideNotification(false);
          Navigator.pushReplacementNamed(context, Home.id);
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ConnectivityWidget(
          callback: () {},
          child: Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    if (_authProvider.fromOutsideNotification) {
                      _authProvider.setFromOutsideNotification(false);
                      Navigator.pushReplacementNamed(context, Home.id);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_outlined,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(22.5),
                            child: widget.chatData.peerImageUrl != null &&
                                    widget.chatData.peerImageUrl!.isNotEmpty
                                ? CustomImage(
                                    image: widget.chatData.peerImageUrl!
                                            .contains(ApiConstants.baseUrl)
                                        ? widget.chatData.peerImageUrl!
                                        : '${ApiConstants.baseUrl}${widget.chatData.peerImageUrl}',
                                    height: 45.0,
                                    width: 45.0,
                                  )
                                : Image.asset(
                                    'assets/images/profile_picture.png',
                                    height: 45.0,
                                    width: 45.0,
                                  ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            widget.chatData.peerUserName!,
                            style:
                                const TextStyle(color: weevoPrimaryOrangeColor),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        MagicRouter.navigateTo(
                          ShipmentDetailsScreen(
                              id: widget.chatData.shipmentId!),
                        );
                      },
                      child: Image.asset(
                        'assets/images/circle_truck.png',
                        height: 32.h,
                        width: 32.w,
                      ),
                    ),
                  ],
                )),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: messages!
                        .orderBy('dateTime', descending: true)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot data) =>
                        data.connectionState == ConnectionState.waiting
                            ? const ChatLoading()
                            : data.hasError
                                ? const ChatErrorMessage()
                                : data.data.docs.length == 0
                                    ? const Center(child: Text('لا توجد رسائل'))
                                    : ChatList(
                                        conversionId: groupChatId!,
                                        data: data.data.docs,
                                        controller: _listController),
                  ),
                ),
                _currentStatus == ''
                    ? Container()
                    : ChatEnterMessage(
                        message: messages!,
                        chatData: widget.chatData,
                        conversionId: groupChatId!,
                        controller: _listController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
