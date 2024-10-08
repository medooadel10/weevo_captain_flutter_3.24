import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/Storage/shared_preference.dart';
import 'package:weevo_captain_app/core/router/router.dart';

import '../Dialogs/action_dialog.dart';
import '../Models/city.dart';
import '../Models/state.dart';
import '../Providers/auth_provider.dart';
import '../Utilits/colors.dart';
import '../Widgets/areas_bottom_sheet.dart';
import '../Widgets/connectivity_widget.dart';
import '../Widgets/loading_widget.dart';
import '../Widgets/state_bottom_sheet.dart';

class SignUp extends StatefulWidget {
  static const String id = 'SIGN_UP';

  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  List<States>? states;
  List<Cities>? cities;
  States? currentState;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return LoadingWidget(
      isLoading: authProvider.isLoading,
      child: PopScope(
        onPopInvokedWithResult: (value, result) async {
          if (!authProvider.isLoading) {
            switch (authProvider.screenIndex) {
              case 0:
                if (authProvider.firstName != null &&
                    authProvider.lastName != null) {
                  showDialog(
                    context: context,
                    builder: (context) => ActionDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      content: 'سيتم مسح كل البيانات التي تم ملؤها\nهل تود ذلك',
                      onApproveClick: () {
                        authProvider.reset();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      onCancelClick: () {
                        Navigator.pop(context);
                      },
                      approveAction: 'نعم',
                      cancelAction: 'لا',
                    ),
                  );
                } else {
                  MagicRouter.pop();
                }
                break;
              case 1:
                authProvider.updateScreen(0);
                break;
              case 2:
                authProvider.updateScreen(1);
                break;
              case 3:
                authProvider.updateScreen(2);
                break;
              // case 4:
              //   authProvider.updateScreen(3);
              //   break;
            }
          }
        },
        canPop: true,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ConnectivityWidget(
            callback: () {},
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                actions: [
                  if (authProvider.screenIndex == 3)
                    GestureDetector(
                      onTap: () async {
                        log('${authProvider.states}');
                        await showModalBottomSheet(
                          context: context,
                          isDismissible: false,
                          enableDrag: false,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                              // 20.0,
                            ),
                          ),
                          builder: (context) => StateBottomSheet(
                            states: authProvider.states,
                            onPress: (States state) {
                              currentState = state;
                              cities = state.cities;
                              Navigator.pop(context);
                            },
                          ),
                        );
                        if (currentState != null) {
                          await showModalBottomSheet(
                            context: navigator.currentContext!,
                            isDismissible: false,
                            enableDrag: false,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                                // 20.0,
                              ),
                            ),
                            builder: (context) => CityBottomSheet(
                              stateId: currentState!.id!,
                            ),
                          );
                          currentState = null;
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: weevoPrimaryOrangeColor),
                        width: 60.0,
                        margin: const EdgeInsets.symmetric(
                          vertical: 14.0,
                          horizontal: 6.0,
                        ),
                        child: const Center(
                          child: Text(
                            'أضافة',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
                centerTitle: authProvider.screenIndex == 3 ? true : false,
                leading: IconButton(
                  onPressed: () {
                    if (!authProvider.isLoading) {
                      switch (authProvider.screenIndex) {
                        case 0:
                          if (authProvider.firstName != null &&
                              authProvider.lastName != null) {
                            showDialog(
                              context: context,
                              builder: (context) => ActionDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    20.0,
                                  ),
                                ),
                                content:
                                    'سيتم مسح كل البيانات التي تم ملؤها\nهل تود ذلك',
                                onApproveClick: () {
                                  authProvider.reset();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                onCancelClick: () {
                                  Navigator.pop(context);
                                },
                                approveAction: 'نعم',
                                cancelAction: 'لا',
                              ),
                            );
                          } else {
                            Navigator.pop(context);
                          }
                          break;
                        case 1:
                          authProvider.updateScreen(0);
                          break;
                        case 2:
                          authProvider.updateScreen(1);
                          break;
                        case 3:
                          authProvider.updateScreen(2);
                          break;
                        // case 4:
                        //   authProvider.updateScreen(3);
                        //   break;
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_outlined,
                  ),
                ),
                title: Text(
                  authProvider.screenIndex == 0
                      ? 'التسجيل'
                      : authProvider.screenIndex == 1
                          ? 'تفعيل رقم الهاتف'
                          : authProvider.screenIndex == 2
                              ? 'صورة البطاقة'
                              : authProvider.screenIndex == 3
                                  ? 'معلومات المركبة'
                                  : 'مناطق التوصيل',
                ),
              ),
              backgroundColor: Colors.white,
              body: authProvider.currentPage,
            ),
          ),
        ),
      ),
    );
  }
}
