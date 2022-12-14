import 'package:isar/isar.dart';

part 'gh_responses.g.dart';

@collection
class GhResponses {
  Id? id;

  /// etag of the response header.
  late String etag;

  late String body;

  GhResponses({required this.etag, required this.body});
}
