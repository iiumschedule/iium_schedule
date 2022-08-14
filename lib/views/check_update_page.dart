import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

import '../constants.dart';
import '../hive_model/gh_responses.dart';
import '../model/gh_error.dart';
import '../model/gh_releases_latest.dart';

/// Check for update for Android & Windows
/// Currently the is an known issue for Windows
/// version is not tally with pubspec.yaml
class CheckUpdatePage extends StatefulWidget {
  const CheckUpdatePage({Key? key}) : super(key: key);

  @override
  State<CheckUpdatePage> createState() => _CheckUpdatePageState();
}

class _CheckUpdatePageState extends State<CheckUpdatePage> {
  late Version currentVersion;
  final key = 0; // key must be constant, only one entry will be stored in hive
  final box = Hive.box<GhResponses>(kHiveGhResponse);

  //TODO: Add latest to the url
  //TODO: Remove `first` in body

  /// Since this method is importing dart:io, it cannot be used on the web
  /// Also, the web seems like unsuitable to have a check for updates feature
  /// Despite that there have bene multiple issuew with web pwa caching
  Future<Version> _checkLatestVersion() async {
    GhReleasesLatest latest;

    // API endpoint pointed to latest stable release
    const latestRelease =
        'https://api.github.com/repos/iqfareez/iium_schedule/releases';
    final response = await http.get(Uri.parse(latestRelease),
        headers: box.get(0) != null
            ? {
                'If-None-Match': box.get(0)!.etag,
              }
            : null);
    // If the response is not modified, return the cached version
    // https://docs.github.com/en/rest/overview/resources-in-the-rest-api#conditional-requests

    if (response.statusCode == HttpStatus.ok) {
      final body = json.decode(response.body).first;
      final ghReleasesLatest = GhReleasesLatest.fromJson(body);
      // store the etag and the body of the response
      box.put(key, GhResponses(etag: response.headers['etag']!, body: body));
      latest = ghReleasesLatest;
    } else if (response.statusCode == HttpStatus.notModified) {
      // return the cached version
      GhResponses cachedResponses = box.get(key)!;
      latest = GhReleasesLatest.fromJson(cachedResponses.body);
    } else {
      final data = json.decode(response.body);
      final ghError = GhError.fromJson(data);
      throw Exception('(${response.statusCode}) ${ghError.message})');
    }
    print(latest.tagName);
    return Version.parse(latest.tagName!);
  }

  @override
  void initState() {
    super.initState();
    // determine current version
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      currentVersion = Version.parse(packageInfo.version);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update'),
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Colors.transparent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: FutureBuilder(
              future: _checkLatestVersion(),
              builder: (context, AsyncSnapshot<Version> snapshot) {
                if (snapshot.hasData) {
                  if (currentVersion.compareTo(snapshot.data) < 0) {
                    return Text(
                      'New version available! (${snapshot.data})',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    );
                  } else {
                    return const Text(
                      'You are up to date!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text(
                    'Sorry. Check update requets has failed.\n${snapshot.error}',
                    style: Theme.of(context).textTheme.headline6,
                  );
                } else {
                  return const Text('Checking update...');
                }
              }),
        ),
      ),
    );
  }
}
