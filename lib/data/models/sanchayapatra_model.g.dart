// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sanchayapatra_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSanchayapatraModelCollection on Isar {
  IsarCollection<SanchayapatraModel> get sanchayapatraModels =>
      this.collection();
}

const SanchayapatraModelSchema = CollectionSchema(
  name: r'SanchayapatraModel',
  id: -4475373653782265037,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'isActive': PropertySchema(
      id: 1,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'maturityDate': PropertySchema(
      id: 2,
      name: r'maturityDate',
      type: IsarType.dateTime,
    ),
    r'notes': PropertySchema(
      id: 3,
      name: r'notes',
      type: IsarType.string,
    ),
    r'profitRate': PropertySchema(
      id: 4,
      name: r'profitRate',
      type: IsarType.double,
    ),
    r'purchaseAmount': PropertySchema(
      id: 5,
      name: r'purchaseAmount',
      type: IsarType.double,
    ),
    r'purchaseDate': PropertySchema(
      id: 6,
      name: r'purchaseDate',
      type: IsarType.dateTime,
    ),
    r'schemeName': PropertySchema(
      id: 7,
      name: r'schemeName',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 8,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _sanchayapatraModelEstimateSize,
  serialize: _sanchayapatraModelSerialize,
  deserialize: _sanchayapatraModelDeserialize,
  deserializeProp: _sanchayapatraModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'purchaseDate': IndexSchema(
      id: 1174684625301313566,
      name: r'purchaseDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'purchaseDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _sanchayapatraModelGetId,
  getLinks: _sanchayapatraModelGetLinks,
  attach: _sanchayapatraModelAttach,
  version: '3.1.0+1',
);

int _sanchayapatraModelEstimateSize(
  SanchayapatraModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.schemeName.length * 3;
  return bytesCount;
}

void _sanchayapatraModelSerialize(
  SanchayapatraModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeBool(offsets[1], object.isActive);
  writer.writeDateTime(offsets[2], object.maturityDate);
  writer.writeString(offsets[3], object.notes);
  writer.writeDouble(offsets[4], object.profitRate);
  writer.writeDouble(offsets[5], object.purchaseAmount);
  writer.writeDateTime(offsets[6], object.purchaseDate);
  writer.writeString(offsets[7], object.schemeName);
  writer.writeDateTime(offsets[8], object.updatedAt);
}

SanchayapatraModel _sanchayapatraModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SanchayapatraModel();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.isActive = reader.readBool(offsets[1]);
  object.maturityDate = reader.readDateTime(offsets[2]);
  object.notes = reader.readStringOrNull(offsets[3]);
  object.profitRate = reader.readDouble(offsets[4]);
  object.purchaseAmount = reader.readDouble(offsets[5]);
  object.purchaseDate = reader.readDateTime(offsets[6]);
  object.schemeName = reader.readString(offsets[7]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[8]);
  return object;
}

P _sanchayapatraModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sanchayapatraModelGetId(SanchayapatraModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sanchayapatraModelGetLinks(
    SanchayapatraModel object) {
  return [];
}

void _sanchayapatraModelAttach(
    IsarCollection<dynamic> col, Id id, SanchayapatraModel object) {
  object.id = id;
}

extension SanchayapatraModelQueryWhereSort
    on QueryBuilder<SanchayapatraModel, SanchayapatraModel, QWhere> {
  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterWhere>
      anyPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'purchaseDate'),
      );
    });
  }
}

extension SanchayapatraModelQueryWhere
    on QueryBuilder<SanchayapatraModel, SanchayapatraModel, QWhereClause> {
  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterWhereClause>
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

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterWhereClause>
      purchaseDateEqualTo(DateTime purchaseDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'purchaseDate',
        value: [purchaseDate],
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterWhereClause>
      purchaseDateNotEqualTo(DateTime purchaseDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'purchaseDate',
              lower: [],
              upper: [purchaseDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'purchaseDate',
              lower: [purchaseDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'purchaseDate',
              lower: [purchaseDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'purchaseDate',
              lower: [],
              upper: [purchaseDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterWhereClause>
      purchaseDateGreaterThan(
    DateTime purchaseDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'purchaseDate',
        lower: [purchaseDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterWhereClause>
      purchaseDateLessThan(
    DateTime purchaseDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'purchaseDate',
        lower: [],
        upper: [purchaseDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterWhereClause>
      purchaseDateBetween(
    DateTime lowerPurchaseDate,
    DateTime upperPurchaseDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'purchaseDate',
        lower: [lowerPurchaseDate],
        includeLower: includeLower,
        upper: [upperPurchaseDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SanchayapatraModelQueryFilter
    on QueryBuilder<SanchayapatraModel, SanchayapatraModel, QFilterCondition> {
  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
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

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
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

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      maturityDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maturityDate',
        value: value,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      maturityDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maturityDate',
        value: value,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      maturityDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maturityDate',
        value: value,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      maturityDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maturityDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      profitRateEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profitRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      profitRateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'profitRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      profitRateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'profitRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      profitRateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'profitRate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      purchaseAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaseAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      purchaseAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purchaseAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      purchaseAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purchaseAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      purchaseAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purchaseAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      purchaseDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      purchaseDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purchaseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      purchaseDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purchaseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      purchaseDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purchaseDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      schemeNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'schemeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      schemeNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'schemeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      schemeNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'schemeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      schemeNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'schemeName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      schemeNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'schemeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      schemeNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'schemeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      schemeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'schemeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      schemeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'schemeName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      schemeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'schemeName',
        value: '',
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      schemeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'schemeName',
        value: '',
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterFilterCondition>
      updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SanchayapatraModelQueryObject
    on QueryBuilder<SanchayapatraModel, SanchayapatraModel, QFilterCondition> {}

extension SanchayapatraModelQueryLinks
    on QueryBuilder<SanchayapatraModel, SanchayapatraModel, QFilterCondition> {}

extension SanchayapatraModelQuerySortBy
    on QueryBuilder<SanchayapatraModel, SanchayapatraModel, QSortBy> {
  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      sortByMaturityDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maturityDate', Sort.asc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      sortByMaturityDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maturityDate', Sort.desc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      sortByProfitRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profitRate', Sort.asc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      sortByProfitRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profitRate', Sort.desc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      sortByPurchaseAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseAmount', Sort.asc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      sortByPurchaseAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseAmount', Sort.desc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      sortByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.asc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      sortByPurchaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.desc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      sortBySchemeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemeName', Sort.asc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      sortBySchemeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemeName', Sort.desc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SanchayapatraModelQuerySortThenBy
    on QueryBuilder<SanchayapatraModel, SanchayapatraModel, QSortThenBy> {
  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      thenByMaturityDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maturityDate', Sort.asc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      thenByMaturityDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maturityDate', Sort.desc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      thenByProfitRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profitRate', Sort.asc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      thenByProfitRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profitRate', Sort.desc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      thenByPurchaseAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseAmount', Sort.asc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      thenByPurchaseAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseAmount', Sort.desc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      thenByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.asc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      thenByPurchaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.desc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      thenBySchemeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemeName', Sort.asc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      thenBySchemeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemeName', Sort.desc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SanchayapatraModelQueryWhereDistinct
    on QueryBuilder<SanchayapatraModel, SanchayapatraModel, QDistinct> {
  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QDistinct>
      distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QDistinct>
      distinctByMaturityDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maturityDate');
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QDistinct>
      distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QDistinct>
      distinctByProfitRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profitRate');
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QDistinct>
      distinctByPurchaseAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchaseAmount');
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QDistinct>
      distinctByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchaseDate');
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QDistinct>
      distinctBySchemeName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'schemeName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SanchayapatraModel, SanchayapatraModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension SanchayapatraModelQueryProperty
    on QueryBuilder<SanchayapatraModel, SanchayapatraModel, QQueryProperty> {
  QueryBuilder<SanchayapatraModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SanchayapatraModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<SanchayapatraModel, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<SanchayapatraModel, DateTime, QQueryOperations>
      maturityDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maturityDate');
    });
  }

  QueryBuilder<SanchayapatraModel, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<SanchayapatraModel, double, QQueryOperations>
      profitRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profitRate');
    });
  }

  QueryBuilder<SanchayapatraModel, double, QQueryOperations>
      purchaseAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchaseAmount');
    });
  }

  QueryBuilder<SanchayapatraModel, DateTime, QQueryOperations>
      purchaseDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchaseDate');
    });
  }

  QueryBuilder<SanchayapatraModel, String, QQueryOperations>
      schemeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'schemeName');
    });
  }

  QueryBuilder<SanchayapatraModel, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
