import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Providers/auth_provider.dart';
import '../Screens/image_display_screen.dart';
import '../Utilits/colors.dart';
import '../core/networking/api_constants.dart';
import '../core/widgets/custom_image.dart';

class MyChatBubble extends StatefulWidget {
  final QueryDocumentSnapshot data;
  final String conversionId;

  const MyChatBubble({
    super.key,
    required this.data,
    required this.conversionId,
  });

  @override
  State<MyChatBubble> createState() => _MyChatBubbleState();
}

class _MyChatBubbleState extends State<MyChatBubble> {
  Set<Marker> markers = {};
  bool _showDate = false;

  @override
  void initState() {
    super.initState();
    FGBGEvents.instance.stream.listen((event) {
      if (event == FGBGType.foreground) {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    log(widget.data['peerImageUrl']);
    log(widget.data['currentUserImage']);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    if (!widget.data['read'] &&
        widget.data['peerNationalId'] == authProvider.getNationalId) {
      updateMessageRead(widget.data, widget.conversionId);
    }
    final isMe = widget.data['currentNationalId'] == authProvider.getNationalId;
    return GestureDetector(
      onTap: () {
        setState(() {
          _showDate = !_showDate;
        });
      },
      child: Padding(
        padding: isMe
            ? const EdgeInsets.only(right: 16.0)
            : const EdgeInsets.only(left: 16.0),
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            isMe
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: (widget.data['currentUserImage'] != null &&
                              widget.data['currentUserImage'] != '')
                          ? CustomImage(
                              image: widget.data['currentUserImage']
                                      .contains(ApiConstants.baseUrl)
                                  ? widget.data['currentUserImage']
                                  : '${ApiConstants.baseUrl}${widget.data['currentUserImage']}',
                              height: 45.0,
                              width: 45.0,
                              radius: 25,
                            )
                          : Image.asset(
                              'assets/images/profile_picture.png',
                              height: 45.0,
                              width: 45.0,
                            ),
                    ),
                  )
                : Container(),
            isMe
                ? SizedBox(
                    width: 6.w,
                  )
                : Container(),
            Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: widget.data['type'] == 0
                      ? Container(
                          constraints: const BoxConstraints(
                            maxWidth: 200,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: isMe
                                  ? const Radius.circular(0.0)
                                  : const Radius.circular(20.0),
                              bottomRight: const Radius.circular(20.0),
                              bottomLeft: const Radius.circular(20.0),
                              topLeft: !isMe
                                  ? const Radius.circular(0.0)
                                  : const Radius.circular(20.0),
                            ),
                            color:
                                isMe ? weevoPrimaryBlueColor : Colors.grey[300],
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 50.0),
                          child: Text(
                            widget.data['content'],
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : widget.data['type'] == 1
                          ? GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ImageDisplayScreen.id,
                                    arguments: widget.data['content']);
                              },
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(16.0),
                                    bottomRight: Radius.circular(16.0),
                                    bottomLeft: Radius.circular(16.0),
                                    topLeft: Radius.circular(16.0),
                                  ),
                                  child: Image.network(
                                    widget.data['content'],
                                    loadingBuilder: (BuildContext? context,
                                        Widget? child,
                                        ImageChunkEvent? loadingProgress) {
                                      return Container(
                                        decoration: const BoxDecoration(
                                          color: Color(0xffE8E8E8),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        width: 200,
                                        height: 200,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color:
                                                Theme.of(context!).primaryColor,
                                            value: loadingProgress!
                                                            .expectedTotalBytes !=
                                                        null &&
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, object, stackTrace) =>
                                            Material(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      child: Image.asset(
                                        'images/img_not_available.jpeg',
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.fill,
                                  )),
                            )
                          : SizedBox(
                              height: 200,
                              width: 200,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(16.0),
                                  topLeft: Radius.circular(16.0),
                                ),
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                          double.parse(widget.data['content']
                                              .toString()
                                              .split('-')[0]),
                                          double.parse(widget.data['content']
                                              .toString()
                                              .split('-')[1])),
                                      zoom: 15.0),
                                  zoomGesturesEnabled: false,
                                  zoomControlsEnabled: false,
                                  scrollGesturesEnabled: false,
                                  mapType: MapType.normal,
                                  mapToolbarEnabled: false,
                                  compassEnabled: false,
                                  buildingsEnabled: false,
                                  markers: markers,
                                  onTap: (LatLng l) async {
                                    String url =
                                        "google.navigation:q=${double.parse(widget.data['content'].toString().split('-')[0])},${double.parse(widget.data['content'].toString().split('-')[1])}";
                                    await launchUrl(Uri.parse(url));
                                  },
                                  onMapCreated: (GoogleMapController c) async {
                                    markers.clear();
                                    ByteData originByteData =
                                        await DefaultAssetBundle.of(context)
                                            .load(
                                                "assets/images/destination.png");
                                    var currentLocation =
                                        originByteData.buffer.asUint8List();
                                    markers.add(Marker(
                                      markerId: const MarkerId("MarkerId"),
                                      infoWindow:
                                          const InfoWindow(title: 'الكابتن'),
                                      onTap: () async {
                                        String url =
                                            "google.navigation:q=${double.parse(widget.data['content'].toString().split('-')[0])},${double.parse(widget.data['content'].toString().split('-')[1])}";
                                        await launchUrl(Uri.parse(url));
                                      },
                                      position: LatLng(
                                          double.parse(widget.data['content']
                                              .toString()
                                              .split('-')[0]),
                                          double.parse(widget.data['content']
                                              .toString()
                                              .split('-')[1])),
                                      icon: BitmapDescriptor.bytes(
                                          currentLocation),
                                    ));

                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                ),
                const SizedBox(
                  height: 4.0,
                ),
                _showDate
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: Text(
                          DateFormat('dd/mm/yyyy  hh:mm a')
                              .format(DateTime.parse(widget.data['dateTime'])),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0.sp,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            !isMe
                ? SizedBox(
                    width: 6.w,
                  )
                : Container(),
            !isMe
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: widget.data['currentUserImage'] != null &&
                              widget.data['currentUserImage'] != ''
                          ? CustomImage(
                              image: widget.data['currentUserImage']
                                      .contains(ApiConstants.baseUrl)
                                  ? widget.data['currentUserImage']
                                  : '${ApiConstants.baseUrl}${widget.data['currentUserImage']}',
                              height: 45.0,
                              width: 45.0,
                              radius: 22.5,
                            )
                          : Image.asset(
                              'assets/images/profile_picture.png',
                              height: 45.0,
                              width: 45.0,
                            ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void updateMessageRead(DocumentSnapshot doc, String convoID) async {
    updateLastMessage(doc, convoID);
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('messages')
        .doc(convoID)
        .collection(convoID)
        .get();

    for (int i = 0; i < snapshot.docs.length; i++) {
      if ((await snapshot.docs[i].reference.get())['read'] == false) {
        snapshot.docs[i].reference
            .set(<String, dynamic>{'read': true}, SetOptions(merge: true));
      }
    }
  }

  void updateLastMessage(DocumentSnapshot doc, String convoID) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('messages').doc(convoID);

    await documentReference
        .set(<String, dynamic>{
          'lastMessage': <String, dynamic>{
            'read': true,
            'count': 0,
          },
        }, SetOptions(merge: true))
        .then((dynamic success) {})
        .catchError((dynamic error) {
          log(error);
        });
  }
}
