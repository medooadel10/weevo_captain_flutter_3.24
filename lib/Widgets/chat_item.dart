import 'dart:async';
import 'dart:developer';

import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Models/chat_data.dart';
import '../Providers/auth_provider.dart';
import '../Screens/chat_screen.dart';
import '../Utilits/colors.dart';
import '../core/widgets/custom_image.dart';

class ChatItem extends StatefulWidget {
  final QueryDocumentSnapshot data;

  const ChatItem({super.key, required this.data});

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  String? peerId,
      peerImageUrl,
      peerUsername,
      currentUserId,
      currentUserImage,
      currentUsername,
      currentNationalId,
      peerNationalId;
  int? shipmentId;
  late AuthProvider _authProvider;
  late CollectionReference messages;
  String? groupChatId;
  StreamSubscription? stream;
  String? _currentStatus;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    getData();
    if (currentNationalId.hashCode >= peerNationalId.hashCode) {
      groupChatId = '$currentNationalId-$peerNationalId-$shipmentId';
    } else {
      groupChatId = '$peerNationalId-$currentNationalId-$shipmentId';
    }
    messages = FirebaseFirestore.instance
        .collection('messages/$groupChatId/$groupChatId/');
    FirebaseFirestore.instance
        .collection('locations')
        .doc(groupChatId)
        .snapshots()
        .listen((data) {
      if (data.exists) {
        setState(() {
          _currentStatus = data['status'];
        });
      }
    });
  }

  void getData() async {
    if (widget.data['lastMessage']['currentNationalId'] ==
        _authProvider.getNationalId) {
      currentUserId = widget.data['lastMessage']['currentUserId'];
      currentNationalId = widget.data['lastMessage']['currentNationalId'];
      peerId = widget.data['lastMessage']['peerId'];
      peerNationalId = widget.data['lastMessage']['peerNationalId'];
      peerUsername = widget.data['lastMessage']['peerUsername'];
      peerImageUrl = widget.data['lastMessage']['peerImageUrl'];
      currentUsername = widget.data['lastMessage']['currentUsername'];
      currentUserImage = widget.data['lastMessage']['currentUserImage'];
      shipmentId = widget.data['lastMessage']['shipmentId'];
    } else {
      peerId = widget.data['lastMessage']['currentUserId'];
      peerNationalId = widget.data['lastMessage']['currentNationalId'];
      currentNationalId = widget.data['lastMessage']['peerNationalId'];
      currentUserId = widget.data['lastMessage']['peerId'];
      currentUsername = widget.data['lastMessage']['peerUsername'];
      currentUserImage = widget.data['lastMessage']['peerImageUrl'];
      peerUsername = widget.data['lastMessage']['currentUsername'];
      peerImageUrl = widget.data['lastMessage']['currentUserImage'];
      shipmentId = widget.data['lastMessage']['shipmentId'];
    }
  }

  @override
  Widget build(BuildContext context) {
    log(_currentStatus ?? '');
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ChatScreen.id,
            arguments: ChatData(
              currentUserNationalId: currentNationalId,
              peerNationalId: peerNationalId,
              currentUserId: currentUserId,
              currentUserName: currentUsername,
              currentUserImageUrl: currentUserImage,
              shipmentId: shipmentId,
              peerId: peerId,
              peerUserName: peerUsername,
              peerImageUrl: peerImageUrl,
            ));
      },
      child: Card(
        margin: const EdgeInsets.all(0.0),
        elevation: 0.0,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 30.0,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: peerImageUrl != null
                          ? CustomImage(
                              image: peerImageUrl,
                              radius: 30,
                              width: double.infinity,
                              height: double.infinity,
                            )
                          : Image.asset('assets/images/courier_chat_icon.jpg')),
                ),
                if (!(_currentStatus == ''))
                  CircleAvatar(
                    maxRadius: 7.3.w,
                    backgroundColor: Colors.white,
                    child: const badges.Badge(
                      child: Icon(
                        Icons.circle,
                        color: Colors.greenAccent,
                      ),
                    ),
                  )
              ],
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'محادثة طلب رقم $shipmentId',
                    style: TextStyle(
                      fontSize: 13.0.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  widget.data['lastMessage']['type'] == 0
                      ? Text(
                          widget.data['lastMessage']['content'],
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey,
                          ),
                        )
                      : widget.data['lastMessage']['type'] == 1
                          ? Row(
                              children: [
                                const Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Text(
                                  'صورة',
                                  style: TextStyle(
                                    fontSize: 14.0.sp,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            )
                          : Row(
                              children: [
                                const Icon(
                                  Icons.location_pin,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Text(
                                  'الموقع',
                                  style: TextStyle(
                                    fontSize: 14.0.sp,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  DateFormat('E', 'ar-EG').format(
                    DateTime.parse(widget.data['lastMessage']['dateTime']),
                  ),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.sp,
                  ),
                ),
                !widget.data['lastMessage']['read'] &&
                        widget.data['lastMessage']['peerId'] == _authProvider.id
                    ? Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: const BoxDecoration(
                          color: weevoPrimaryBlueColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${widget.data['lastMessage']['count']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    : Container(),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
