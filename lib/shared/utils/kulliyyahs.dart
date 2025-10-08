import 'package:albiruni/albiruni.dart';

/// Kuliyyah code and full names
class Kuliyyahs {
  static final List<Kuliyyah> _kulls = [
    Kuliyyah(
      code: "AHAS",
      fullName: "Kulliyyah of Islamic Reveal Knowledge And Human Sciences",
      moniker: "AHAS KIRKHS",
      scopes: [StudyGrad.ug, StudyGrad.pg],
    ),
    Kuliyyah(
      code: "KAHS",
      fullName: "Kulliyyah of Allied Health Science",
      moniker: "ALLIED HEALTH SCIENCES",
      scopes: [StudyGrad.ug, StudyGrad.pg],
    ),
    Kuliyyah(
      code: "AED",
      fullName: "Kulliyyah of Architecture & Environmental Design",
      moniker: "ARCHITECTURE",
      scopes: [StudyGrad.ug, StudyGrad.pg],
    ),
    Kuliyyah(
      code: "BRIDG",
      fullName: "BRIDGING PROGRAMME",
      moniker: "BRIDG",
      scopes: [StudyGrad.ug, StudyGrad.pg],
    ),
    Kuliyyah(
      code: "CFL",
      fullName: "Centre for Languages & Pre-University Academic Development",
      moniker: "CELPAD",
      scopes: [StudyGrad.ug],
    ),
    Kuliyyah(
      code: "CCC",
      fullName: "Credited Co-Curricular Department",
      moniker: "CCC",
      scopes: [StudyGrad.ug],
    ),
    Kuliyyah(
      code: "DENT",
      fullName: "Kulliyyah of Dentistry",
      moniker: "DENTISTRY",
      scopes: [StudyGrad.ug, StudyGrad.pg],
    ),
    Kuliyyah(
      code: "EDUC",
      fullName: "Kulliyyah of Education",
      moniker: "EDUCATION",
      scopes: [StudyGrad.ug, StudyGrad.pg],
    ),
    Kuliyyah(
      code: "ENGIN",
      fullName: "Kulliyyah of Engineering",
      moniker: "ENGIN",
      scopes: [StudyGrad.ug, StudyGrad.pg],
    ),
    Kuliyyah(
      code: "ECONS",
      fullName: "Kulliyyah of Economics & Management Sciences",
      moniker: "ENMS",
      scopes: [StudyGrad.ug, StudyGrad.pg],
    ),
    Kuliyyah(
      code: "KICT",
      fullName: "Kulliyyah of Information & Communication Technology",
      moniker: "ICT",
      scopes: [StudyGrad.ug, StudyGrad.pg],
    ),
    Kuliyyah(
      code: "IHART",
      fullName: "International Institute For Halal Research And Training",
      moniker: "IHART",
      scopes: [StudyGrad.pg],
    ),
    Kuliyyah(
      code: "IIBF",
      fullName: "Islamic Banking And Finance",
      moniker: "IIBF",
      scopes: [StudyGrad.pg],
    ),
    Kuliyyah(
      code: "ISTAC",
      fullName: "ISTAC",
      moniker: "ISTAC",
      scopes: [StudyGrad.pg],
    ),
    Kuliyyah(
      code: "KLM",
      fullName: "Kulliyyah of Sustainable Tourism and Contemporary Languages",
      moniker: "KSTCL",
      scopes: [StudyGrad.ug, StudyGrad.pg],
    ),
    Kuliyyah(
      code: "LAWS",
      fullName: "Ahmad Ibrahim Kulliyyah of Laws",
      moniker: "LAWS",
      scopes: [StudyGrad.ug, StudyGrad.pg],
    ),
    Kuliyyah(
      code: "MEDIC",
      fullName: "Kulliyyah of Medicine",
      moniker: "MEDICINE",
      scopes: [StudyGrad.ug, StudyGrad.pg],
    ),
    Kuliyyah(
      code: "NURS",
      fullName: "Kulliyyah of Nursing",
      moniker: "NURSING",
      scopes: [StudyGrad.ug, StudyGrad.pg],
    ),
    Kuliyyah(
      code: "PHARM",
      fullName: "Kulliyyah of Pharmacy",
      moniker: "PHARMACY",
      scopes: [StudyGrad.ug, StudyGrad.pg],
    ),
    Kuliyyah(
      code: "PLNET",
      fullName: "Planetary Survival For Sustainable Well-Being",
      moniker: "PLNET",
      scopes: [StudyGrad.ug, StudyGrad.pg],
    ),
    Kuliyyah(
      code: "KOS",
      fullName: "Kulliyyah of Science",
      moniker: "SCIENCE",
      scopes: [StudyGrad.ug, StudyGrad.pg],
    ),
    Kuliyyah(
      code: "SC4SH",
      fullName: "Sejahtera Centre for Sustainability & Humanity",
      moniker: "SEJAHTERA CENTRE FOR SUSTAINABILTY AND HUMANITY",
      scopes: [StudyGrad.ug],
    ),
  ];

  /// Get all list of kuliyyah
  static List<Kuliyyah> get all => _kulls;

  /// Return kuliyyah data from code
  static Kuliyyah kuliyyahFromCode(String code) =>
      _kulls.firstWhere((element) => element.code == code);

  /// Return a list of kuliyyah codes
  static List<String> get allCodes => _kulls.map((e) => e.code).toList();
}

/// The Kulliyyah model
class Kuliyyah {
  /// Code used for Kulliyyah in Albiruni request
  String code;

  /// Full name of the kulliyyah
  String fullName;

  /// The display name in course schedule dropdown
  String moniker;

  List<StudyGrad> scopes = [];

  Kuliyyah({
    required this.code,
    required this.fullName,
    required this.moniker,
    this.scopes = const [],
  });

  @override
  String toString() {
    return '$code - $moniker';
  }
}
