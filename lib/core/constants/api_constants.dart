class ApiConstants {
  ApiConstants._();

  static const String vndirectBase = 'https://api-finfo.vndirect.com.vn/v4';
  static const String vietstockTvNew = 'https://api.vietstock.vn/tvnew';
  static const String vietstockFinanceBase = 'https://finance.vietstock.vn';

  // SSI Price Streaming MQTT (realtime market data)
  static const String ssiMqttUrl = 'wss://price-streaming.ssi.com.vn/mqtt';
  static const String ssiMqttUsername = 'mqtt-ssi';
  static const String ssiMqttPassword = 'mqtt-ssi';
  // Stock prices - supports sort by date, pctChange, nmVolume
  static const String stockPrices = '$vndirectBase/stock_prices';

  // Stock listing & search
  static const String stocks = '$vndirectBase/stocks';

  // Financial ratios (PE, PB, Market Cap, EPS, etc.)
  static const String ratios = '$vndirectBase/ratios';

  // Financial statements (IS, BS, CF)
  static const String financialStatements =
      '$vndirectBase/financial_statements';

  // Vietstock Finance pages/endpoints
  static const String vietstockMoneyFlowPage =
      '$vietstockFinanceBase/ket-qua-giao-dich.htm';
  static const String vietstockCorporateEventsPage =
      '$vietstockFinanceBase/lich-su-kien.htm';
  static const String vietstockInsiderTradesPage =
      '$vietstockFinanceBase/su-kien-doanh-nghiep.htm';
  static const String vietstockForeignTrading =
      '$vietstockFinanceBase/data/KQGDGiaoDichNDTNNPaging';
  static const String vietstockEventTypes =
      '$vietstockFinanceBase/data/eventtypebyid';
  static const String vietstockEventData =
      '$vietstockFinanceBase/data/eventstypedata';
  static const String vietstockTransferData =
      '$vietstockFinanceBase/data/eventstransferdata';

  // Ratio item codes
  static const String ratioMarketCap = '51003';
  static const String ratioPE = '51006';
  static const String ratioPB = '51012';
  static const String ratioEPS = '51009';
  static const String ratioBeta = '51007';
  static const String ratioOutstandingShares = '51004';
  static const String ratioPriceToSales = '51011';
}
