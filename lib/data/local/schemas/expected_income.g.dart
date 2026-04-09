// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expected_income.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetExpectedIncomeCollection on Isar {
  IsarCollection<ExpectedIncome> get expectedIncomes => this.collection();
}

const ExpectedIncomeSchema = CollectionSchema(
  name: r'ExpectedIncome',
  id: -6364212104182460039,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.double,
    ),
    r'expectedDate': PropertySchema(
      id: 1,
      name: r'expectedDate',
      type: IsarType.dateTime,
    ),
    r'isMatched': PropertySchema(
      id: 2,
      name: r'isMatched',
      type: IsarType.bool,
    ),
    r'matchedDate': PropertySchema(
      id: 3,
      name: r'matchedDate',
      type: IsarType.dateTime,
    ),
    r'sourceLabel': PropertySchema(
      id: 4,
      name: r'sourceLabel',
      type: IsarType.string,
    )
  },
  estimateSize: _expectedIncomeEstimateSize,
  serialize: _expectedIncomeSerialize,
  deserialize: _expectedIncomeDeserialize,
  deserializeProp: _expectedIncomeDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _expectedIncomeGetId,
  getLinks: _expectedIncomeGetLinks,
  attach: _expectedIncomeAttach,
  version: '3.1.0+1',
);

int _expectedIncomeEstimateSize(
  ExpectedIncome object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.sourceLabel.length * 3;
  return bytesCount;
}

void _expectedIncomeSerialize(
  ExpectedIncome object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeDateTime(offsets[1], object.expectedDate);
  writer.writeBool(offsets[2], object.isMatched);
  writer.writeDateTime(offsets[3], object.matchedDate);
  writer.writeString(offsets[4], object.sourceLabel);
}

ExpectedIncome _expectedIncomeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ExpectedIncome();
  object.amount = reader.readDouble(offsets[0]);
  object.expectedDate = reader.readDateTime(offsets[1]);
  object.id = id;
  object.isMatched = reader.readBool(offsets[2]);
  object.matchedDate = reader.readDateTimeOrNull(offsets[3]);
  object.sourceLabel = reader.readString(offsets[4]);
  return object;
}

P _expectedIncomeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _expectedIncomeGetId(ExpectedIncome object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _expectedIncomeGetLinks(ExpectedIncome object) {
  return [];
}

void _expectedIncomeAttach(
    IsarCollection<dynamic> col, Id id, ExpectedIncome object) {
  object.id = id;
}

extension ExpectedIncomeQueryWhereSort
    on QueryBuilder<ExpectedIncome, ExpectedIncome, QWhere> {
  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ExpectedIncomeQueryWhere
    on QueryBuilder<ExpectedIncome, ExpectedIncome, QWhereClause> {
  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterWhereClause> idBetween(
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

extension ExpectedIncomeQueryFilter
    on QueryBuilder<ExpectedIncome, ExpectedIncome, QFilterCondition> {
  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      amountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      expectedDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expectedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      expectedDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expectedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      expectedDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expectedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      expectedDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expectedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      isMatchedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isMatched',
        value: value,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      matchedDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'matchedDate',
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      matchedDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'matchedDate',
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      matchedDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matchedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      matchedDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'matchedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      matchedDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'matchedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      matchedDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'matchedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      sourceLabelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      sourceLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      sourceLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      sourceLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      sourceLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      sourceLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      sourceLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      sourceLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      sourceLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterFilterCondition>
      sourceLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceLabel',
        value: '',
      ));
    });
  }
}

extension ExpectedIncomeQueryObject
    on QueryBuilder<ExpectedIncome, ExpectedIncome, QFilterCondition> {}

extension ExpectedIncomeQueryLinks
    on QueryBuilder<ExpectedIncome, ExpectedIncome, QFilterCondition> {}

extension ExpectedIncomeQuerySortBy
    on QueryBuilder<ExpectedIncome, ExpectedIncome, QSortBy> {
  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy>
      sortByExpectedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedDate', Sort.asc);
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy>
      sortByExpectedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedDate', Sort.desc);
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy> sortByIsMatched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMatched', Sort.asc);
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy>
      sortByIsMatchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMatched', Sort.desc);
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy>
      sortByMatchedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchedDate', Sort.asc);
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy>
      sortByMatchedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchedDate', Sort.desc);
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy>
      sortBySourceLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceLabel', Sort.asc);
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy>
      sortBySourceLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceLabel', Sort.desc);
    });
  }
}

extension ExpectedIncomeQuerySortThenBy
    on QueryBuilder<ExpectedIncome, ExpectedIncome, QSortThenBy> {
  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy>
      thenByExpectedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedDate', Sort.asc);
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy>
      thenByExpectedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedDate', Sort.desc);
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy> thenByIsMatched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMatched', Sort.asc);
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy>
      thenByIsMatchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMatched', Sort.desc);
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy>
      thenByMatchedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchedDate', Sort.asc);
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy>
      thenByMatchedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchedDate', Sort.desc);
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy>
      thenBySourceLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceLabel', Sort.asc);
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QAfterSortBy>
      thenBySourceLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceLabel', Sort.desc);
    });
  }
}

extension ExpectedIncomeQueryWhereDistinct
    on QueryBuilder<ExpectedIncome, ExpectedIncome, QDistinct> {
  QueryBuilder<ExpectedIncome, ExpectedIncome, QDistinct> distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QDistinct>
      distinctByExpectedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expectedDate');
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QDistinct>
      distinctByIsMatched() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMatched');
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QDistinct>
      distinctByMatchedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'matchedDate');
    });
  }

  QueryBuilder<ExpectedIncome, ExpectedIncome, QDistinct> distinctBySourceLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceLabel', caseSensitive: caseSensitive);
    });
  }
}

extension ExpectedIncomeQueryProperty
    on QueryBuilder<ExpectedIncome, ExpectedIncome, QQueryProperty> {
  QueryBuilder<ExpectedIncome, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ExpectedIncome, double, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<ExpectedIncome, DateTime, QQueryOperations>
      expectedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expectedDate');
    });
  }

  QueryBuilder<ExpectedIncome, bool, QQueryOperations> isMatchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMatched');
    });
  }

  QueryBuilder<ExpectedIncome, DateTime?, QQueryOperations>
      matchedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'matchedDate');
    });
  }

  QueryBuilder<ExpectedIncome, String, QQueryOperations> sourceLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceLabel');
    });
  }
}
