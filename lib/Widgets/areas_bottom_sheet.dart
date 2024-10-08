import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Dialogs/action_dialog.dart';
import '../Models/city.dart';
import '../Models/state.dart';
import '../Models/upload_state.dart';
import '../Providers/auth_provider.dart';
import '../Utilits/colors.dart';
import 'city_item.dart';
import 'edit_text.dart';

class CityBottomSheet extends StatefulWidget {
  final int stateId;

  const CityBottomSheet({
    super.key,
    required this.stateId,
  });

  @override
  State<CityBottomSheet> createState() => _CityBottomSheetState();
}

class _CityBottomSheetState extends State<CityBottomSheet> {
  List<UploadState> previousChosenCities = [];
  late AuthProvider _authProvider;
  late States _state;
  late List<Cities> _cities;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _state = _authProvider.getStateById(widget.stateId);
    _cities = _state.cities ?? [];
    previousChosenCities = _authProvider.chosenStates;
    _authProvider.populateNewCities(widget.stateId);
    _authProvider.checkAllFirstTime(_authProvider.isCheckAllCities(_state));
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return PopScope(
      onPopInvokedWithResult: (value, result) async {
        if (authProvider.chosenCities.length >
            authProvider.getChosenStatesCities(_state)) {
          showDialog(
            context: context,
            builder: (context) => ActionDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  20.0,
                ),
              ),
              content: 'لن يتم أضافة تعدبلاتك الجديدة\nهل تود ذلك ؟',
              onApproveClick: () {
                if (previousChosenCities.isNotEmpty) {
                  authProvider.addAllChosenCities(previousChosenCities);
                }
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
          if (authProvider.chosenCities.isNotEmpty) {
            authProvider.chosenCities.clear();
          }
          Navigator.pop(context);
        }
      },
      canPop: true,
      child: Stack(children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                child: EditText(
                  readOnly: false,
                  suffix: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  validator: (String? value) {
                    return null;
                  },
                  onSave: (String? value) {},
                  onChange: (String? value) {},
                  labelText: 'ابحث عن المنطقة',
                  isFocus: false,
                  focusNode: FocusNode(),
                  radius: 12.0,
                  isPassword: false,
                  isPhoneNumber: false,
                  shouldDisappear: false,
                  upperTitle: false,
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                onTap: () {
                  if (authProvider.checkAllAreas) {
                    authProvider.removeAllCities();
                  } else {
                    authProvider.addAllCities(_cities);
                  }
                  authProvider.checkAllToggle();
                  for (var element in _cities) {
                    setState(() {
                      element.checked = authProvider.checkAllAreas;
                    });
                  }
                },
                title: const Text(
                  'كل المناطق',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                ),
                trailing: authProvider.checkAllAreas
                    ? const CircleAvatar(
                        radius: 17.0,
                        backgroundColor: weevoLightPurpleColor,
                        child: Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                      )
                    : Container(width: 40.0.w),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _cities.length,
                  itemBuilder: (context, i) => CityItem(
                    cities: _cities[i],
                    state: _state,
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 20.0,
              right: 20.0,
            ),
            child: FloatingActionButton(
              onPressed: () {
                if (authProvider.chosenCities.isNotEmpty) {
                  authProvider.addCity(
                    UploadState(
                      id: _state.id ?? 0,
                      name: _state.name ?? '',
                      chosenCities: [...authProvider.chosenCities],
                    ),
                    false,
                  );
                  authProvider.chosenCities.clear();
                } else {
                  authProvider.clearChosenStatus(_state.id ?? 0);
                }
                Navigator.pop(context);
              },
              backgroundColor: weevoPrimaryOrangeColor,
              child: const Icon(
                Icons.done,
                color: Colors.white,
              ),
            ),
          ),
        )
      ]),
    );
  }
}
