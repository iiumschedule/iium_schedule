// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_subject.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFavouriteSubjectCollection on Isar {
  IsarCollection<FavouriteSubject> get favouriteSubjects => this.collection();
}

const FavouriteSubjectSchema = CollectionSchema(
  name: r'FavouriteSubject',
  id: 6526992393492842987,
  properties: {
    r'courseCode': PropertySchema(
      id: 0,
      name: r'courseCode',
      type: IsarType.string,
    ),
    r'favouritedDate': PropertySchema(
      id: 1,
      name: r'favouritedDate',
      type: IsarType.dateTime,
    ),
    r'kulliyyahCode': PropertySchema(
      id: 2,
      name: r'kulliyyahCode',
      type: IsarType.string,
    ),
    r'section': PropertySchema(
      id: 3,
      name: r'section',
      type: IsarType.long,
    ),
    r'semester': PropertySchema(
      id: 4,
      name: r'semester',
      type: IsarType.long,
    ),
    r'session': PropertySchema(
      id: 5,
      name: r'session',
      type: IsarType.string,
    )
  },
  estimateSize: _favouriteSubjectEstimateSize,
  serialize: _favouriteSubjectSerialize,
  deserialize: _favouriteSubjectDeserialize,
  deserializeProp: _favouriteSubjectDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _favouriteSubjectGetId,
  getLinks: _favouriteSubjectGetLinks,
  attach: _favouriteSubjectAttach,
  version: '3.3.0',
);

int _favouriteSubjectEstimateSize(
  FavouriteSubject object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.courseCode.length * 3;
  bytesCount += 3 + object.kulliyyahCode.length * 3;
  bytesCount += 3 + object.session.length * 3;
  return bytesCount;
}

void _favouriteSubjectSerialize(
  FavouriteSubject object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.courseCode);
  writer.writeDateTime(offsets[1], object.favouritedDate);
  writer.writeString(offsets[2], object.kulliyyahCode);
  writer.writeLong(offsets[3], object.section);
  writer.writeLong(offsets[4], object.semester);
  writer.writeString(offsets[5], object.session);
}

FavouriteSubject _favouriteSubjectDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FavouriteSubject(
    courseCode: reader.readString(offsets[0]),
    favouritedDate: reader.readDateTime(offsets[1]),
    kulliyyahCode: reader.readString(offsets[2]),
    section: reader.readLong(offsets[3]),
    semester: reader.readLong(offsets[4]),
    session: reader.readString(offsets[5]),
  );
  object.id = id;
  return object;
}

P _favouriteSubjectDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _favouriteSubjectGetId(FavouriteSubject object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _favouriteSubjectGetLinks(FavouriteSubject object) {
  return [];
}

void _favouriteSubjectAttach(
    IsarCollection<dynamic> col, Id id, FavouriteSubject object) {
  object.id = id;
}

extension FavouriteSubjectQueryWhereSort
    on QueryBuilder<FavouriteSubject, FavouriteSubject, QWhere> {
  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FavouriteSubjectQueryWhere
    on QueryBuilder<FavouriteSubject, FavouriteSubject, QWhereClause> {
  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterWhereClause> idBetween(
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

extension FavouriteSubjectQueryFilter
    on QueryBuilder<FavouriteSubject, FavouriteSubject, QFilterCondition> {
  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
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

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
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

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
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

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
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

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
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

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
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

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      courseCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'courseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      courseCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'courseCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      courseCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseCode',
        value: '',
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      courseCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'courseCode',
        value: '',
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      favouritedDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'favouritedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      favouritedDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'favouritedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      favouritedDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'favouritedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      favouritedDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'favouritedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
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

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
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

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      kulliyyahCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kulliyyahCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      kulliyyahCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kulliyyahCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      kulliyyahCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kulliyyahCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      kulliyyahCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kulliyyahCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      kulliyyahCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'kulliyyahCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      kulliyyahCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'kulliyyahCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      kulliyyahCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'kulliyyahCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      kulliyyahCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'kulliyyahCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      kulliyyahCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kulliyyahCode',
        value: '',
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      kulliyyahCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'kulliyyahCode',
        value: '',
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      sectionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'section',
        value: value,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      sectionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'section',
        value: value,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      sectionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'section',
        value: value,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      sectionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'section',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      semesterEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'semester',
        value: value,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      semesterGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'semester',
        value: value,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      semesterLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'semester',
        value: value,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      semesterBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'semester',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      sessionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'session',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      sessionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'session',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      sessionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'session',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      sessionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'session',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      sessionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'session',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      sessionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'session',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      sessionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'session',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      sessionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'session',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      sessionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'session',
        value: '',
      ));
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterFilterCondition>
      sessionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'session',
        value: '',
      ));
    });
  }
}

extension FavouriteSubjectQueryObject
    on QueryBuilder<FavouriteSubject, FavouriteSubject, QFilterCondition> {}

extension FavouriteSubjectQueryLinks
    on QueryBuilder<FavouriteSubject, FavouriteSubject, QFilterCondition> {}

extension FavouriteSubjectQuerySortBy
    on QueryBuilder<FavouriteSubject, FavouriteSubject, QSortBy> {
  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      sortByCourseCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseCode', Sort.asc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      sortByCourseCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseCode', Sort.desc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      sortByFavouritedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favouritedDate', Sort.asc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      sortByFavouritedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favouritedDate', Sort.desc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      sortByKulliyyahCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kulliyyahCode', Sort.asc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      sortByKulliyyahCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kulliyyahCode', Sort.desc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      sortBySection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'section', Sort.asc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      sortBySectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'section', Sort.desc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      sortBySemester() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'semester', Sort.asc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      sortBySemesterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'semester', Sort.desc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      sortBySession() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'session', Sort.asc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      sortBySessionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'session', Sort.desc);
    });
  }
}

extension FavouriteSubjectQuerySortThenBy
    on QueryBuilder<FavouriteSubject, FavouriteSubject, QSortThenBy> {
  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      thenByCourseCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseCode', Sort.asc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      thenByCourseCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseCode', Sort.desc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      thenByFavouritedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favouritedDate', Sort.asc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      thenByFavouritedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favouritedDate', Sort.desc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      thenByKulliyyahCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kulliyyahCode', Sort.asc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      thenByKulliyyahCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kulliyyahCode', Sort.desc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      thenBySection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'section', Sort.asc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      thenBySectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'section', Sort.desc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      thenBySemester() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'semester', Sort.asc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      thenBySemesterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'semester', Sort.desc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      thenBySession() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'session', Sort.asc);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QAfterSortBy>
      thenBySessionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'session', Sort.desc);
    });
  }
}

extension FavouriteSubjectQueryWhereDistinct
    on QueryBuilder<FavouriteSubject, FavouriteSubject, QDistinct> {
  QueryBuilder<FavouriteSubject, FavouriteSubject, QDistinct>
      distinctByCourseCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'courseCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QDistinct>
      distinctByFavouritedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'favouritedDate');
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QDistinct>
      distinctByKulliyyahCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kulliyyahCode',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QDistinct>
      distinctBySection() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'section');
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QDistinct>
      distinctBySemester() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'semester');
    });
  }

  QueryBuilder<FavouriteSubject, FavouriteSubject, QDistinct> distinctBySession(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'session', caseSensitive: caseSensitive);
    });
  }
}

extension FavouriteSubjectQueryProperty
    on QueryBuilder<FavouriteSubject, FavouriteSubject, QQueryProperty> {
  QueryBuilder<FavouriteSubject, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FavouriteSubject, String, QQueryOperations>
      courseCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseCode');
    });
  }

  QueryBuilder<FavouriteSubject, DateTime, QQueryOperations>
      favouritedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'favouritedDate');
    });
  }

  QueryBuilder<FavouriteSubject, String, QQueryOperations>
      kulliyyahCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kulliyyahCode');
    });
  }

  QueryBuilder<FavouriteSubject, int, QQueryOperations> sectionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'section');
    });
  }

  QueryBuilder<FavouriteSubject, int, QQueryOperations> semesterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'semester');
    });
  }

  QueryBuilder<FavouriteSubject, String, QQueryOperations> sessionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'session');
    });
  }
}
