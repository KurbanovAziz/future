import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:future_savings_app_29_t/fsa/fsa_color.dart';
 import 'package:webview_flutter/webview_flutter.dart';

class   TBCWeb extends StatefulWidget {
  final String url;
  final String title;

  const TBCWeb({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<TBCWeb> createState() => _RunWebPageState();
}

class _RunWebPageState extends State<TBCWeb> {
  late WebViewController controller;
  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: FsaColor.white,
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 20.h,
            color: FsaColor.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: const BackButton(
          color: FsaColor.black,
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: WebViewWidget(
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
