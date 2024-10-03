import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/Storage/shared_preference.dart';

import '../Dialogs/action_dialog.dart';
import '../Models/city.dart';
import '../Models/state.dart';
import '../Models/upload_state.dart';
import '../Providers/auth_provider.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import '../Widgets/area_item.dart';
import '../Widgets/areas_bottom_sheet.dart';
import '../Widgets/connectivity_widget.dart';
import '../Widgets/network_error_widget.dart';
import '../Widgets/state_bottom_sheet.dart';
import '../Widgets/weevo_button.dart';

class DeliveryAreas extends StatefulWidget {
  static const String id = 'Delivery_Areas';

  const DeliveryAreas({super.key});

  @override
  State<DeliveryAreas> createState() => _DeliveryAreasState();
}

class _DeliveryAreasState extends State<DeliveryAreas> {
  bool isExpanded = true;
  late AuthProvider _authProvider;
  bool isChecked = false;
  List<int>? ints;
  List<States>? states;
  List<Cities>? cities;
  States? currentState;
  List<Cities> providedCities = [];
  List<UploadState>? uploadedCities;

  void getData() async {
    await _authProvider.getCurrentUserdata(false);
    check(
        ctx: navigator.currentContext!,
        auth: _authProvider,
        state: _authProvider.updateAreasState!);
  }

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ConnectivityWidget(
        callback: () {},
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'مناطق التوصيل',
            ),
            actions: [
              GestureDetector(
                onTap: () async {
                  await showModalBottomSheet(
                    context: context,
                    isDismissible: false,
                    enableDrag: false,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
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
                  await showModalBottomSheet(
                    context: navigator.currentContext!,
                    isDismissible: false,
                    enableDrag: false,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    builder: (context) => CityBottomSheet(
                      stateId: currentState!.id!,
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  width: 80.0,
                  height: 20.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      authProvider.isLoading
                          ? Container()
                          : const Text(
                              'تعديل',
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: weevoWhiteWithSilver,
          body: authProvider.updateAreasState == NetworkState.waiting
              ? const Center(
                  child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(weevoPrimaryOrangeColor),
                ))
              : authProvider.updateAreasState == NetworkState.success
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                        vertical: size.height * 0.02,
                      ),
                      height: size.height - 80.0,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: authProvider.chosenStateEmpty
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/icon_location.png',
                                        width: 30.0,
                                        height: 30.0,
                                      ),
                                      SizedBox(
                                        width: 10.0.w,
                                      ),
                                      const Text(
                                        'لا توجد مناطق توصيل خاصة بك',
                                        strutStyle: StrutStyle(
                                          forceStrutHeight: true,
                                        ),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.0,
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
                                    await authProvider.updateAreas(
                                      areasId: ints,
                                    );
                                    if (authProvider.updateAreasState ==
                                        NetworkState.success) {
                                      authProvider.clearChosenAreas();
                                      Navigator.pop(navigator.currentContext!);
                                    } else if (authProvider.updateAreasState ==
                                        NetworkState.error) {
                                      showDialog(
                                          context: navigator.currentContext!,
                                          barrierDismissible: false,
                                          builder: (context) => ActionDialog(
                                                content:
                                                    'حدث خطأ من فضلك حاول مرة اخري',
                                                cancelAction: 'حسناً',
                                                onCancelClick: () {
                                                  Navigator.pop(context);
                                                },
                                              ));
                                    } else if (authProvider.updateAreasState ==
                                        NetworkState.logout) {
                                      check(
                                          ctx: navigator.currentContext!,
                                          auth: authProvider,
                                          state:
                                              authProvider.updateAreasState!);
                                    }
                                  },
                            title: 'حفظ',
                          )
                        ],
                      ),
                    )
                  : NetworkErrorWidget(
                      onRetryCallback: () async {
                        await _authProvider.getCurrentUserdata(true);
                      },
                    ),
        ),
      ),
    );
  }
}
