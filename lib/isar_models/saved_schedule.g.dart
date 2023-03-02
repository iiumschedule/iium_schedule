// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_schedule.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetSavedScheduleCollection on Isar {
  IsarCollection<SavedSchedule> get savedSchedules => this.collection();
}

const SavedScheduleSchema = CollectionSchema(
  name: r'SavedSchedule',
  id: -7759702427371613861,
  properties: {
    r'dateCreated': PropertySchema(
      id: 0,
      name: r'dateCreated',
      type: IsarType.dateTime,
    ),
    r'extraInfo': PropertySchema(
      id: 1,
      name: r'extraInfo',
      type: IsarType.byte,
      enumMap: _SavedScheduleextraInfoEnumValueMap,
    ),
    r'fontSize': PropertySchema(
      id: 2,
      name: r'fontSize',
      type: IsarType.double,
    ),
    r'heightFactor': PropertySchema(
      id: 3,
      name: r'heightFactor',
      type: IsarType.double,
    ),
    r'kuliyyah': PropertySchema(
      id: 4,
      name: r'kuliyyah',
      type: IsarType.string,
    ),
    r'lastModified': PropertySchema(
      id: 5,
      name: r'lastModified',
      type: IsarType.dateTime,
    ),
    r'semester': PropertySchema(
      id: 6,
      name: r'semester',
      type: IsarType.byte,
    ),
    r'session': PropertySchema(
      id: 7,
      name: r'session',
      type: IsarType.string,
    ),
    r'subjectTitleSetting': PropertySchema(
      id: 8,
      name: r'subjectTitleSetting',
      type: IsarType.byte,
      enumMap: _SavedSchedulesubjectTitleSettingEnumValueMap,
    ),
    r'title': PropertySchema(
      id: 9,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _savedScheduleEstimateSize,
  serialize: _savedScheduleSerialize,
  deserialize: _savedScheduleDeserialize,
  deserializeProp: _savedScheduleDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'subjects': LinkSchema(
      id: 2193976208394304812,
      name: r'subjects',
      target: r'SavedSubject',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _savedScheduleGetId,
  getLinks: _savedScheduleGetLinks,
  attach: _savedScheduleAttach,
  version: '3.0.5',
);

int _savedScheduleEstimateSize(
  SavedSchedule object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.kuliyyah;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.session.length * 3;
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _savedScheduleSerialize(
  SavedSchedule object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dateCreated);
  writer.writeByte(offsets[1], object.extraInfo.index);
  writer.writeDouble(offsets[2], object.fontSize);
  writer.writeDouble(offsets[3], object.heightFactor);
  writer.writeString(offsets[4], object.kuliyyah);
  writer.writeDateTime(offsets[5], object.lastModified);
  writer.writeByte(offsets[6], object.semester);
  writer.writeString(offsets[7], object.session);
  writer.writeByte(offsets[8], object.subjectTitleSetting.index);
  writer.writeString(offsets[9], object.title);
}

SavedSchedule _savedScheduleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SavedSchedule(
    dateCreated: reader.readDateTime(offsets[0]),
    extraInfo: _SavedScheduleextraInfoValueEnumMap[
            reader.readByteOrNull(offsets[1])] ??
        ExtraInfo.venue,
    fontSize: reader.readDouble(offsets[2]),
    heightFactor: reader.readDouble(offsets[3]),
    kuliyyah: reader.readStringOrNull(offsets[4]),
    lastModified: reader.readDateTime(offsets[5]),
    semester: reader.readByte(offsets[6]),
    session: reader.readString(offsets[7]),
    subjectTitleSetting: _SavedSchedulesubjectTitleSettingValueEnumMap[
            reader.readByteOrNull(offsets[8])] ??
        SubjectTitleSetting.title,
    title: reader.readStringOrNull(offsets[9]),
  );
  object.id = id;
  return object;
}

P _savedScheduleDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (_SavedScheduleextraInfoValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ExtraInfo.venue) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readByte(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (_SavedSchedulesubjectTitleSettingValueEnumMap[
              reader.readByteOrNull(offset)] ??
          SubjectTitleSetting.title) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SavedScheduleextraInfoEnumValueMap = {
  'venue': 0,
  'section': 1,
  'none': 2,
};
const _SavedScheduleextraInfoValueEnumMap = {
  0: ExtraInfo.venue,
  1: ExtraInfo.section,
  2: ExtraInfo.none,
};
const _SavedSchedulesubjectTitleSettingEnumValueMap = {
  'title': 0,
  'courseCode': 1,
};
const _SavedSchedulesubjectTitleSettingValueEnumMap = {
  0: SubjectTitleSetting.title,
  1: SubjectTitleSetting.courseCode,
};

Id _savedScheduleGetId(SavedSchedule object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _savedScheduleGetLinks(SavedSchedule object) {
  return [object.subjects];
}

void _savedScheduleAttach(
    IsarCollection<dynamic> col, Id id, SavedSchedule object) {
  object.id = id;
  object.subjects
      .attach(col, col.isar.collection<SavedSubject>(), r'subjects', id);
}

extension SavedScheduleQueryWhereSort
    on QueryBuilder<SavedSchedule, SavedSchedule, QWhere> {
  QueryBuilder<SavedSchedule, SavedSchedule, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SavedScheduleQueryWhere
    on QueryBuilder<SavedSchedule, SavedSchedule, QWhereClause> {
  QueryBuilder<SavedSchedule, SavedSchedule, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterWhereClause> idBetween(
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

extension SavedScheduleQueryFilter
    on QueryBuilder<SavedSchedule, SavedSchedule, QFilterCondition> {
  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      dateCreatedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      dateCreatedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      dateCreatedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      dateCreatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateCreated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      extraInfoEqualTo(ExtraInfo value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'extraInfo',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      extraInfoGreaterThan(
    ExtraInfo value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'extraInfo',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      extraInfoLessThan(
    ExtraInfo value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'extraInfo',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      extraInfoBetween(
    ExtraInfo lower,
    ExtraInfo upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'extraInfo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      fontSizeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      fontSizeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fontSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      fontSizeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fontSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      fontSizeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fontSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      heightFactorEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'heightFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      heightFactorGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'heightFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      heightFactorLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'heightFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      heightFactorBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'heightFactor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
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

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      kuliyyahIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'kuliyyah',
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      kuliyyahIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'kuliyyah',
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      kuliyyahEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kuliyyah',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      kuliyyahGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kuliyyah',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      kuliyyahLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kuliyyah',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      kuliyyahBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kuliyyah',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      kuliyyahStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'kuliyyah',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      kuliyyahEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'kuliyyah',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      kuliyyahContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'kuliyyah',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      kuliyyahMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'kuliyyah',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      kuliyyahIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kuliyyah',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      kuliyyahIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'kuliyyah',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      lastModifiedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastModified',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      lastModifiedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastModified',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      lastModifiedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastModified',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      lastModifiedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastModified',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      semesterEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'semester',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
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

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
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

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
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

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
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

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
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

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
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

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
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

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
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

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
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

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      sessionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'session',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      sessionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'session',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      sessionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'session',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      sessionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'session',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      subjectTitleSettingEqualTo(SubjectTitleSetting value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subjectTitleSetting',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      subjectTitleSettingGreaterThan(
    SubjectTitleSetting value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subjectTitleSetting',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      subjectTitleSettingLessThan(
    SubjectTitleSetting value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subjectTitleSetting',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      subjectTitleSettingBetween(
    SubjectTitleSetting lower,
    SubjectTitleSetting upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subjectTitleSetting',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      titleEqualTo(
    String? value, {
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

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      titleGreaterThan(
    String? value, {
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

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      titleLessThan(
    String? value, {
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

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      titleBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
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

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      titleEndsWith(
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

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension SavedScheduleQueryObject
    on QueryBuilder<SavedSchedule, SavedSchedule, QFilterCondition> {}

extension SavedScheduleQueryLinks
    on QueryBuilder<SavedSchedule, SavedSchedule, QFilterCondition> {
  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition> subjects(
      FilterQuery<SavedSubject> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'subjects');
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      subjectsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subjects', length, true, length, true);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      subjectsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subjects', 0, true, 0, true);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      subjectsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subjects', 0, false, 999999, true);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      subjectsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subjects', 0, true, length, include);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      subjectsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subjects', length, include, 999999, true);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterFilterCondition>
      subjectsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'subjects', lower, includeLower, upper, includeUpper);
    });
  }
}

extension SavedScheduleQuerySortBy
    on QueryBuilder<SavedSchedule, SavedSchedule, QSortBy> {
  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy> sortByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      sortByDateCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.desc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy> sortByExtraInfo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraInfo', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      sortByExtraInfoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraInfo', Sort.desc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy> sortByFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontSize', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      sortByFontSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontSize', Sort.desc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      sortByHeightFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heightFactor', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      sortByHeightFactorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heightFactor', Sort.desc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy> sortByKuliyyah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kuliyyah', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      sortByKuliyyahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kuliyyah', Sort.desc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      sortByLastModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastModified', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      sortByLastModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastModified', Sort.desc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy> sortBySemester() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'semester', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      sortBySemesterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'semester', Sort.desc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy> sortBySession() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'session', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy> sortBySessionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'session', Sort.desc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      sortBySubjectTitleSetting() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subjectTitleSetting', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      sortBySubjectTitleSettingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subjectTitleSetting', Sort.desc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension SavedScheduleQuerySortThenBy
    on QueryBuilder<SavedSchedule, SavedSchedule, QSortThenBy> {
  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy> thenByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      thenByDateCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.desc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy> thenByExtraInfo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraInfo', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      thenByExtraInfoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraInfo', Sort.desc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy> thenByFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontSize', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      thenByFontSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontSize', Sort.desc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      thenByHeightFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heightFactor', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      thenByHeightFactorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heightFactor', Sort.desc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy> thenByKuliyyah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kuliyyah', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      thenByKuliyyahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kuliyyah', Sort.desc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      thenByLastModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastModified', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      thenByLastModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastModified', Sort.desc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy> thenBySemester() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'semester', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      thenBySemesterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'semester', Sort.desc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy> thenBySession() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'session', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy> thenBySessionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'session', Sort.desc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      thenBySubjectTitleSetting() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subjectTitleSetting', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy>
      thenBySubjectTitleSettingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subjectTitleSetting', Sort.desc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension SavedScheduleQueryWhereDistinct
    on QueryBuilder<SavedSchedule, SavedSchedule, QDistinct> {
  QueryBuilder<SavedSchedule, SavedSchedule, QDistinct>
      distinctByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateCreated');
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QDistinct> distinctByExtraInfo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'extraInfo');
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QDistinct> distinctByFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fontSize');
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QDistinct>
      distinctByHeightFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'heightFactor');
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QDistinct> distinctByKuliyyah(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kuliyyah', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QDistinct>
      distinctByLastModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastModified');
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QDistinct> distinctBySemester() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'semester');
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QDistinct> distinctBySession(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'session', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QDistinct>
      distinctBySubjectTitleSetting() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subjectTitleSetting');
    });
  }

  QueryBuilder<SavedSchedule, SavedSchedule, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension SavedScheduleQueryProperty
    on QueryBuilder<SavedSchedule, SavedSchedule, QQueryProperty> {
  QueryBuilder<SavedSchedule, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SavedSchedule, DateTime, QQueryOperations>
      dateCreatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateCreated');
    });
  }

  QueryBuilder<SavedSchedule, ExtraInfo, QQueryOperations> extraInfoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'extraInfo');
    });
  }

  QueryBuilder<SavedSchedule, double, QQueryOperations> fontSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fontSize');
    });
  }

  QueryBuilder<SavedSchedule, double, QQueryOperations> heightFactorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'heightFactor');
    });
  }

  QueryBuilder<SavedSchedule, String?, QQueryOperations> kuliyyahProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kuliyyah');
    });
  }

  QueryBuilder<SavedSchedule, DateTime, QQueryOperations>
      lastModifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastModified');
    });
  }

  QueryBuilder<SavedSchedule, int, QQueryOperations> semesterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'semester');
    });
  }

  QueryBuilder<SavedSchedule, String, QQueryOperations> sessionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'session');
    });
  }

  QueryBuilder<SavedSchedule, SubjectTitleSetting, QQueryOperations>
      subjectTitleSettingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subjectTitleSetting');
    });
  }

  QueryBuilder<SavedSchedule, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
