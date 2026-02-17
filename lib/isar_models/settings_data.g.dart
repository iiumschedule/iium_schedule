// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSettingsDataCollection on Isar {
  IsarCollection<SettingsData> get settingsDatas => this.collection();
}

const SettingsDataSchema = CollectionSchema(
  name: r'SettingsData',
  id: -966610349317306745,
  properties: {
    r'developerMode': PropertySchema(
      id: 0,
      name: r'developerMode',
      type: IsarType.bool,
    ),
    r'highlightCurrentDay': PropertySchema(
      id: 1,
      name: r'highlightCurrentDay',
      type: IsarType.bool,
    ),
    r'themeSetting': PropertySchema(
      id: 2,
      name: r'themeSetting',
      type: IsarType.byte,
      enumMap: _SettingsDatathemeSettingEnumValueMap,
    )
  },
  estimateSize: _settingsDataEstimateSize,
  serialize: _settingsDataSerialize,
  deserialize: _settingsDataDeserialize,
  deserializeProp: _settingsDataDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _settingsDataGetId,
  getLinks: _settingsDataGetLinks,
  attach: _settingsDataAttach,
  version: '3.3.0',
);

int _settingsDataEstimateSize(
  SettingsData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _settingsDataSerialize(
  SettingsData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.developerMode);
  writer.writeBool(offsets[1], object.highlightCurrentDay);
  writer.writeByte(offsets[2], object.themeSetting.index);
}

SettingsData _settingsDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SettingsData();
  object.developerMode = reader.readBool(offsets[0]);
  object.highlightCurrentDay = reader.readBool(offsets[1]);
  object.id = id;
  object.themeSetting = _SettingsDatathemeSettingValueEnumMap[
          reader.readByteOrNull(offsets[2])] ??
      ThemeMode.system;
  return object;
}

P _settingsDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (_SettingsDatathemeSettingValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ThemeMode.system) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SettingsDatathemeSettingEnumValueMap = {
  'system': 0,
  'light': 1,
  'dark': 2,
};
const _SettingsDatathemeSettingValueEnumMap = {
  0: ThemeMode.system,
  1: ThemeMode.light,
  2: ThemeMode.dark,
};

Id _settingsDataGetId(SettingsData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _settingsDataGetLinks(SettingsData object) {
  return [];
}

void _settingsDataAttach(
    IsarCollection<dynamic> col, Id id, SettingsData object) {
  object.id = id;
}

extension SettingsDataQueryWhereSort
    on QueryBuilder<SettingsData, SettingsData, QWhere> {
  QueryBuilder<SettingsData, SettingsData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SettingsDataQueryWhere
    on QueryBuilder<SettingsData, SettingsData, QWhereClause> {
  QueryBuilder<SettingsData, SettingsData, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<SettingsData, SettingsData, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterWhereClause> idBetween(
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

extension SettingsDataQueryFilter
    on QueryBuilder<SettingsData, SettingsData, QFilterCondition> {
  QueryBuilder<SettingsData, SettingsData, QAfterFilterCondition>
      developerModeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'developerMode',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterFilterCondition>
      highlightCurrentDayEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'highlightCurrentDay',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterFilterCondition> idGreaterThan(
    Id value, {
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

  QueryBuilder<SettingsData, SettingsData, QAfterFilterCondition> idLessThan(
    Id value, {
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

  QueryBuilder<SettingsData, SettingsData, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<SettingsData, SettingsData, QAfterFilterCondition>
      themeSettingEqualTo(ThemeMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'themeSetting',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterFilterCondition>
      themeSettingGreaterThan(
    ThemeMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'themeSetting',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterFilterCondition>
      themeSettingLessThan(
    ThemeMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'themeSetting',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterFilterCondition>
      themeSettingBetween(
    ThemeMode lower,
    ThemeMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'themeSetting',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SettingsDataQueryObject
    on QueryBuilder<SettingsData, SettingsData, QFilterCondition> {}

extension SettingsDataQueryLinks
    on QueryBuilder<SettingsData, SettingsData, QFilterCondition> {}

extension SettingsDataQuerySortBy
    on QueryBuilder<SettingsData, SettingsData, QSortBy> {
  QueryBuilder<SettingsData, SettingsData, QAfterSortBy> sortByDeveloperMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'developerMode', Sort.asc);
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterSortBy>
      sortByDeveloperModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'developerMode', Sort.desc);
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterSortBy>
      sortByHighlightCurrentDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highlightCurrentDay', Sort.asc);
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterSortBy>
      sortByHighlightCurrentDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highlightCurrentDay', Sort.desc);
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterSortBy> sortByThemeSetting() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeSetting', Sort.asc);
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterSortBy>
      sortByThemeSettingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeSetting', Sort.desc);
    });
  }
}

extension SettingsDataQuerySortThenBy
    on QueryBuilder<SettingsData, SettingsData, QSortThenBy> {
  QueryBuilder<SettingsData, SettingsData, QAfterSortBy> thenByDeveloperMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'developerMode', Sort.asc);
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterSortBy>
      thenByDeveloperModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'developerMode', Sort.desc);
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterSortBy>
      thenByHighlightCurrentDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highlightCurrentDay', Sort.asc);
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterSortBy>
      thenByHighlightCurrentDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highlightCurrentDay', Sort.desc);
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterSortBy> thenByThemeSetting() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeSetting', Sort.asc);
    });
  }

  QueryBuilder<SettingsData, SettingsData, QAfterSortBy>
      thenByThemeSettingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeSetting', Sort.desc);
    });
  }
}

extension SettingsDataQueryWhereDistinct
    on QueryBuilder<SettingsData, SettingsData, QDistinct> {
  QueryBuilder<SettingsData, SettingsData, QDistinct>
      distinctByDeveloperMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'developerMode');
    });
  }

  QueryBuilder<SettingsData, SettingsData, QDistinct>
      distinctByHighlightCurrentDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'highlightCurrentDay');
    });
  }

  QueryBuilder<SettingsData, SettingsData, QDistinct> distinctByThemeSetting() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'themeSetting');
    });
  }
}

extension SettingsDataQueryProperty
    on QueryBuilder<SettingsData, SettingsData, QQueryProperty> {
  QueryBuilder<SettingsData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SettingsData, bool, QQueryOperations> developerModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'developerMode');
    });
  }

  QueryBuilder<SettingsData, bool, QQueryOperations>
      highlightCurrentDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'highlightCurrentDay');
    });
  }

  QueryBuilder<SettingsData, ThemeMode, QQueryOperations>
      themeSettingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themeSetting');
    });
  }
}
