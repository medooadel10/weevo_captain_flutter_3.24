import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/Storage/shared_preference.dart';

import '../../Dialogs/action_dialog.dart';
import '../../Models/weevo_user.dart';
import '../../Providers/auth_provider.dart';
import '../../Utilits/colors.dart';
import '../../Utilits/constants.dart';
import '../../Widgets/area_item.dart';
import '../../Widgets/weevo_button.dart';
import '../../main.dart';

class SignUpChooseArea extends StatefulWidget {
  static const String id = 'ChooseArea';

  const SignUpChooseArea({super.key});

  @override
  State<SignUpChooseArea> createState() => _SignUpChooseAreaState();
}

class _SignUpChooseAreaState extends State<SignUpChooseArea> {
  bool isExpanded = true;
  late AuthProvider authProvider;
  bool isChecked = false;
  List<int>? ints;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: weevoWhiteWithSilver,
              borderRadius: BorderRadius.circular(
                20.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/area_icon.png',
                  width: 40.0.w,
                  height: 40.0.h,
                ),
                Expanded(
                  child: Text(
                    'اضغط علي اسم المحافظة ثم اسم المدينة \n ليتم اختيارها لك في الطلبات المتاحة',
                    style: TextStyle(
                      fontSize: 16.0.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: authProvider.chosenStateEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'اضف مناطق التوصيل الخاصة بك ',
                              strutStyle: const StrutStyle(
                                forceStrutHeight: true,
                              ),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0.sp,
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: authProvider.chosenStates.length,
                          itemBuilder: (context, x) => AreaItem(
                            uploadState: authProvider.chosenStates[x],
                          ),
                        ),
                ),
                WeevoButton(
                  isStable: true,
                  color: authProvider.chosenStateEmpty
                      ? Colors.grey
                      : weevoPrimaryOrangeColor,
                  onTap: authProvider.chosenStateEmpty
                      ? () {}
                      : () async {
                          ints = [];
                          for (var e in authProvider.chosenStates) {
                            for (var i in e.chosenCities) {
                              ints?.add(i.id!);
                            }
                          }
                          authProvider.setLoading(true);
                          await authProvider.getFirebaseToken();
                          await authProvider.createNewUser(
                            WeevoUser(
                              firstName: authProvider.firstName,
                              lastName: authProvider.lastName,
                              phoneNumber: authProvider.userPhone,
                              emailAddress: authProvider.userEmail,
                              gender: authProvider.userGender,
                              imageUrl: authProvider.userPhoto,
                              password: authProvider.userPassword,
                              firebaseNotificationToken: authProvider.fcmToken,
                              nationalIdPhotoBack:
                                  authProvider.nationalIdPhotoBack,
                              userFirebaseId: authProvider.userFirebaseId,
                              nationalIdPhotoFront:
                                  authProvider.nationalIdPhotoFront,
                              nationalIdNumber: authProvider.nationalIdNumber,
                              citiesIds: ints,
                              vehicleModel: authProvider.vehicleModel,
                              vehicleColor: authProvider.vehicleColor,
                              vehiclePlate: authProvider.vehiclePlate,
                              deliveryMethod: authProvider.deliveryMethod,
                            ),
                          );
                          if (authProvider.createNewUserState ==
                              NetworkState.success) {
                            await FirebaseFirestore.instance
                                .collection('courier_users')
                                .doc(authProvider.userId.toString())
                                .set({
                              'id': authProvider.userId,
                              'email': authProvider.userEmail,
                              'name':
                                  '${authProvider.firstName} ${authProvider.lastName}',
                              'imageUrl': authProvider.userPhoto ?? '',
                              'national_id': authProvider.userPhone,
                              'fcmToken': authProvider.fcmToken,
                            });
                            await WeevoCaptain.facebookAppEvents
                                .logCompletedRegistration(
                                    registrationMethod: 'Courier Registered');
                            await authProvider.verifyPhoneNumber();
                          } else {
                            authProvider.setLoading(false);
                            showDialog(
                              context: navigator.currentContext!,
                              builder: (context) => ActionDialog(
                                content: authProvider.createNewUserMessage,
                                onCancelClick: () {
                                  Navigator.pop(context);
                                },
                                cancelAction: 'حسناً',
                              ),
                            );
                          }
                        },
                  title: 'التالي',
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
