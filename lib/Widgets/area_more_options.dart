import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dialogs/action_dialog.dart';
import '../Models/upload_state.dart';
import '../Providers/auth_provider.dart';
import '../Utilits/colors.dart';
import 'areas_bottom_sheet.dart';

class AreaMoreOptions extends StatelessWidget {
  final UploadState state;

  const AreaMoreOptions({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 20.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            color: weevoTransWhite,
            elevation: 0.2,
            shadowColor: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12.0,
              ),
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 6.0,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
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
                  builder: (context) => CityBottomSheet(
                    stateId: state.id,
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    Expanded(
                      child: Text(
                        'تعديل المنطقة',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: weevoTransWhite,
            elevation: 0.2,
            shadowColor: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12.0,
              ),
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 6.0,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => ActionDialog(
                    title: 'حذف المنطقة',
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                    ),
                    content: 'هل تود حذف هذه المنطقة',
                    approveAction: 'نعم',
                    onApproveClick: () {
                      authProvider.removeCity(state);
                      Navigator.pop(context);
                    },
                    cancelAction: 'لا',
                    onCancelClick: () {
                      Navigator.pop(context);
                    },
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/delete.png',
                      width: 27.0,
                      height: 27.0,
                    ),
                    const Expanded(
                      child: Text(
                        'حذف المنطقة',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
