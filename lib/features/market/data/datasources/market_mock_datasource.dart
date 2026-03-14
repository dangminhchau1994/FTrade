import '../../domain/entities/market_index.dart';
import '../../domain/entities/stock.dart';
import '../../domain/entities/stock_detail.dart';

class MarketMockDatasource {
  Future<List<MarketIndex>> getMarketIndices() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      MarketIndex(
        name: 'VN-Index',
        value: 1284.53,
        change: 12.47,
        changePercent: 0.98,
        totalVolume: 892000000,
        advances: 245,
        declines: 178,
        unchanged: 82,
        updatedAt: DateTime.now(),
      ),
      MarketIndex(
        name: 'HNX-Index',
        value: 232.18,
        change: -1.24,
        changePercent: -0.53,
        totalVolume: 124000000,
        advances: 98,
        declines: 112,
        unchanged: 45,
        updatedAt: DateTime.now(),
      ),
      MarketIndex(
        name: 'UPCOM',
        value: 92.45,
        change: 0.32,
        changePercent: 0.35,
        totalVolume: 68000000,
        advances: 156,
        declines: 134,
        unchanged: 78,
        updatedAt: DateTime.now(),
      ),
    ];
  }

  Future<List<Stock>> getTopGainers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      _mockStock('FPT', 132500, 9300, 7.55),
      _mockStock('MWG', 62800, 4100, 6.98),
      _mockStock('VNM', 72300, 4800, 6.71),
      _mockStock('HPG', 27650, 1750, 6.76),
      _mockStock('TCB', 35200, 2100, 6.34),
      _mockStock('MSN', 89500, 5200, 6.17),
      _mockStock('VIC', 42100, 2300, 5.78),
      _mockStock('VHM', 38900, 2000, 5.41),
      _mockStock('ACB', 26800, 1300, 5.10),
      _mockStock('SSI', 32400, 1500, 4.85),
    ];
  }

  Future<List<Stock>> getTopLosers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      _mockStock('DIG', 18200, -1350, -6.91),
      _mockStock('PDR', 12450, -900, -6.74),
      _mockStock('NVL', 14800, -950, -6.03),
      _mockStock('DXG', 16700, -1000, -5.65),
      _mockStock('KDH', 28500, -1600, -5.31),
      _mockStock('CEO', 11200, -600, -5.08),
      _mockStock('HQC', 5120, -260, -4.83),
      _mockStock('LDG', 7800, -380, -4.65),
      _mockStock('SCR', 9400, -430, -4.37),
      _mockStock('NBB', 15600, -680, -4.18),
    ];
  }

  Future<List<Stock>> getTopVolume() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      _mockStock('HPG', 27650, 1750, 6.76, volume: 42500000),
      _mockStock('STB', 31200, 400, 1.30, volume: 38200000),
      _mockStock('SSI', 32400, 1500, 4.85, volume: 35100000),
      _mockStock('FPT', 132500, 9300, 7.55, volume: 28900000),
      _mockStock('MBB', 24500, -200, -0.81, volume: 27600000),
      _mockStock('VPB', 21800, 300, 1.40, volume: 25400000),
      _mockStock('TCB', 35200, 2100, 6.34, volume: 23100000),
      _mockStock('SHB', 13200, 100, 0.76, volume: 21800000),
      _mockStock('HDB', 26900, -350, -1.28, volume: 19500000),
      _mockStock('ACB', 26800, 1300, 5.10, volume: 18200000),
    ];
  }

  Future<StockDetail> getStockDetail(String symbol) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return StockDetail(
      symbol: symbol,
      companyName: _companyNames[symbol] ?? '$symbol Corp',
      exchange: 'HOSE',
      price: 132500,
      change: 9300,
      changePercent: 7.55,
      high: 133000,
      low: 124500,
      open: 125000,
      prevClose: 123200,
      volume: 28900000,
      ceiling: 131820,
      floor: 118380,
      refPrice: 125100,
      pe: 22.5,
      pb: 4.8,
      eps: 5889,
      marketCap: 182500000000000,
      foreignBuy: 1250000,
      foreignSell: 890000,
      updatedAt: DateTime.now(),
    );
  }

  Future<List<Stock>> searchStocks(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final allStocks = await getTopVolume();
    return allStocks
        .where(
          (s) => s.symbol.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  Stock _mockStock(
    String symbol,
    double price,
    double change,
    double changePercent, {
    int volume = 15000000,
  }) {
    return Stock(
      symbol: symbol,
      price: price,
      change: change,
      changePercent: changePercent,
      high: price + price * 0.02,
      low: price - price * 0.03,
      open: price - change + (change * 0.3),
      prevClose: price - change,
      volume: volume,
      exchange: 'HOSE',
      updatedAt: DateTime.now(),
    );
  }

  static const _companyNames = {
    'FPT': 'CTCP FPT',
    'MWG': 'CTCP Đầu tư Thế giới Di động',
    'VNM': 'CTCP Sữa Việt Nam',
    'HPG': 'CTCP Tập đoàn Hòa Phát',
    'TCB': 'NH TMCP Kỹ Thương Việt Nam',
    'VIC': 'Tập đoàn Vingroup',
    'VHM': 'CTCP Vinhomes',
    'MSN': 'CTCP Tập đoàn Masan',
    'ACB': 'NH TMCP Á Châu',
    'SSI': 'CTCP Chứng khoán SSI',
  };
}
