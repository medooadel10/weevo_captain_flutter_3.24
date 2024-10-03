import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Widgets/loading_widget.dart';

class WeevoWebViewPreview extends StatefulWidget {
  static const String id = 'Weevo_Web_View_Preview';
  final String url;

  const WeevoWebViewPreview({
    super.key,
    required this.url,
  });

  @override
  State<WeevoWebViewPreview> createState() => _WeevoWebViewPreviewState();
}

class _WeevoWebViewPreviewState extends State<WeevoWebViewPreview> {
  late WebViewController _controller;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains("tel:")) {
              launchUrlString(request.url);
              return NavigationDecision.prevent;
            } else {
              return NavigationDecision.navigate;
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LoadingWidget(
          isLoading: _isLoading,
          child: WebViewWidget(
            controller: _controller,
          ),
        ),
      ),
    );
  }
}
