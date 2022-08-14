/// Github api error
class GhError {
  String? message;
  String? documentationUrl;

  GhError({this.message, this.documentationUrl});

  GhError.fromJson(Map<String, dynamic> json) {
    message = json["message"];
    documentationUrl = json["documentation_url"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["message"] = message;
    data["documentation_url"] = documentationUrl;
    return data;
  }
}
