import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewLauncher extends StatefulWidget {
  static const String routeName = "/converter-launcher-screen";
  const WebviewLauncher(
      {super.key, required this.conversionTitle, required this.conversionUrl});

  final String conversionTitle;
  final String conversionUrl;

  @override
  State<WebviewLauncher> createState() => _WebviewLauncherState();
}

class _WebviewLauncherState extends State<WebviewLauncher> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.conversionUrl),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.conversionTitle)),
      body: WebViewWidget(controller: _controller),
    );
  }
}
