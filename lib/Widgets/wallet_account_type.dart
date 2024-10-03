import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Models/account_type.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';

class WalletAccountType extends StatelessWidget {
  final Function onItemClick;
  final int selectedItem;

  const WalletAccountType({
    super.key,
    required this.onItemClick,
    required this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'نوع الحساب',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Column(
            children: accountTypes
                .map(
                  (AccountType item) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 2.0,
                      child: ListTile(
                        leading: Image.asset(
                          item.image,
                          width: 30.0,
                          height: 30.0,
                        ),
                        trailing: selectedItem == accountTypes.indexOf(item)
                            ? const SizedBox(
                                width: 20.0,
                                height: 20.0,
                                child: Icon(
                                  Icons.done,
                                  color: weevoPrimaryOrangeColor,
                                ),
                              )
                            : const SizedBox(
                                width: 20.0,
                                height: 20.0,
                              ),
                        onTap: () => onItemClick(
                          item.name,
                          accountTypes.indexOf(item),
                        ),
                        title: Text(
                          item.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
