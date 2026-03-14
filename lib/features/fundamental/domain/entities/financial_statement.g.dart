// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_statement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FinancialStatementImpl _$$FinancialStatementImplFromJson(
  Map<String, dynamic> json,
) => _$FinancialStatementImpl(
  symbol: json['symbol'] as String,
  period: json['period'] as String,
  type: $enumDecode(_$StatementTypeEnumMap, json['type']),
  items: (json['items'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
);

Map<String, dynamic> _$$FinancialStatementImplToJson(
  _$FinancialStatementImpl instance,
) => <String, dynamic>{
  'symbol': instance.symbol,
  'period': instance.period,
  'type': _$StatementTypeEnumMap[instance.type]!,
  'items': instance.items,
};

const _$StatementTypeEnumMap = {
  StatementType.incomeStatement: 'incomeStatement',
  StatementType.balanceSheet: 'balanceSheet',
  StatementType.cashFlow: 'cashFlow',
};
