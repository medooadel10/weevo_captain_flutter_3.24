import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/auth_provider.dart';
import '../../Providers/profile_provider.dart';
import '../../Utilits/constants.dart';
import '../../Widgets/connectivity_widget.dart';
import '../../Widgets/loading_widget.dart';

class ChangeYourPhone extends StatefulWidget {
  static const String id = 'Change Phone Number';

  const ChangeYourPhone({super.key});

  @override
  State<ChangeYourPhone> createState() => _ChangeYourPhoneState();
}

class _ChangeYourPhoneState extends State<ChangeYourPhone> {
  @override
  void initState() {
    super.initState();
    ProfileProvider.listenFalse(context).phoneNumberController.clear();
    ProfileProvider.listenFalse(context).pinController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ConnectivityWidget(
        callback: () {},
        child: LoadingWidget(
          isLoading: authProvider.updatePhoneState == NetworkState.waiting,
          child: PopScope(
            onPopInvokedWithResult: (value, result) async {
              switch (profileProvider.currentIndex) {
                case 0:
                  Navigator.pop(context);
                  break;
                case 1:
                  profileProvider.setCurrentIndex(0);
                  break;
              }
            },
            canPop: false,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    switch (profileProvider.currentIndex) {
                      case 0:
                        Navigator.pop(context);
                        break;
                      case 1:
                        profileProvider.setCurrentIndex(0);
                        break;
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_outlined,
                  ),
                ),
                title: profileProvider.currentIndex == 0
                    ? const Text(
                        'تغيير رقم الهاتف',
                      )
                    : Container(),
              ),
              body: profileProvider.widget,
            ),
          ),
        ),
      ),
    );
  }
}
