import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Models/transaction_webview_model.dart';
import '../Providers/auth_provider.dart';
import '../Providers/wallet_provider.dart';
import '../Widgets/loading_widget.dart';

class TransactionWebView extends StatefulWidget {
  static const String id = 'TransactionWebView';
  final TransactionWebViewModel model;

  const TransactionWebView({
    super.key,
    required this.model,
  });

  @override
  State<TransactionWebView> createState() => _TransactionWebViewState();
}

class _TransactionWebViewState extends State<TransactionWebView> {
  late WebViewController _controller;
  late WalletProvider walletProvider;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    walletProvider = Provider.of<WalletProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onNavigationRequest: (request) {
          handleNavigationStateChange(request.url);
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
      ))
      ..loadRequest(Uri.parse(widget.model.url));
  }

  void handleNavigationStateChange(String newUrl) async {
    log(newUrl);
    if (newUrl.contains('https://system.weevoapp.com')) {
      if (newUrl.contains('successCallback')) {
        Navigator.pop(context, true);
        log('success');
      } else {
        Navigator.pop(context, false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LoadingWidget(
            isLoading: false, child: WebViewWidget(controller: _controller)),

        // WebView(
        //   onWebResourceError: (WebResourceError error) {
        //     print(error.errorCode);
        //   },
        //   initialUrl: widget.model.url,
        //   javascriptMode: JavascriptMode.unrestricted,
        //   onWebViewCreated: (WebViewController webViewController) async {
        //     _controller = webViewController;
        //   },
        //   onPageFinished: (String s) async {
        //     setState(() => _isLoading = false);
        //     String result = await _controller.runJavascriptReturningResult(
        //         'document.documentElement.innerHTML');
        //     log('message -> ${json.decode(result)}');
        //     if (widget.model.selectedValue == 1 &&
        //         result.contains('Approved')) {
        //       String finalNumber;
        //       String t = json.decode(result);
        //       HtmlTags.removeTag(
        //           htmlString: t,
        //           callback: (String t) {
        //             finalNumber = t.split(':')[1].trim();
        //           });
        //       Navigator.pop(context, finalNumber);
        //     } else if (widget.model.selectedValue == 1 &&
        //         result.contains('Not sufficient funds')) {
        //       Navigator.pop(context, 'no funds');
        //     } else if (widget.model.selectedValue == 0 &&
        //         result.split(',')[1].split(':')[1].contains('completed')) {
        //       Navigator.pop(context, true);
        //     }
        //   },
        //   gestureNavigationEnabled: true,
        // ),
      ),
    );
  }
}
