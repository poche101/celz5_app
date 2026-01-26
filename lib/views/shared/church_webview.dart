import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ChurchWebView extends StatefulWidget {
  final String url;
  final String title;

  const ChurchWebView({super.key, required this.url, required this.title});

  @override
  State<ChurchWebView> createState() => _ChurchWebViewState();
}

class _ChurchWebViewState extends State<ChurchWebView> {
  double _progress = 0;
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0A192F),
        elevation: 0,
        bottom: _progress < 1.0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(3),
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.white,
                  color: Colors.blueAccent,
                ),
              )
            : null,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.url)),
        onWebViewCreated: (controller) => webViewController = controller,
        onProgressChanged: (controller, progress) {
          setState(() {
            _progress = progress / 100;
          });
        },
      ),
    );
  }
}
