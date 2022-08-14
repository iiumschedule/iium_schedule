import 'package:hive/hive.dart';

part 'gh_responses.g.dart';

@HiveType(typeId: 3)
class GhResponses {
  /// etag of the response header.
  @HiveField(0)
  late String etag;

  @HiveField(1)
  late Map<String, dynamic> body;

  GhResponses({required this.etag, required this.body});
}
