import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_statement.freezed.dart';
part 'financial_statement.g.dart';

enum StatementType { incomeStatement, balanceSheet, cashFlow }

@freezed
class FinancialStatement with _$FinancialStatement {
  const factory FinancialStatement({
    required String symbol,
    required String period,
    required StatementType type,
    required Map<String, double> items,
  }) = _FinancialStatement;

  factory FinancialStatement.fromJson(Map<String, dynamic> json) =>
      _$FinancialStatementFromJson(json);
}
