import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Utilits/colors.dart';
import '../../../../Widgets/weevo_button.dart';
import '../../../../core/helpers/spacing.dart';
import '../../logic/cubit/wasully_details_cubit.dart';

class WasullyDetailsTelButton extends StatelessWidget {
  final Color color;
  const WasullyDetailsTelButton(
      {super.key, this.color = weevoPrimaryOrangeColor});

  @override
  Widget build(BuildContext context) {
    final data = context.read<WasullyDetailsCubit>().wasullyModel;
    return WeevoButton(
      onTap: () async {
        await launchUrl(
          Uri.parse('tel:${data!.merchant.phone}'),
        );
      },
      color: color,
      isStable: true,
      childWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'اتصل بالتاجر',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          horizontalSpace(10),
          const Icon(
            Icons.phone,
            color: Colors.white,
            size: 20,
          )
        ],
      ),
    );
  }
}
