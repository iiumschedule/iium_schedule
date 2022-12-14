// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gh_responses.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetGhResponsesCollection on Isar {
  IsarCollection<GhResponses> get ghResponses => this.collection();
}

const GhResponsesSchema = CollectionSchema(
  name: r'GhResponses',
  id: -7110545177925462396,
  properties: {
    r'body': PropertySchema(
      id: 0,
      name: r'body',
      type: IsarType.string,
    ),
    r'etag': PropertySchema(
      id: 1,
      name: r'etag',
      type: IsarType.string,
    )
  },
  estimateSize: _ghResponsesEstimateSize,
  serialize: _ghResponsesSerialize,
  deserialize: _ghResponsesDeserialize,
  deserializeProp: _ghResponsesDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _ghResponsesGetId,
  getLinks: _ghResponsesGetLinks,
  attach: _ghResponsesAttach,
  version: '3.0.5',
);

int _ghResponsesEstimateSize(
  GhResponses object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.body.length * 3;
  bytesCount += 3 + object.etag.length * 3;
  return bytesCount;
}

void _ghResponsesSerialize(
  GhResponses object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.body);
  writer.writeString(offsets[1], object.etag);
}

GhResponses _ghResponsesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GhResponses(
    body: reader.readString(offsets[0]),
    etag: reader.readString(offsets[1]),
  );
  object.id = id;
  return object;
}

P _ghResponsesDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _ghResponsesGetId(GhResponses object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _ghResponsesGetLinks(GhResponses object) {
  return [];
}

void _ghResponsesAttach(
    IsarCollection<dynamic> col, Id id, GhResponses object) {
  object.id = id;
}

extension GhResponsesQueryWhereSort
    on QueryBuilder<GhResponses, GhResponses, QWhere> {
  QueryBuilder<GhResponses, GhResponses, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GhResponsesQueryWhere
    on QueryBuilder<GhResponses, GhResponses, QWhereClause> {
  QueryBuilder<GhResponses, GhResponses, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<GhResponses, GhResponses, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterWhereClause> idBetween(
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

extension GhResponsesQueryFilter
    on QueryBuilder<GhResponses, GhResponses, QFilterCondition> {
  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> bodyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> bodyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> bodyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> bodyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'body',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> bodyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> bodyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> bodyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> bodyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'body',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> bodyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'body',
        value: '',
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition>
      bodyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'body',
        value: '',
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> etagEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'etag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> etagGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'etag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> etagLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'etag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> etagBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'etag',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> etagStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'etag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> etagEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'etag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> etagContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'etag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> etagMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'etag',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> etagIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'etag',
        value: '',
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition>
      etagIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'etag',
        value: '',
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<GhResponses, GhResponses, QAfterFilterCondition> idBetween(
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
}

extension GhResponsesQueryObject
    on QueryBuilder<GhResponses, GhResponses, QFilterCondition> {}

extension GhResponsesQueryLinks
    on QueryBuilder<GhResponses, GhResponses, QFilterCondition> {}

extension GhResponsesQuerySortBy
    on QueryBuilder<GhResponses, GhResponses, QSortBy> {
  QueryBuilder<GhResponses, GhResponses, QAfterSortBy> sortByBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.asc);
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterSortBy> sortByBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.desc);
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterSortBy> sortByEtag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etag', Sort.asc);
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterSortBy> sortByEtagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etag', Sort.desc);
    });
  }
}

extension GhResponsesQuerySortThenBy
    on QueryBuilder<GhResponses, GhResponses, QSortThenBy> {
  QueryBuilder<GhResponses, GhResponses, QAfterSortBy> thenByBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.asc);
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterSortBy> thenByBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.desc);
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterSortBy> thenByEtag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etag', Sort.asc);
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterSortBy> thenByEtagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etag', Sort.desc);
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GhResponses, GhResponses, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension GhResponsesQueryWhereDistinct
    on QueryBuilder<GhResponses, GhResponses, QDistinct> {
  QueryBuilder<GhResponses, GhResponses, QDistinct> distinctByBody(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'body', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GhResponses, GhResponses, QDistinct> distinctByEtag(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'etag', caseSensitive: caseSensitive);
    });
  }
}

extension GhResponsesQueryProperty
    on QueryBuilder<GhResponses, GhResponses, QQueryProperty> {
  QueryBuilder<GhResponses, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GhResponses, String, QQueryOperations> bodyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'body');
    });
  }

  QueryBuilder<GhResponses, String, QQueryOperations> etagProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'etag');
    });
  }
}
