import 'package:flutter/material.dart';

import '../Models/state.dart';
import 'edit_text.dart';

class StateBottomSheet extends StatefulWidget {
  final Function onPress;
  final List<States> states;

  const StateBottomSheet({
    super.key,
    required this.onPress,
    required this.states,
  });

  @override
  State<StateBottomSheet> createState() => _StateBottomSheetState();
}

class _StateBottomSheetState extends State<StateBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: EditText(
              readOnly: false,
              suffix: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              validator: (String? value) {
                return null;
              },
              onSave: (String? value) {},
              onChange: (String? value) {},
              labelText: 'ابحث عن المنطقة',
              isFocus: false,
              focusNode: FocusNode(),
              radius: 12.0,
              isPassword: false,
              isPhoneNumber: false,
              shouldDisappear: false,
              upperTitle: false,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.states.length,
              itemBuilder: (context, i) => ListTile(
                onTap: () => widget.onPress(widget.states[i]),
                title: Text(widget.states[i].name!),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
