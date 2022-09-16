class BasicSubjectModel {
  String? courseCode;
  int? section;

  BasicSubjectModel({this.courseCode, this.section});

  BasicSubjectModel.fromJson(Map<String, dynamic> json) {
    courseCode = json["courseCode"];
    section = json["section"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["courseCode"] = courseCode;
    data["section"] = section;
    return data;
  }

  @override
  String toString() {
    return '{courseCode: $courseCode, section: $section}';
  }
}
