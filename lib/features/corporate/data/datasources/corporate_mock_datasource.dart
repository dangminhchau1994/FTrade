import '../../domain/entities/dividend.dart';
import '../../domain/entities/corporate_event.dart';
import '../../domain/entities/insider_trade.dart';

class CorporateMockDatasource {
  Future<List<Dividend>> getDividends() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _dividends;
  }

  Future<List<Dividend>> getDividendsBySymbol(String symbol) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _dividends.where((d) => d.symbol == symbol).toList();
  }

  Future<List<CorporateEvent>> getUpcomingEvents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _events;
  }

  Future<List<CorporateEvent>> getEventsBySymbol(String symbol) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _events.where((e) => e.symbol == symbol).toList();
  }

  Future<List<InsiderTrade>> getInsiderTrades() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _insiderTrades;
  }

  Future<List<InsiderTrade>> getInsiderTradesBySymbol(String symbol) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _insiderTrades.where((t) => t.symbol == symbol).toList();
  }

  static final _dividends = [
    Dividend(symbol: 'VNM', exDate: DateTime(2025, 3, 20), recordDate: DateTime(2025, 3, 21), paymentDate: DateTime(2025, 4, 15), ratio: 0, cashAmount: 1500, note: 'Cổ tức tiền mặt đợt 2/2024'),
    Dividend(symbol: 'FPT', exDate: DateTime(2025, 4, 5), recordDate: DateTime(2025, 4, 8), paymentDate: DateTime(2025, 5, 10), ratio: 15, cashAmount: 1000, note: 'Cổ tức tiền mặt + cổ phiếu'),
    Dividend(symbol: 'HPG', exDate: DateTime(2025, 3, 25), recordDate: DateTime(2025, 3, 26), paymentDate: DateTime(2025, 4, 20), ratio: 0, cashAmount: 500, note: 'Cổ tức tiền mặt 2024'),
    Dividend(symbol: 'TCB', exDate: DateTime(2025, 5, 10), recordDate: DateTime(2025, 5, 12), paymentDate: DateTime(2025, 6, 5), ratio: 20, cashAmount: 0, note: 'Cổ tức bằng cổ phiếu 20%'),
    Dividend(symbol: 'VCB', exDate: DateTime(2025, 4, 15), recordDate: DateTime(2025, 4, 16), paymentDate: DateTime(2025, 5, 20), ratio: 0, cashAmount: 1800, note: 'Cổ tức tiền mặt 2024'),
    Dividend(symbol: 'MBB', exDate: DateTime(2025, 3, 28), recordDate: DateTime(2025, 3, 31), paymentDate: DateTime(2025, 4, 25), ratio: 10, cashAmount: 500),
    Dividend(symbol: 'ACB', exDate: DateTime(2025, 5, 20), recordDate: DateTime(2025, 5, 21), paymentDate: DateTime(2025, 6, 15), ratio: 25, cashAmount: 0, note: 'Chia cổ phiếu thưởng'),
    Dividend(symbol: 'VHM', exDate: DateTime(2025, 4, 10), recordDate: DateTime(2025, 4, 11), paymentDate: DateTime(2025, 5, 5), ratio: 0, cashAmount: 2000, note: 'Cổ tức tiền mặt đặc biệt'),
    Dividend(symbol: 'MSN', exDate: DateTime(2025, 6, 5), recordDate: DateTime(2025, 6, 6), paymentDate: DateTime(2025, 7, 1), ratio: 0, cashAmount: 1000),
    Dividend(symbol: 'VIC', exDate: DateTime(2025, 5, 15), recordDate: DateTime(2025, 5, 16), paymentDate: DateTime(2025, 6, 10), ratio: 10, cashAmount: 500),
  ];

  static final _events = [
    CorporateEvent(id: 'e1', symbol: 'VNM', title: 'ĐHCĐ thường niên 2025', type: CorporateEventType.agm, eventDate: DateTime(2025, 4, 18), description: 'Đại hội cổ đông thường niên tại TP.HCM'),
    CorporateEvent(id: 'e2', symbol: 'FPT', title: 'Công bố KQKD Q1/2025', type: CorporateEventType.earnings, eventDate: DateTime(2025, 4, 20), description: 'Báo cáo kết quả kinh doanh quý 1'),
    CorporateEvent(id: 'e3', symbol: 'HPG', title: 'ĐHCĐ thường niên 2025', type: CorporateEventType.agm, eventDate: DateTime(2025, 4, 25)),
    CorporateEvent(id: 'e4', symbol: 'TCB', title: 'Phát hành thêm cổ phiếu', type: CorporateEventType.rightsIssue, eventDate: DateTime(2025, 5, 1), description: 'Phát hành 200 triệu CP cho cổ đông hiện hữu'),
    CorporateEvent(id: 'e5', symbol: 'VCB', title: 'Công bố KQKD Q1/2025', type: CorporateEventType.earnings, eventDate: DateTime(2025, 4, 22)),
    CorporateEvent(id: 'e6', symbol: 'MBB', title: 'Chốt quyền cổ tức', type: CorporateEventType.dividend, eventDate: DateTime(2025, 3, 28)),
    CorporateEvent(id: 'e7', symbol: 'VNM', title: 'Chốt quyền cổ tức', type: CorporateEventType.dividend, eventDate: DateTime(2025, 3, 20)),
    CorporateEvent(id: 'e8', symbol: 'ACB', title: 'ĐHCĐ thường niên 2025', type: CorporateEventType.agm, eventDate: DateTime(2025, 4, 12)),
    CorporateEvent(id: 'e9', symbol: 'VHM', title: 'Công bố KQKD Q1/2025', type: CorporateEventType.earnings, eventDate: DateTime(2025, 4, 28)),
    CorporateEvent(id: 'e10', symbol: 'MSN', title: 'ĐHCĐ thường niên 2025', type: CorporateEventType.agm, eventDate: DateTime(2025, 5, 15)),
    CorporateEvent(id: 'e11', symbol: 'SSI', title: 'Phát hành trái phiếu', type: CorporateEventType.other, eventDate: DateTime(2025, 4, 5), description: 'Phát hành 2000 tỷ trái phiếu chuyển đổi'),
    CorporateEvent(id: 'e12', symbol: 'VIC', title: 'Công bố KQKD Q1/2025', type: CorporateEventType.earnings, eventDate: DateTime(2025, 5, 5)),
  ];

  static final _insiderTrades = [
    InsiderTrade(symbol: 'FPT', traderName: 'Trương Gia Bình', position: 'Chủ tịch HĐQT', tradeType: TradeType.buy, quantity: 500000, price: 120000, tradeDate: DateTime(2025, 3, 10), reportDate: DateTime(2025, 3, 12), isProprietary: false),
    InsiderTrade(symbol: 'VNM', traderName: 'Mai Kiều Liên', position: 'Tổng Giám đốc', tradeType: TradeType.sell, quantity: 200000, price: 85000, tradeDate: DateTime(2025, 3, 8), reportDate: DateTime(2025, 3, 10), isProprietary: false),
    InsiderTrade(symbol: 'HPG', traderName: 'Trần Đình Long', position: 'Chủ tịch HĐQT', tradeType: TradeType.buy, quantity: 1000000, price: 25000, tradeDate: DateTime(2025, 3, 5), reportDate: DateTime(2025, 3, 7), isProprietary: false),
    InsiderTrade(symbol: 'TCB', traderName: 'CTCK Techcombank Securities', position: 'Tự doanh CTCK', tradeType: TradeType.buy, quantity: 3000000, price: 35000, tradeDate: DateTime(2025, 3, 11), reportDate: DateTime(2025, 3, 13), isProprietary: true),
    InsiderTrade(symbol: 'VCB', traderName: 'Phạm Quang Dũng', position: 'Tổng Giám đốc', tradeType: TradeType.buy, quantity: 100000, price: 90000, tradeDate: DateTime(2025, 3, 3), reportDate: DateTime(2025, 3, 5), isProprietary: false),
    InsiderTrade(symbol: 'MBB', traderName: 'CTCK MB Securities', position: 'Tự doanh CTCK', tradeType: TradeType.sell, quantity: 2000000, price: 23000, tradeDate: DateTime(2025, 3, 9), reportDate: DateTime(2025, 3, 11), isProprietary: true),
    InsiderTrade(symbol: 'SSI', traderName: 'Nguyễn Duy Hưng', position: 'Chủ tịch HĐQT', tradeType: TradeType.sell, quantity: 500000, price: 30000, tradeDate: DateTime(2025, 3, 7), reportDate: DateTime(2025, 3, 9), isProprietary: false),
    InsiderTrade(symbol: 'VNM', traderName: 'CTCK Bản Việt', position: 'Tự doanh CTCK', tradeType: TradeType.buy, quantity: 1500000, price: 84000, tradeDate: DateTime(2025, 3, 12), reportDate: DateTime(2025, 3, 14), isProprietary: true),
    InsiderTrade(symbol: 'HPG', traderName: 'Nguyễn Mạnh Tuấn', position: 'Phó Chủ tịch HĐQT', tradeType: TradeType.buy, quantity: 300000, price: 25500, tradeDate: DateTime(2025, 3, 6), reportDate: DateTime(2025, 3, 8), isProprietary: false),
    InsiderTrade(symbol: 'FPT', traderName: 'CTCK FPT Securities', position: 'Tự doanh CTCK', tradeType: TradeType.buy, quantity: 2500000, price: 121000, tradeDate: DateTime(2025, 3, 13), reportDate: DateTime(2025, 3, 14), isProprietary: true),
    InsiderTrade(symbol: 'VHM', traderName: 'Phạm Nhật Vượng', position: 'Chủ tịch HĐQT', tradeType: TradeType.sell, quantity: 5000000, price: 45000, tradeDate: DateTime(2025, 3, 4), reportDate: DateTime(2025, 3, 6), isProprietary: false),
    InsiderTrade(symbol: 'ACB', traderName: 'Trần Hùng Huy', position: 'Chủ tịch HĐQT', tradeType: TradeType.buy, quantity: 200000, price: 25000, tradeDate: DateTime(2025, 3, 10), reportDate: DateTime(2025, 3, 12), isProprietary: false),
    InsiderTrade(symbol: 'MSN', traderName: 'CTCK HSC', position: 'Tự doanh CTCK', tradeType: TradeType.sell, quantity: 1800000, price: 75000, tradeDate: DateTime(2025, 3, 11), reportDate: DateTime(2025, 3, 13), isProprietary: true),
    InsiderTrade(symbol: 'VIC', traderName: 'Nguyễn Việt Quang', position: 'Tổng Giám đốc', tradeType: TradeType.buy, quantity: 400000, price: 45000, tradeDate: DateTime(2025, 3, 8), reportDate: DateTime(2025, 3, 10), isProprietary: false),
    InsiderTrade(symbol: 'STB', traderName: 'Dương Công Minh', position: 'Chủ tịch HĐQT', tradeType: TradeType.buy, quantity: 3000000, price: 30000, tradeDate: DateTime(2025, 3, 2), reportDate: DateTime(2025, 3, 4), isProprietary: false),
  ];
}
