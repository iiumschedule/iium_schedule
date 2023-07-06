import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ReaderState { unknown, loading, success }

class FeImaluumImporter extends StatefulWidget {
  const FeImaluumImporter({super.key});

  @override
  State<FeImaluumImporter> createState() => _FeImaluumImporterState();
}

class _FeImaluumImporterState extends State<FeImaluumImporter> {
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
  // Track state to read and parse the schedule from html
  ReaderState readerState = ReaderState.unknown;
  // track loading state of the webview
  bool isLoading = false;
  bool loginRequired = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // dismiss the material banner on page pop
        // `clearMaterialBanners` is used to fix issue #71
        // https://github.com/iqfareez/iium_schedule/issues/71
        ScaffoldMessenger.of(context).clearMaterialBanners();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("i-Ma'luum importer"),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () => webViewController?.reload(),
            ),
          ],
          bottom: isLoading
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(1.5),
                  child: LinearProgressIndicator())
              : null,
        ),
        floatingActionButton: Builder(builder: (_) {
          if (!loginRequired && readerState == ReaderState.loading) {
            return FloatingActionButton(
              onPressed: () {},
              child: const CircularProgressIndicator(),
            );
          }
          if (readerState == ReaderState.success) {
            return FloatingActionButton.extended(
              onPressed: () => Navigator.pop(context, response),
              icon: const Icon(Icons.download_outlined),
              label: Text('Found ${response!.length} exams. Tap to add'),
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
        body: InAppWebView(
          key: webViewKey,
          onWebViewCreated: (controller) => webViewController = controller,
          initialUrlRequest: URLRequest(
            url: Uri.parse('https://imaluum.iium.edu.my/MyAcademic/final-exam'),
          ),
          // check if need login,
          // after login, make sure the url matches the url above
          onProgressChanged: (_, progress) {
            // even tho this callback wont be triggered at short interval, I'm still apply
            // the if checks guard to prevent unnecessary setState calls
            if (progress == 100) {
              setState(() {
                isLoading = false;
                readerState = ReaderState.loading;
              });
            } else {
              if (isLoading == false) {
                setState(() {
                  isLoading = true;
                  readerState = ReaderState.unknown;
                });
              }
            }
          },
          onLoadStop: (controller, url) async {
            if (!url.toString().contains('MyAcademic/final-exam')) {
              // when the url is not the schedule page, it means that the user
              // is not logged in
              setState(() => loginRequired = true);
              ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
                content: const Text(
                    'We do not have access to, or store, your login credentials entered through the site.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner();
                      },
                      child: const Text('Understood'))
                ],
              ));
            }
            if (url.toString().contains('/MyAcademic/final-exam')) {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

              setState(() => loginRequired = false);

              // extract the data
              // https://iiumschedule.vercel.app/docs/final-exams/#3-run-script (minified)
              var html = await controller.evaluateJavascript(
                  source:
                      'const tableBody=document.getElementsByClassName("table table-hover")[0],data=tableBody.getElementsByTagName("tr"),extractedData=[];for(let i=1;i<data.length;i++){let e=data[i].cells[3].innerText;if("No final"===e)continue;let t=data[i].cells[0].innerText,a=data[i].cells[1].innerText,l=parseInt(data[i].cells[2].innerText),n=data[i].cells[4].innerText,s=data[i].cells[5].innerText,d=parseInt(data[i].cells[6].innerText);extractedData.push({courseCode:t,title:a,section:l,date:e,time:n,venue:s,seat:d})}const json=JSON.stringify(extractedData);json;');

              // if timetable is not ready eg finance issue etc. Show this message
              if (html == null) {
                Fluttertoast.showToast(
                    msg:
                        "Failed to extract data. Seems like there is no exam timetable exist yet?");
                setState(() => readerState = ReaderState.unknown);
                return;
              }

              // parse the json
              var decoded = jsonDecode(html);
              setState(() {
                readerState = ReaderState.success;
                response = decoded;
              });
            }
          },
        ),
      ),
    );
  }
}
