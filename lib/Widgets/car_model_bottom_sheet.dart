import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Models/cars/car_model.dart';
import '../Providers/auth_provider.dart';
import '../Utilits/constants.dart';
import '../core/widgets/custom_image.dart';
import 'edit_text.dart';

class CarModelBottomSheet extends StatefulWidget {
  final Function onItemClick;
  final int selectedItem;
  final List<CarModel> models;

  const CarModelBottomSheet({
    super.key,
    required this.onItemClick,
    required this.selectedItem,
    required this.models,
  });

  @override
  State<CarModelBottomSheet> createState() => _CarModelBottomSheetState();
}

class _CarModelBottomSheetState extends State<CarModelBottomSheet> {
  late FocusNode _searchNode;
  late TextEditingController _searchController;
  bool _searchFocused = false;

  @override
  void initState() {
    super.initState();
    _searchNode = FocusNode();
    _searchController = TextEditingController();
    _searchNode.addListener(() {
      setState(() {
        _searchFocused = _searchNode.hasFocus;
      });
    });
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, data, child) => Padding(
        padding: const EdgeInsets.only(
          top: 6.0,
        ),
        child: Column(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: EditText(
                controller: _searchController,
                validator: (_) {
                  return null;
                },
                readOnly: false,
                onSave: (_) {},
                onChange: (String? v) {
                  data.filterCarsModel(widget.models, v);
                },
                labelText: 'أدخل موديل السيارة',
                isFocus: _searchFocused,
                focusNode: _searchNode,
                isPassword: false,
                isPhoneNumber: false,
                shouldDisappear: false,
                upperTitle: false,
              ),
            ),
            !_searchFocused && _searchController.text.length < 2
                ? Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.models.length,
                      itemBuilder: (context, int i) => ListTile(
                        leading: CustomImage(
                          image: '$carIconLoadUrl${widget.models[i].photo}',
                          height: 30.0,
                          width: 30.0,
                          radius: 25,
                        ),
                        onTap: () => widget.onItemClick(
                          widget.models[i],
                          widget.models.indexOf(widget.models[i]),
                        ),
                        title: Text(
                          widget.models[i].name!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: widget.selectedItem ==
                                widget.models.indexOf(widget.models[i])
                            ? const Icon(
                                Icons.done,
                                color: Colors.black,
                              )
                            : const SizedBox(
                                height: 24.0,
                                width: 24.0,
                              ),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.carSearchList.length,
                      itemBuilder: (context, int i) => ListTile(
                        leading: CustomImage(
                          image:
                              '$carIconLoadUrl${data.carSearchList[i].photo}',
                          height: 30.0,
                          width: 30.0,
                          radius: 25,
                        ),
                        onTap: () => widget.onItemClick(
                          data.carSearchList[i],
                          data.carSearchList.indexOf(data.carSearchList[i]),
                        ),
                        title: Text(
                          data.carSearchList[i].name!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: widget.selectedItem ==
                                data.carSearchList
                                    .indexOf(data.carSearchList[i])
                            ? const Icon(
                                Icons.done,
                                color: Colors.black,
                              )
                            : const SizedBox(
                                height: 24.0,
                                width: 24.0,
                              ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
