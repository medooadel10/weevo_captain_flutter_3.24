import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Models/bank_model.dart';

class BanksBottomSheet extends StatelessWidget {
  final Function onItemClick;
  final int selectedItem;
  final List<BankModel> models;

  const BanksBottomSheet({
    super.key,
    required this.onItemClick,
    required this.selectedItem,
    required this.models,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 6.0,
      ),
      shrinkWrap: true,
      itemCount: models.length,
      itemBuilder: (context, int i) => ListTile(
        onTap: () => onItemClick(
          models[i],
          models.indexOf(models[i]),
        ),
        title: Text(
          models[i].nameAr!,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: selectedItem == models.indexOf(models[i])
            ? const Icon(
                Icons.done,
                color: Colors.black,
              )
            : const SizedBox(
                height: 24.0,
                width: 24.0,
              ),
      ),
    );
  }
}
