import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/money_flow_providers.dart';
import '../widgets/flow_summary_card.dart';
import '../widgets/flow_bar_chart.dart';
import '../widgets/flow_ranking_list.dart';
import '../widgets/volume_anomaly_list.dart';

class MoneyFlowScreen extends ConsumerWidget {
  const MoneyFlowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dòng tiền'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tổng quan'),
              Tab(text: 'Top mua ròng'),
              Tab(text: 'Top bán ròng'),
              Tab(text: 'KL bất thường'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _OverviewTab(),
            _BuyersTab(),
            _SellersTab(),
            _VolumeAnomalyTab(),
          ],
        ),
      ),
    );
  }
}

class _OverviewTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(marketFlowSummaryProvider);
    final history = ref.watch(foreignFlowHistoryProvider('VN-INDEX'));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(marketFlowSummaryProvider);
        ref.invalidate(foreignFlowHistoryProvider('VN-INDEX'));
      },
      child: ListView(
        children: [
          summary.when(
            data: (data) => FlowSummaryCard(
              totalBuy: data.totalForeignBuy,
              totalSell: data.totalForeignSell,
              totalNet: data.totalForeignNet,
            ),
            loading: () => const SizedBox(
              height: 180,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Lỗi: $e'),
            ),
          ),
          history.when(
            data: (data) => FlowBarChart(data: data),
            loading: () => const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Lỗi: $e'),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuyersTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buyers = ref.watch(topNetBuyersProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(topNetBuyersProvider),
      child: buyers.when(
        data: (data) => FlowRankingList(flows: data, isBuyers: true),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
      ),
    );
  }
}

class _SellersTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sellers = ref.watch(topNetSellersProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(topNetSellersProvider),
      child: sellers.when(
        data: (data) => FlowRankingList(flows: data, isBuyers: false),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
      ),
    );
  }
}

class _VolumeAnomalyTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anomalies = ref.watch(volumeAnomaliesProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(volumeAnomaliesProvider),
      child: anomalies.when(
        data: (data) => VolumeAnomalyList(anomalies: data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
      ),
    );
  }
}
