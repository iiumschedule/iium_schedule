import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

enum ReaderState { unknown, loading, success }

class ImaluumWebView extends StatefulWidget {
  const ImaluumWebView({super.key});

  @override
  State<ImaluumWebView> createState() => _ImaluumWebViewState();
}

class _ImaluumWebViewState extends State<ImaluumWebView> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      // TODO: Need to check the performance for Android <9
      useHybridComposition: true,
    ),
  );

  List<dynamic>? response;
  ReaderState readerState = ReaderState.unknown;
  bool loginRequired = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InAppWebView(
          key: webViewKey,
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          initialUrlRequest: URLRequest(
            url: Uri.parse('https://imaluum.iium.edu.my/MyAcademic/schedule'),
          ),
          // check if need login,
          // after login, make sure the url matches the url above
          onProgressChanged: (controller, progress) {
            setState(() {
              readerState =
                  progress == 100 ? ReaderState.loading : ReaderState.unknown;
            });
          },
          onLoadStop: (controller, url) async {
            if (!url.toString().contains('MyAcademic/schedule')) {
              // when the url is not the schedule page, it means that the user
              // is not logged in
              setState(() {
                loginRequired = true;
              });
            }
            if (url.toString().contains('/MyAcademic/schedule')) {
              print('login success');
              setState(() {
                loginRequired = false;
              });

              // extract the data
              // https://iiumschedule.vercel.app/docs/extract/imaluum/#3-run-script
              var html = await controller.evaluateJavascript(source: """
const tableBody = document.getElementsByClassName("table table-hover")[0];
const data = tableBody.getElementsByTagName("tr");

const extractedData = [];

for (let i = 1; i < data.length; i++) {
  // skip empty rows
  if (data[i].cells[2].getAttribute("rowspan") === null) continue;

  const coursecode = data[i].cells[0].innerText;
  const sect = parseInt(data[i].cells[2].innerText);
  extractedData.push({
    courseCode: coursecode,
    section: sect,
  });
}

JSON.stringify(extractedData); 
                      """);

              // parse the json
              var decoded = jsonDecode(html);
              setState(() {
                readerState = ReaderState.success;
                response = decoded;
              });
            }
          },
        ),
        if (!loginRequired && readerState == ReaderState.loading)
          const Positioned(
            bottom: 30,
            right: 20,
            child: Material(
              child: SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        if (readerState == ReaderState.success)
          Positioned(
            bottom: 40,
            right: 10,
            child: Material(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, response),
                icon: const Icon(Icons.download_outlined),
                label: Text(
                  'Found ${response!.length} subjects. Tap to add',
                  // style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
