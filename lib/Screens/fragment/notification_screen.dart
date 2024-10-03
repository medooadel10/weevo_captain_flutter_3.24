import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/core/widgets/custom_image.dart';
import 'package:weevo_captain_app/features/wasully_details/logic/cubit/wasully_details_cubit.dart';

import '../../Providers/auth_provider.dart';
import '../../Utilits/colors.dart';
import '../../Utilits/notification_const.dart';
import '../../Widgets/connectivity_widget.dart';
import '../../core/networking/api_constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cubit = context.read<WasullyDetailsCubit>();
    return Scaffold(
      key: _scaffoldKey,
      body: ConnectivityWidget(
        callback: () {},
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('courier_notifications')
              .doc(authProvider.id)
              .collection(authProvider.id ?? '')
              .orderBy('date_time', descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
            return data.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            weevoPrimaryOrangeColor)),
                  )
                : data.hasData
                    ? data.data!.docs.isEmpty
                        ? const Center(child: Text('لا توجد لديك أشعارات'))
                        : Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: TextButton(
                                  onPressed: () {
                                    data.data!.docs
                                        .where(
                                          (i) => (i['read'] == false),
                                        )
                                        .forEach((element) => element.reference
                                            .set(
                                                <String, dynamic>{'read': true},
                                                SetOptions(merge: true)));
                                  },
                                  child: Text(
                                    'قراءة الكل',
                                    style: TextStyle(
                                        color: weevoPrimaryOrangeColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemBuilder: (BuildContext context, int i) =>
                                      ListTile(
                                    tileColor: data.data!.docs[i]['read']
                                        ? Colors.white
                                        : weevoPrimaryBlueColor
                                            .withOpacity(0.1),
                                    onTap: () {
                                      data.data!.docs[i].reference.set(
                                          <String, dynamic>{'read': true},
                                          SetOptions(merge: true));
                                      notificationNavigation(
                                        _scaffoldKey.currentContext!,
                                        data.data!.docs[i]['type'],
                                        data.data!.docs[i]['data'],
                                        data.data!.docs[i]['title'],
                                        authProvider,
                                        cubit,
                                      );
                                    },
                                    title: Text(
                                      data.data!.docs[i]['title'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    subtitle: Text(
                                      data.data!.docs[i]['body'],
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    leading: data.data!.docs[i]['user_icon'] !=
                                            ''
                                        ? data.data!.docs[i]['user_icon']
                                                .toString()
                                                .contains(ApiConstants.baseUrl)
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                                child: CustomImage(
                                                  image: data.data!.docs[i]
                                                      ['user_icon'],
                                                  height: 50.h,
                                                  width: 50.h,
                                                  radius: 0,
                                                ),
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                                child: CustomImage(
                                                  image:
                                                      '${ApiConstants.baseUrl}${data.data!.docs[i]['user_icon']}',
                                                  height: 50.h,
                                                  width: 50.h,
                                                  radius: 0,
                                                ),
                                              )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            child: Image.asset(
                                              'assets/images/profile_picture.png',
                                            ),
                                          ),
                                    trailing: data.data!.docs[i]['type'] ==
                                            'chat'
                                        ? Image.asset(
                                            'assets/images/weevo_chat_icon.png',
                                            height: 25.0,
                                            width: 25.0,
                                          )
                                        : data.data!.docs[i]['type'] ==
                                                    'shipment' ||
                                                data.data!.docs[i]['type'] ==
                                                    'cancel_shipment'
                                            ? Image.asset(
                                                'assets/images/shipment_car_details.png',
                                                height: 25.0,
                                                width: 25.0,
                                              )
                                            : data.data!.docs[i]['type'] ==
                                                    'tracking'
                                                ? Image.asset(
                                                    'assets/images/tracking_icon.png',
                                                    height: 25.0,
                                                    width: 25.0,
                                                  )
                                                : const Icon(
                                                    Icons.notifications,
                                                  ),
                                  ),
                                  itemCount: data.data!.docs.length,
                                ),
                              ),
                            ],
                          )
                    : const Center(child: Text('لا توجد لديك أشعارات'));
          },
        ),
      ),
    );
  }
}
