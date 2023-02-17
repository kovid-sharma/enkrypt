import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class CommonWebView extends StatefulWidget {
  final String title;
  final String url;
  const CommonWebView({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);
  @override
  CommonWebViewState createState() => CommonWebViewState();
}

class CommonWebViewState extends State<CommonWebView> {
  bool isLoading = false;
  _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  late WebViewController viewController;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showWarning(context);
        print('<<<-------$shouldPop------>>>');
        return shouldPop ?? false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                child: WebView(
                  initialUrl: widget.url,
                  allowsInlineMediaPlayback: true,
                  javascriptMode: JavascriptMode.unrestricted,
                  zoomEnabled: true,
                  userAgent:
                  //'Version/4.0 Chrome/43.0.2357.65 Mobile Safari/537.36',
                  'Version/4.0 Chrome/98.0.4758.81 Mobile Safari/537.36',
                  onPageStarted: (_) {
                    setState(() {
                      isLoading = true;
                    });
                  },
                  onProgress: (index) {
                    if (index < 90) {
                      setState(() {
                        isLoading = true;
                      });
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  onPageFinished: (url) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                  navigationDelegate: (NavigationRequest request) async {
                    return NavigationDecision.navigate;
                  },
                  onWebViewCreated: (controller) {
                    viewController = controller;
                  },
                ),
              ),
              isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  color: Colors.pinkAccent,
                ),
              )
                  : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> showWarning(BuildContext context) async {
    // if(viewController.currentUrl().contains('homeskitchen'))
    print('hellllllllll');
    if (await viewController.canGoBack()) {
      print('-----------gooooooooooo back-------');
      FocusManager.instance.primaryFocus?.unfocus();
      await viewController.goBack();
      print("-------go back---------");
      return Future.value(false);
    } else {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Do you want to exit the app ?'),
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 17.5,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          contentPadding: EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                'No',
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontSize: 15.5,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontSize: 15.5,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}