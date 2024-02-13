// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_final_exam.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSavedFinalExamCollection on Isar {
  IsarCollection<SavedFinalExam> get savedFinalExams => this.collection();
}

const SavedFinalExamSchema = CollectionSchema(
  name: r'SavedFinalExam',
  id: -5567489116739535725,
  properties: {
    r'courseCode': PropertySchema(
      id: 0,
      name: r'courseCode',
      type: IsarType.string,
    ),
    r'courseTitle': PropertySchema(
      id: 1,
      name: r'courseTitle',
      type: IsarType.string,
    ),
    r'dateTime': PropertySchema(
      id: 2,
      name: r'dateTime',
      type: IsarType.dateTime,
    ),
    r'seatNumber': PropertySchema(
      id: 3,
      name: r'seatNumber',
      type: IsarType.long,
    ),
    r'venue': PropertySchema(
      id: 4,
      name: r'venue',
      type: IsarType.string,
    )
  },
  estimateSize: _savedFinalExamEstimateSize,
  serialize: _savedFinalExamSerialize,
  deserialize: _savedFinalExamDeserialize,
  deserializeProp: _savedFinalExamDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _savedFinalExamGetId,
  getLinks: _savedFinalExamGetLinks,
  attach: _savedFinalExamAttach,
  version: '3.1.0+1',
);

int _savedFinalExamEstimateSize(
  SavedFinalExam object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.courseCode.length * 3;
  bytesCount += 3 + object.courseTitle.length * 3;
  bytesCount += 3 + object.venue.length * 3;
  return bytesCount;
}

void _savedFinalExamSerialize(
  SavedFinalExam object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.courseCode);
  writer.writeString(offsets[1], object.courseTitle);
  writer.writeDateTime(offsets[2], object.dateTime);
  writer.writeLong(offsets[3], object.seatNumber);
  writer.writeString(offsets[4], object.venue);
}

SavedFinalExam _savedFinalExamDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SavedFinalExam(
    courseCode: reader.readString(offsets[0]),
    courseTitle: reader.readString(offsets[1]),
    dateTime: reader.readDateTime(offsets[2]),
    seatNumber: reader.readLong(offsets[3]),
    venue: reader.readString(offsets[4]),
  );
  object.id = id;
  return object;
}

P _savedFinalExamDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _savedFinalExamGetId(SavedFinalExam object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _savedFinalExamGetLinks(SavedFinalExam object) {
  return [];
}

void _savedFinalExamAttach(
    IsarCollection<dynamic> col, Id id, SavedFinalExam object) {
  object.id = id;
}

extension SavedFinalExamQueryWhereSort
    on QueryBuilder<SavedFinalExam, SavedFinalExam, QWhere> {
  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SavedFinalExamQueryWhere
    on QueryBuilder<SavedFinalExam, SavedFinalExam, QWhereClause> {
  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SavedFinalExamQueryFilter
    on QueryBuilder<SavedFinalExam, SavedFinalExam, QFilterCondition> {
  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      courseCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      courseCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'courseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      courseCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'courseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      courseCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'courseCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      courseCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'courseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      courseCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'courseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      courseCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'courseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      courseCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'courseCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      courseCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseCode',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      courseCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'courseCode',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      courseTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      courseTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'courseTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      courseTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'courseTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      courseTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'courseTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      courseTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'courseTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      courseTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'courseTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      courseTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'courseTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      courseTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'courseTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      courseTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      courseTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'courseTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      dateTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      dateTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      dateTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      dateTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      seatNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seatNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      seatNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seatNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      seatNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seatNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      seatNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seatNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      venueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'venue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      venueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'venue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      venueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'venue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      venueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'venue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      venueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'venue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      venueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'venue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      venueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'venue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      venueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'venue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      venueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'venue',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterFilterCondition>
      venueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'venue',
        value: '',
      ));
    });
  }
}

extension SavedFinalExamQueryObject
    on QueryBuilder<SavedFinalExam, SavedFinalExam, QFilterCondition> {}

extension SavedFinalExamQueryLinks
    on QueryBuilder<SavedFinalExam, SavedFinalExam, QFilterCondition> {}

extension SavedFinalExamQuerySortBy
    on QueryBuilder<SavedFinalExam, SavedFinalExam, QSortBy> {
  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy>
      sortByCourseCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseCode', Sort.asc);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy>
      sortByCourseCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseCode', Sort.desc);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy>
      sortByCourseTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseTitle', Sort.asc);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy>
      sortByCourseTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseTitle', Sort.desc);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy> sortByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.asc);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy>
      sortByDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.desc);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy>
      sortBySeatNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seatNumber', Sort.asc);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy>
      sortBySeatNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seatNumber', Sort.desc);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy> sortByVenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venue', Sort.asc);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy> sortByVenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venue', Sort.desc);
    });
  }
}

extension SavedFinalExamQuerySortThenBy
    on QueryBuilder<SavedFinalExam, SavedFinalExam, QSortThenBy> {
  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy>
      thenByCourseCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseCode', Sort.asc);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy>
      thenByCourseCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseCode', Sort.desc);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy>
      thenByCourseTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseTitle', Sort.asc);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy>
      thenByCourseTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseTitle', Sort.desc);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy> thenByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.asc);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy>
      thenByDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.desc);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy>
      thenBySeatNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seatNumber', Sort.asc);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy>
      thenBySeatNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seatNumber', Sort.desc);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy> thenByVenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venue', Sort.asc);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QAfterSortBy> thenByVenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venue', Sort.desc);
    });
  }
}

extension SavedFinalExamQueryWhereDistinct
    on QueryBuilder<SavedFinalExam, SavedFinalExam, QDistinct> {
  QueryBuilder<SavedFinalExam, SavedFinalExam, QDistinct> distinctByCourseCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'courseCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QDistinct> distinctByCourseTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'courseTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QDistinct> distinctByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateTime');
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QDistinct>
      distinctBySeatNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seatNumber');
    });
  }

  QueryBuilder<SavedFinalExam, SavedFinalExam, QDistinct> distinctByVenue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'venue', caseSensitive: caseSensitive);
    });
  }
}

extension SavedFinalExamQueryProperty
    on QueryBuilder<SavedFinalExam, SavedFinalExam, QQueryProperty> {
  QueryBuilder<SavedFinalExam, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SavedFinalExam, String, QQueryOperations> courseCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseCode');
    });
  }

  QueryBuilder<SavedFinalExam, String, QQueryOperations> courseTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseTitle');
    });
  }

  QueryBuilder<SavedFinalExam, DateTime, QQueryOperations> dateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateTime');
    });
  }

  QueryBuilder<SavedFinalExam, int, QQueryOperations> seatNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seatNumber');
    });
  }

  QueryBuilder<SavedFinalExam, String, QQueryOperations> venueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'venue');
    });
  }
}
