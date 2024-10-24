import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebViewExample(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return Future.value(false); // منع الرجوع الافتراضي للنظام
        }
        return Future.value(true); // السماح بالرجوع الافتراضي للنظام إذا لم يكن هناك صفحات سابقة
      },
      child: Scaffold(
        body: WebView(
          initialUrl: 'https://drhabeb.online/', // استبدل بعنوان موقعك
          javascriptMode: JavascriptMode.unrestricted,
          initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
          // إضافة User-Agent مخصص للتطبيق
          userAgent: 'mostafa',  // استبدل 'YourAppName' باسم يعبر عن التطبيق الخاص بك
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://drhabeb.online/')) {
              return NavigationDecision.navigate; // فتح الروابط داخل التطبيق
            } else {
              _launchURL(request.url); // فتح الروابط الخارجية في المتصفح
              return NavigationDecision.prevent; // منع الروابط من الفتح داخل التطبيق
            }
          },
          onPageFinished: (String url) {
            _controller.runJavascript(
                "document.querySelectorAll('video').forEach(video => video.play());");
          },
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
