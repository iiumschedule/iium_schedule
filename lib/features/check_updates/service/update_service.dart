import 'dart:convert';
import 'dart:io';

import 'package:iium_schedule/features/check_updates/models/gh_error.dart';
import 'package:iium_schedule/features/check_updates/models/gh_releases_latest.dart';
import 'package:iium_schedule/isar_models/gh_responses.dart';
import 'package:iium_schedule/shared/services/isar_service.dart';
import 'package:version/version.dart';
import 'package:http/http.dart' as http;

class UpdateService {

  IsarService isarService;

  UpdateService({required this.isarService});

  Future<Version> checkLatestVersion() async {
    GhReleasesLatest latest;
    GhResponses? cachedResponses = await isarService.getGhResponse();

    // API endpoint pointed to latest stable release
    const latestRelease =
        'https://api.github.com/repos/iqfareez/iium_schedule/releases/latest';
    final response = await http.get(Uri.parse(latestRelease),
        headers: cachedResponses != null
            ? {
          'If-None-Match': cachedResponses.etag,
        }
            : null);
    // If the response is not modified, return the cached version
    // https://docs.github.com/en/rest/overview/resources-in-the-rest-api#conditional-requests

    if (response.statusCode == HttpStatus.ok) {
      final ghReleasesLatest =
      GhReleasesLatest.fromJson(json.decode(response.body));
      // store the etag and the body of the response
      isarService.addGhResponse(
          GhResponses(etag: response.headers['etag']!, body: response.body));
      latest = ghReleasesLatest;
    } else if (response.statusCode == HttpStatus.notModified) {
      // return the cached version
      var body = jsonDecode(cachedResponses!.body);
      latest = GhReleasesLatest.fromJson(body);
    } else {
      final data = json.decode(response.body);
      final ghError = GhError.fromJson(data);
      throw Exception('(${response.statusCode}) ${ghError.message})');
    }
    return Version.parse(latest.tagName!);
  }
}