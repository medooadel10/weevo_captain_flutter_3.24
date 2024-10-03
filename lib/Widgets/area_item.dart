import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Models/state.dart';
import '../Models/upload_state.dart';
import '../Providers/auth_provider.dart';
import '../Utilits/colors.dart';
import 'area_more_options.dart';

class AreaItem extends StatefulWidget {
  final UploadState uploadState;

  const AreaItem({
    super.key,
    required this.uploadState,
  });

  @override
  State<AreaItem> createState() => _AreaItemState();
}

class _AreaItemState extends State<AreaItem> {
  bool isExpanded = false;
  late States _states;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _states = _authProvider.getStateById(widget.uploadState.id);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        width: size.width,
        padding: const EdgeInsets.all(
          20.0,
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            20,
          ),
          color: weevoWhiteWithSilver,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    authProvider.isCheckAllStates(_states)
                        ? Container()
                        : Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: Colors.black,
                            size: 30.0,
                          ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      widget.uploadState.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    authProvider.isCheckAllStates(_states)
                        ? SizedBox(
                            width: 10.w,
                          )
                        : Container(),
                    authProvider.isCheckAllStates(_states)
                        ? Text(
                            'كل المناطق',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.0,
                            ),
                          )
                        : Container(),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          // 20.0,
                        ),
                      ),
                      builder: (context) => AreaMoreOptions(
                        state: widget.uploadState,
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.more_vert_sharp,
                    color: Colors.grey,
                    size: 30.0,
                  ),
                ),
              ],
            ),
            authProvider.isCheckAllCities(_states)
                ? Container()
                : AnimatedContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                    ),
                    height: isExpanded
                        ? widget.uploadState.chosenCities.length * 47.h
                        : 0.h,
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.uploadState.chosenCities.length,
                      itemBuilder: (context, i) => ListTile(
                        title: Text(
                          widget.uploadState.chosenCities[i].name ?? '',
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
