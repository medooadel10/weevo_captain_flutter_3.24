import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/router.dart';
import '../logic/cubit/wasully_details_cubit.dart';
import '../logic/cubit/wasully_details_state.dart';
import 'widgets/wasully_details_app_bar_title.dart';
import 'widgets/wasully_details_body.dart';

class WasullyDetailsScreen extends StatefulWidget {
  final int id;
  const WasullyDetailsScreen({super.key, required this.id});

  @override
  State<WasullyDetailsScreen> createState() => _WasullyDetailsScreenState();
}

class _WasullyDetailsScreenState extends State<WasullyDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<WasullyDetailsCubit>();
    cubit.getWassullyDetails(widget.id);
    getData();
  }

  void getData() async {
    WasullyDetailsCubit cubit = context.read<WasullyDetailsCubit>();
    String locationId = '';

    try {
      DocumentSnapshot courierToken = await FirebaseFirestore.instance
          .collection('courier_users')
          .doc(cubit.wasullyModel!.courier.id.toString())
          .get();
      String courierNationalId = courierToken['national_id'];
      DocumentSnapshot merchantToken = await FirebaseFirestore.instance
          .collection('merchant_users')
          .doc(cubit.wasullyModel!.merchant.id.toString())
          .get();
      String merchantNationalId = merchantToken['national_id'];
      if (merchantNationalId.hashCode >= courierNationalId.hashCode) {
        setState(() {
          locationId =
              '$merchantNationalId-$courierNationalId-${cubit.wasullyModel!.id}';
        });
      } else {
        setState(() {
          locationId =
              '$courierNationalId-$merchantNationalId-${cubit.wasullyModel!.id}';
        });
      }
      if (merchantNationalId.hashCode >= courierNationalId.hashCode) {
        setState(() {
          locationId =
              '$merchantNationalId-$courierNationalId-${cubit.wasullyModel!.id}';
        });
      } else {
        setState(() {
          locationId =
              '$courierNationalId-$merchantNationalId-${cubit.wasullyModel!.id}';
        });
      }
      FirebaseFirestore.instance
          .collection('locations')
          .doc(locationId)
          .snapshots()
          .listen((event) {
        if (event.data() != null && event.exists) {
          setState(() {
            context.read<WasullyDetailsCubit>().getWassullyDetails(widget.id);
          });
        }
      });
    } catch (e) {
      setState(() {
        locationId = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WasullyDetailsCubit, WasullyDetailsState>(
      builder: (context, state) {
        final cubit = context.read<WasullyDetailsCubit>();
        return Scaffold(
          appBar: AppBar(
            title: WasullyDetailsAppBarTitle(
              id: widget.id,
            ),
            leading: BlocBuilder<WasullyDetailsCubit, WasullyDetailsState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    MagicRouter.pop(data: cubit.wasullyModel);
                  },
                );
              },
            ),
          ),
          body: const WasullyDetailsBody(),
        );
      },
    );
  }
}
