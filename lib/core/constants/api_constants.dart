class ApiConstants {
  ApiConstants._();

  static const String vndirectBase = 'https://api-finfo.vndirect.com.vn/v4';
  static const String vietstockTvNew = 'https://api.vietstock.vn/tvnew';

  // Stock prices - supports sort by date, pctChange, nmVolume
  static const String stockPrices = '$vndirectBase/stock_prices';

  // Stock listing & search
  static const String stocks = '$vndirectBase/stocks';

  // Financial ratios (PE, PB, Market Cap, EPS, etc.)
  static const String ratios = '$vndirectBase/ratios/latest';

  // Ratio item codes
  static const String ratioMarketCap = '51003';
  static const String ratioPE = '51006';
  static const String ratioPB = '51012';
  static const String ratioEPS = '51009';
  static const String ratioBeta = '51007';
  static const String ratioOutstandingShares = '51004';
  static const String ratioPriceToSales = '51011';
}
