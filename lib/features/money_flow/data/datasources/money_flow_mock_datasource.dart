import '../../domain/entities/foreign_flow.dart';
import '../../domain/entities/market_flow_summary.dart';

class MoneyFlowMockDatasource {
  Future<MarketFlowSummary> getMarketFlowSummary() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final now = DateTime.now();
    return MarketFlowSummary(
      totalForeignBuy: 2150e9,
      totalForeignSell: 1820e9,
      totalForeignNet: 330e9,
      topNetBuyers: _topBuyers(now),
      topNetSellers: _topSellers(now),
      date: now,
    );
  }

  Future<List<ForeignFlow>> getTopNetBuyers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _topBuyers(DateTime.now());
  }

  Future<List<ForeignFlow>> getTopNetSellers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _topSellers(DateTime.now());
  }

  Future<List<ForeignFlow>> getForeignFlowHistory(String symbol) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final now = DateTime.now();
    return List.generate(20, (i) {
      final date = now.subtract(Duration(days: 20 - i));
      final buy = 500000.0 + (i % 5) * 200000;
      final sell = 400000.0 + (i % 3) * 250000;
      return ForeignFlow(
        symbol: symbol,
        buyVolume: buy,
        sellVolume: sell,
        netVolume: buy - sell,
        buyValue: buy * 85000,
        sellValue: sell * 85000,
        netValue: (buy - sell) * 85000,
        date: date,
      );
    });
  }

  List<ForeignFlow> _topBuyers(DateTime date) => [
        ForeignFlow(symbol: 'VNM', buyVolume: 2500000, sellVolume: 800000, netVolume: 1700000, buyValue: 212.5e9, sellValue: 68e9, netValue: 144.5e9, date: date),
        ForeignFlow(symbol: 'FPT', buyVolume: 1800000, sellVolume: 600000, netVolume: 1200000, buyValue: 216e9, sellValue: 72e9, netValue: 144e9, date: date),
        ForeignFlow(symbol: 'VCB', buyVolume: 1500000, sellVolume: 500000, netVolume: 1000000, buyValue: 135e9, sellValue: 45e9, netValue: 90e9, date: date),
        ForeignFlow(symbol: 'HPG', buyVolume: 3000000, sellVolume: 2200000, netVolume: 800000, buyValue: 75e9, sellValue: 55e9, netValue: 20e9, date: date),
        ForeignFlow(symbol: 'MBB', buyVolume: 2000000, sellVolume: 1400000, netVolume: 600000, buyValue: 46e9, sellValue: 32.2e9, netValue: 13.8e9, date: date),
        ForeignFlow(symbol: 'TCB', buyVolume: 1200000, sellVolume: 700000, netVolume: 500000, buyValue: 42e9, sellValue: 24.5e9, netValue: 17.5e9, date: date),
        ForeignFlow(symbol: 'VHM', buyVolume: 900000, sellVolume: 500000, netVolume: 400000, buyValue: 40.5e9, sellValue: 22.5e9, netValue: 18e9, date: date),
        ForeignFlow(symbol: 'MSN', buyVolume: 800000, sellVolume: 450000, netVolume: 350000, buyValue: 60e9, sellValue: 33.75e9, netValue: 26.25e9, date: date),
        ForeignFlow(symbol: 'VIC', buyVolume: 700000, sellVolume: 400000, netVolume: 300000, buyValue: 31.5e9, sellValue: 18e9, netValue: 13.5e9, date: date),
        ForeignFlow(symbol: 'ACB', buyVolume: 1100000, sellVolume: 850000, netVolume: 250000, buyValue: 27.5e9, sellValue: 21.25e9, netValue: 6.25e9, date: date),
      ];

  List<ForeignFlow> _topSellers(DateTime date) => [
        ForeignFlow(symbol: 'STB', buyVolume: 500000, sellVolume: 2000000, netVolume: -1500000, buyValue: 15e9, sellValue: 60e9, netValue: -45e9, date: date),
        ForeignFlow(symbol: 'SSI', buyVolume: 300000, sellVolume: 1500000, netVolume: -1200000, buyValue: 9e9, sellValue: 45e9, netValue: -36e9, date: date),
        ForeignFlow(symbol: 'VND', buyVolume: 400000, sellVolume: 1300000, netVolume: -900000, buyValue: 6.8e9, sellValue: 22.1e9, netValue: -15.3e9, date: date),
        ForeignFlow(symbol: 'DGC', buyVolume: 200000, sellVolume: 900000, netVolume: -700000, buyValue: 16e9, sellValue: 72e9, netValue: -56e9, date: date),
        ForeignFlow(symbol: 'PNJ', buyVolume: 150000, sellVolume: 750000, netVolume: -600000, buyValue: 13.5e9, sellValue: 67.5e9, netValue: -54e9, date: date),
        ForeignFlow(symbol: 'KDH', buyVolume: 300000, sellVolume: 800000, netVolume: -500000, buyValue: 9.9e9, sellValue: 26.4e9, netValue: -16.5e9, date: date),
        ForeignFlow(symbol: 'GEX', buyVolume: 250000, sellVolume: 700000, netVolume: -450000, buyValue: 5.5e9, sellValue: 15.4e9, netValue: -9.9e9, date: date),
        ForeignFlow(symbol: 'PLX', buyVolume: 200000, sellVolume: 600000, netVolume: -400000, buyValue: 7.8e9, sellValue: 23.4e9, netValue: -15.6e9, date: date),
        ForeignFlow(symbol: 'POW', buyVolume: 350000, sellVolume: 700000, netVolume: -350000, buyValue: 4.2e9, sellValue: 8.4e9, netValue: -4.2e9, date: date),
        ForeignFlow(symbol: 'NVL', buyVolume: 400000, sellVolume: 700000, netVolume: -300000, buyValue: 5.6e9, sellValue: 9.8e9, netValue: -4.2e9, date: date),
      ];
}
