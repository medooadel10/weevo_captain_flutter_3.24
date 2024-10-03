import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/spacing.dart';
import '../../logic/cubit/wasully_details_cubit.dart';
import '../../logic/cubit/wasully_details_state.dart';
import 'wasully_details_qr_code.dart';

class WasullyDetailsAppBarTitle extends StatelessWidget {
  final int id;
  const WasullyDetailsAppBarTitle({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WasullyDetailsCubit, WasullyDetailsState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'طلب وصلي رقم $id',
                ),
              ),
            ),
            horizontalSpace(16),
            const WasullyDetailsQrCode(),
          ],
        );
      },
    );
  }
}
