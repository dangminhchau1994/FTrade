import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/fundamental_providers.dart';
import '../widgets/financial_table.dart';

class FinancialStatementScreen extends ConsumerWidget {
  final String symbol;

  const FinancialStatementScreen({super.key, required this.symbol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('BCTC - $symbol'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'KQKD'),
              Tab(text: 'CĐKT'),
              Tab(text: 'LCTT'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _StatementTab(
              provider: incomeStatementsProvider(symbol),
              onRefresh: () => ref.invalidate(incomeStatementsProvider(symbol)),
            ),
            _StatementTab(
              provider: balanceSheetsProvider(symbol),
              onRefresh: () => ref.invalidate(balanceSheetsProvider(symbol)),
            ),
            _StatementTab(
              provider: cashFlowsProvider(symbol),
              onRefresh: () => ref.invalidate(cashFlowsProvider(symbol)),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatementTab extends ConsumerWidget {
  final ProviderBase provider;
  final VoidCallback onRefresh;

  const _StatementTab({required this.provider, required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(provider);

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: (data as AsyncValue).when(
        data: (statements) => FinancialTable(statements: statements),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
      ),
    );
  }
}
