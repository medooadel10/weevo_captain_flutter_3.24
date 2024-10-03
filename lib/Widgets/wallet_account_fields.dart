import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Utilits/colors.dart';
import 'edit_text.dart';
import 'weevo_button.dart';

class WalletAccountFields extends StatefulWidget {
  final Function dataHolder;

  const WalletAccountFields(this.dataHolder, {super.key});

  @override
  State<WalletAccountFields> createState() => _WalletAccountFieldsState();
}

class _WalletAccountFieldsState extends State<WalletAccountFields> {
  bool isFocused = false;
  bool isEmpty = true;
  late TextEditingController walletController;
  late FocusNode walletNode;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  String? walletNumber;
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    walletController = TextEditingController();
    walletNode = FocusNode();
    walletController.addListener(() {
      setState(() {
        isEmpty = walletController.text.isEmpty;
      });
    });
    walletNode.addListener(() {
      setState(() {
        isFocused = walletNode.hasFocus;
      });
    });
    isEmpty = walletController.text.isEmpty;
  }

  @override
  void dispose() {
    walletNode.dispose();
    walletController.dispose();
    super.dispose();
  }

  void submitFn() {
    final formState = _formState.currentState;

    if (formState!.validate()) {
      formState.save();
      walletController.clear();
    }
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formState,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EditText(
            validator: (String? v) {
              if (!isButtonPressed) {
                return null;
              }
              isError = true;
              if (v != null && v.length < 11) {
                return 'أدخل رقم المحفظة';
              }
              isError = false;
              return null;
            },
            readOnly: false,
            controller: walletController,
            type: TextInputType.number,
            onSave: (String? v) {
              widget.dataHolder(v);
            },
            onChange: (_) {
              isButtonPressed = false;
              if (isError) {
                _formState.currentState!.validate();
              }
            },
            labelText: 'رقم المحفظة الالكترونية',
            isFocus: isFocused,
            focusNode: walletNode,
            isPassword: false,
            isPhoneNumber: true,
            shouldDisappear: !isEmpty && !isFocused,
            upperTitle: true,
          ),
          const SizedBox(
            height: 20.0,
          ),
          WeevoButton(
            isStable: true,
            title: 'حفظ',
            color: weevoPrimaryOrangeColor,
            onTap: submitFn,
          ),
        ],
      ),
    );
  }
}
