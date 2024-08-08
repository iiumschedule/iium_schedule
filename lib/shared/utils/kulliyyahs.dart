/// Kuliyyah code and full names
class Kuliyyahs {
  static final List<Kuliyyah> _kulls = [
    Kuliyyah(
      code: "BRIDG",
      fullName: "BRIDGING PROGRAMME",
      shortName: "BRIDG",
    ),
    Kuliyyah(
      code: "CCAC",
      fullName: "Credited Co-Curricular Department",
      shortName: "COCU",
    ),
    Kuliyyah(
      code: "CFL",
      fullName: "Centre for Languages & Pre-University Academic Development",
      shortName: "CELPAD",
    ),
    Kuliyyah(
      code: "AED",
      fullName: "Kulliyyah of Architecture & Environmental Design",
      shortName: "KAED",
    ),
    Kuliyyah(
      code: "EDUC",
      fullName: "Kulliyyah of Education",
      shortName: "KOED",
    ),
    Kuliyyah(
      code: "ENGIN",
      fullName: "Kulliyyah of Engineering",
      shortName: "KOE",
    ),
    Kuliyyah(
      code: "ECONS",
      fullName: "Kulliyyah of Economics & Management Sciences",
      shortName: "KENMS",
    ),
    Kuliyyah(
      code: "KICT",
      fullName: "Kulliyyah of Information & Communication Technology",
      shortName: "KICT",
    ),
    // "IHART": "INTERNATIONAL INSTITUTE FOR HALAL RESEARCH AND TRAINING",
    Kuliyyah(
      code: "IRKHS",
      fullName: "Kulliyyah of Islamic Reveal Knowledge And Human Sciences",
      shortName: "KIRKHS",
    ),
    // "IIBF": "ISLAMIC BANKING AND FINANCE",
    // "ISTAC": "ISTAC",
    Kuliyyah(
      code: "LAWS",
      fullName: "Ahmad Ibrahim Kulliyyah of Laws",
      shortName: "AIKOL",
    ),
    Kuliyyah(
      code: "KLM",
      fullName: "Kulliyyah of Sustainable Tourism and Contemporary Languages",
      shortName: "KSTCL KLM",
    ),
    Kuliyyah(
      code: "KAHS",
      fullName: "Kulliyyah of Allied Health Science",
      shortName: "KAHS",
    ),
    Kuliyyah(
      code: "DENT",
      fullName: "Kulliyyah of Dentistry",
      shortName: "KOD",
    ),
    Kuliyyah(
      code: "MEDIC",
      fullName: "Kuliiyyah of Medicine",
      shortName: "KOM",
    ),
    Kuliyyah(
      code: "NURS",
      fullName: "Kulliyyah of Nursing",
      shortName: "KON",
    ),
    Kuliyyah(
      code: "PHARM",
      fullName: "Kulliyyah of Pharmacy",
      shortName: "KOP",
    ),
    // Kuliyyah(
    //   code: "PLNET",
    //   fullName: "Planetary Survival For Sustainable Well-Being",
    //   shortName: "Planetary",
    // ),
    Kuliyyah(
      code: "KOS",
      fullName: "Kulliyyah of Science",
      shortName: "KOS",
    ),
    Kuliyyah(
      code: "SC4SH",
      fullName: "Sejahtera Centre for Sustainability & Humanity",
      shortName: "SEJAHTERA",
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

class Kuliyyah {
  /// Code used for Kulliyyah in Albiruni request
  String code;

  /// Full name of the kulliyyah
  String fullName,

      /// Kulliyyah name is shortform
      shortName;

  Kuliyyah({
    required this.code,
    required this.fullName,
    required this.shortName,
  });

  @override
  String toString() {
    return '$code - $shortName';
  }
}
