import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Utilits/colors.dart';
import '../Models/city.dart';
import '../Models/state.dart';
import '../Providers/auth_provider.dart';

class CityItem extends StatefulWidget {
  final Cities cities;
  final States state;

  const CityItem({
    super.key,
    required this.cities,
    required this.state,
  });

  @override
  State<CityItem> createState() => _CityItemState();
}

class _CityItemState extends State<CityItem> {
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    widget.cities.checked =
        _authProvider.isChosen(widget.state.id!, widget.cities);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
      ),
      onTap: () {
        if (widget.cities.checked) {
          authProvider.deleteCity(widget.cities);
        } else {
          authProvider.addNewCity(widget.cities);
        }
        setState(() {
          widget.cities.checked = !widget.cities.checked;
        });
        authProvider.checkAll(authProvider.isCheckAllCities(widget.state));
      },
      title: Text(
        '${widget.cities.name}',
        style: const TextStyle(
          fontSize: 16.0,
        ),
      ),
      trailing: widget.cities.checked
          ? SizedBox(
              width: 40.0.w,
              child: const Icon(
                Icons.done,
                color: weevoLightPurpleColor,
              ),
            )
          : Container(width: 40.0.w),
    );
  }
}
