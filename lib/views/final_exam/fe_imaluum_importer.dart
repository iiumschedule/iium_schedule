import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
  ReaderState readerState = ReaderState.unknown;
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
            setState(() {
              readerState =
                  progress == 100 ? ReaderState.loading : ReaderState.unknown;
            });
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
              // https://iiumschedule.vercel.app/docs/extract/imaluum/#3-run-script
              var html = await controller.evaluateJavascript(source: """
const tableBody = document.getElementsByClassName("table table-hover")[0];
const data = tableBody.getElementsByTagName("tr");

const extractedData = [];

for (let i = 1; i < data.length; i++) {
    const date = data[i].cells[3].innerText;
    if (date === "No final") continue

    const coursecode = data[i].cells[0].innerText;
    const title = data[i].cells[1].innerText;
    const sect = parseInt(data[i].cells[2].innerText);
    const time = data[i].cells[4].innerText;
    const venue = data[i].cells[5].innerText;
    const seat = parseInt(data[i].cells[6].innerText);

    extractedData.push({courseCode: coursecode, title: title, section: sect, date: date, time: time, venue: venue, seat: seat,});
}

const json = JSON.stringify(extractedData); // data
json
                      """);

              // parse the json
              var decoded = jsonDecode(html);
              print(decoded);
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
