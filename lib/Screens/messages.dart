import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import '../Providers/auth_provider.dart';
import '../Utilits/colors.dart';
import '../Widgets/chat_item.dart';
import '../Widgets/connectivity_widget.dart';

class Messages extends StatefulWidget {
  static const String id = 'MESSAGES';
  final bool fromHome;

  const Messages({super.key, required this.fromHome});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    initializeDateFormatting('ar_EG');
    _authProvider.setCurrentWidget(widget.runtimeType.toString());
  }

  @override
  void dispose() {
    _authProvider.setCurrentWidget('');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    Size s = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: !widget.fromHome
              ? AppBar(
                  leading: IconButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                    ),
                  ),
                  title: const Text(
                    'الرسائل',
                  ),
                )
              : null,
          body: ConnectivityWidget(
            callback: () {},
            child: ConnectivityWidget(
              callback: () {},
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('messages')
                      .where('users', arrayContains: authProvider.getNationalId)
                      .orderBy('lastMessage.dateTime', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> data) {
                    return data.connectionState == ConnectionState.waiting
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  weevoPrimaryOrangeColor),
                            ),
                          )
                        : data.hasData
                            ? data.data!.docs.isEmpty
                                ? const Center(child: Text('لا توجد محادثات'))
                                : ListView.separated(
                                    separatorBuilder:
                                        (BuildContext context, int i) =>
                                            Divider(
                                      height: 0.0,
                                      thickness: 1.0,
                                      indent: s.width * 0.2,
                                    ),
                                    itemBuilder: (BuildContext ctx, int i) =>
                                        ChatItem(data: data.data!.docs[i]),
                                    itemCount: data.data!.docs.length,
                                  )
                            : const Center(child: Text('لا توجد محادثات'));
                  }),
            ),
          )),
    );
  }
}
