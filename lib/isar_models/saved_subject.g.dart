// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_subject.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSavedSubjectCollection on Isar {
  IsarCollection<SavedSubject> get savedSubjects => this.collection();
}

const SavedSubjectSchema = CollectionSchema(
  name: r'SavedSubject',
  id: 6804106849073268339,
  properties: {
    r'chr': PropertySchema(
      id: 0,
      name: r'chr',
      type: IsarType.float,
    ),
    r'code': PropertySchema(
      id: 1,
      name: r'code',
      type: IsarType.string,
    ),
    r'hashCode': PropertySchema(
      id: 2,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'hexColor': PropertySchema(
      id: 3,
      name: r'hexColor',
      type: IsarType.long,
    ),
    r'lect': PropertySchema(
      id: 4,
      name: r'lect',
      type: IsarType.stringList,
    ),
    r'sect': PropertySchema(
      id: 5,
      name: r'sect',
      type: IsarType.int,
    ),
    r'subjectName': PropertySchema(
      id: 6,
      name: r'subjectName',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 7,
      name: r'title',
      type: IsarType.string,
    ),
    r'venue': PropertySchema(
      id: 8,
      name: r'venue',
      type: IsarType.string,
    )
  },
  estimateSize: _savedSubjectEstimateSize,
  serialize: _savedSubjectSerialize,
  deserialize: _savedSubjectDeserialize,
  deserializeProp: _savedSubjectDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'dayTimes': LinkSchema(
      id: 8651548304613524160,
      name: r'dayTimes',
      target: r'SavedDaytime',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _savedSubjectGetId,
  getLinks: _savedSubjectGetLinks,
  attach: _savedSubjectAttach,
  version: '3.1.0+1',
);

int _savedSubjectEstimateSize(
  SavedSubject object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.code.length * 3;
  bytesCount += 3 + object.lect.length * 3;
  {
    for (var i = 0; i < object.lect.length; i++) {
      final value = object.lect[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.subjectName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  {
    final value = object.venue;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _savedSubjectSerialize(
  SavedSubject object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeFloat(offsets[0], object.chr);
  writer.writeString(offsets[1], object.code);
  writer.writeLong(offsets[2], object.hashCode);
  writer.writeLong(offsets[3], object.hexColor);
  writer.writeStringList(offsets[4], object.lect);
  writer.writeInt(offsets[5], object.sect);
  writer.writeString(offsets[6], object.subjectName);
  writer.writeString(offsets[7], object.title);
  writer.writeString(offsets[8], object.venue);
}

SavedSubject _savedSubjectDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SavedSubject(
    chr: reader.readFloat(offsets[0]),
    code: reader.readString(offsets[1]),
    hexColor: reader.readLongOrNull(offsets[3]),
    lect: reader.readStringList(offsets[4]) ?? [],
    sect: reader.readInt(offsets[5]),
    subjectName: reader.readStringOrNull(offsets[6]),
    title: reader.readString(offsets[7]),
    venue: reader.readStringOrNull(offsets[8]),
  );
  object.id = id;
  return object;
}

P _savedSubjectDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readFloat(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readStringList(offset) ?? []) as P;
    case 5:
      return (reader.readInt(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _savedSubjectGetId(SavedSubject object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _savedSubjectGetLinks(SavedSubject object) {
  return [object.dayTimes];
}

void _savedSubjectAttach(
    IsarCollection<dynamic> col, Id id, SavedSubject object) {
  object.id = id;
  object.dayTimes
      .attach(col, col.isar.collection<SavedDaytime>(), r'dayTimes', id);
}

extension SavedSubjectQueryWhereSort
    on QueryBuilder<SavedSubject, SavedSubject, QWhere> {
  QueryBuilder<SavedSubject, SavedSubject, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SavedSubjectQueryWhere
    on QueryBuilder<SavedSubject, SavedSubject, QWhereClause> {
  QueryBuilder<SavedSubject, SavedSubject, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<SavedSubject, SavedSubject, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterWhereClause> idBetween(
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

extension SavedSubjectQueryFilter
    on QueryBuilder<SavedSubject, SavedSubject, QFilterCondition> {
  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> chrEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chr',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      chrGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chr',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> chrLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chr',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> chrBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> codeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      codeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> codeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> codeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'code',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      codeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> codeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> codeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> codeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'code',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      codeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      codeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      hexColorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hexColor',
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      hexColorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'hexColor',
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      hexColorEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hexColor',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      hexColorGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hexColor',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      hexColorLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hexColor',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      hexColorBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hexColor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      lectElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lect',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      lectElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lect',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      lectElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lect',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      lectElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lect',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      lectElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lect',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      lectElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lect',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      lectElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lect',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      lectElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lect',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      lectElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lect',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      lectElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lect',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      lectLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lect',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      lectIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lect',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      lectIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lect',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      lectLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lect',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      lectLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lect',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      lectLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lect',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> sectEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sect',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      sectGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sect',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> sectLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sect',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> sectBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sect',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      subjectNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'subjectName',
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      subjectNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'subjectName',
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      subjectNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subjectName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      subjectNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subjectName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      subjectNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subjectName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      subjectNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subjectName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      subjectNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'subjectName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      subjectNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'subjectName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      subjectNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'subjectName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      subjectNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'subjectName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      subjectNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subjectName',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      subjectNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'subjectName',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      venueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'venue',
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      venueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'venue',
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> venueEqualTo(
    String? value, {
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

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      venueGreaterThan(
    String? value, {
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

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> venueLessThan(
    String? value, {
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

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> venueBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
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

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> venueEndsWith(
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

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> venueContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'venue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> venueMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'venue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      venueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'venue',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      venueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'venue',
        value: '',
      ));
    });
  }
}

extension SavedSubjectQueryObject
    on QueryBuilder<SavedSubject, SavedSubject, QFilterCondition> {}

extension SavedSubjectQueryLinks
    on QueryBuilder<SavedSubject, SavedSubject, QFilterCondition> {
  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition> dayTimes(
      FilterQuery<SavedDaytime> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'dayTimes');
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      dayTimesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'dayTimes', length, true, length, true);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      dayTimesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'dayTimes', 0, true, 0, true);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      dayTimesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'dayTimes', 0, false, 999999, true);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      dayTimesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'dayTimes', 0, true, length, include);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      dayTimesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'dayTimes', length, include, 999999, true);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterFilterCondition>
      dayTimesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'dayTimes', lower, includeLower, upper, includeUpper);
    });
  }
}

extension SavedSubjectQuerySortBy
    on QueryBuilder<SavedSubject, SavedSubject, QSortBy> {
  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> sortByChr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chr', Sort.asc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> sortByChrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chr', Sort.desc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> sortByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> sortByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> sortByHexColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexColor', Sort.asc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> sortByHexColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexColor', Sort.desc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> sortBySect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sect', Sort.asc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> sortBySectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sect', Sort.desc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> sortBySubjectName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subjectName', Sort.asc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy>
      sortBySubjectNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subjectName', Sort.desc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> sortByVenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venue', Sort.asc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> sortByVenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venue', Sort.desc);
    });
  }
}

extension SavedSubjectQuerySortThenBy
    on QueryBuilder<SavedSubject, SavedSubject, QSortThenBy> {
  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> thenByChr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chr', Sort.asc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> thenByChrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chr', Sort.desc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> thenByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> thenByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> thenByHexColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexColor', Sort.asc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> thenByHexColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexColor', Sort.desc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> thenBySect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sect', Sort.asc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> thenBySectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sect', Sort.desc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> thenBySubjectName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subjectName', Sort.asc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy>
      thenBySubjectNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subjectName', Sort.desc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> thenByVenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venue', Sort.asc);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QAfterSortBy> thenByVenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venue', Sort.desc);
    });
  }
}

extension SavedSubjectQueryWhereDistinct
    on QueryBuilder<SavedSubject, SavedSubject, QDistinct> {
  QueryBuilder<SavedSubject, SavedSubject, QDistinct> distinctByChr() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chr');
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QDistinct> distinctByCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'code', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QDistinct> distinctByHexColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hexColor');
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QDistinct> distinctByLect() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lect');
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QDistinct> distinctBySect() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sect');
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QDistinct> distinctBySubjectName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subjectName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedSubject, SavedSubject, QDistinct> distinctByVenue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'venue', caseSensitive: caseSensitive);
    });
  }
}

extension SavedSubjectQueryProperty
    on QueryBuilder<SavedSubject, SavedSubject, QQueryProperty> {
  QueryBuilder<SavedSubject, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SavedSubject, double, QQueryOperations> chrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chr');
    });
  }

  QueryBuilder<SavedSubject, String, QQueryOperations> codeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'code');
    });
  }

  QueryBuilder<SavedSubject, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<SavedSubject, int?, QQueryOperations> hexColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hexColor');
    });
  }

  QueryBuilder<SavedSubject, List<String>, QQueryOperations> lectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lect');
    });
  }

  QueryBuilder<SavedSubject, int, QQueryOperations> sectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sect');
    });
  }

  QueryBuilder<SavedSubject, String?, QQueryOperations> subjectNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subjectName');
    });
  }

  QueryBuilder<SavedSubject, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<SavedSubject, String?, QQueryOperations> venueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'venue');
    });
  }
}
