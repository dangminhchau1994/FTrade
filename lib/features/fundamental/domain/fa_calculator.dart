import 'dart:math';

import 'entities/fa_analysis.dart';
import 'entities/financial_statement.dart';

/// Pure calculation logic for fundamental analysis.
/// All methods are static — no network, no side effects.
/// Safe to run inside a Flutter [compute] isolate.
class FaCalculator {
  FaCalculator._();

  // ── Helpers ─────────────────────────────────────────────────────────────

  static double _ttm(List<FinancialStatement> s, String k) =>
      s.take(4).fold(0.0, (sum, e) => sum + (e.items[k] ?? 0));

  static double _prevTtm(List<FinancialStatement> s, String k) =>
      s.skip(4).take(4).fold(0.0, (sum, e) => sum + (e.items[k] ?? 0));

  static double _latest(List<FinancialStatement> s, String k) =>
      s.isNotEmpty ? (s.first.items[k] ?? 0) : 0;

  static double _prev(List<FinancialStatement> s, String k) =>
      s.length > 4 ? (s[4].items[k] ?? 0) : 0;

  // ── Piotroski F-Score (0-9) ─────────────────────────────────────────────

  static PiotroskiScore? piotroski({
    required List<FinancialStatement> incomeStatements,
    required List<FinancialStatement> balanceSheets,
    required List<FinancialStatement> cashFlows,
  }) {
    if (incomeStatements.length < 5 ||
        balanceSheets.length < 5 ||
        cashFlows.length < 2) {
      return null;
    }

    // Income
    final ni = _ttm(incomeStatements, 'Lợi nhuận sau thuế');
    final rev = _ttm(incomeStatements, 'Doanh thu thuần');
    final gp = _ttm(incomeStatements, 'Lợi nhuận gộp');
    final prevRev = _prevTtm(incomeStatements, 'Doanh thu thuần');
    final prevGp = _prevTtm(incomeStatements, 'Lợi nhuận gộp');

    // Balance sheet
    final ta = _latest(balanceSheets, 'Tổng tài sản');
    final prevTa = _prev(balanceSheets, 'Tổng tài sản');
    final eq = _latest(balanceSheets, 'Vốn chủ sở hữu');
    final prevEq = _prev(balanceSheets, 'Vốn chủ sở hữu');
    final tl = _latest(balanceSheets, 'Nợ phải trả');
    final prevTl = _prev(balanceSheets, 'Nợ phải trả');
    final ca = _latest(balanceSheets, 'Tài sản ngắn hạn');
    final prevCa = _prev(balanceSheets, 'Tài sản ngắn hạn');
    final cl = _latest(balanceSheets, 'Nợ ngắn hạn');
    final prevCl = _prev(balanceSheets, 'Nợ ngắn hạn');

    // Cash flow
    final cfo = _ttm(cashFlows, 'Lưu chuyển tiền từ HĐKD');

    final avgTa = ta > 0 && prevTa > 0 ? (ta + prevTa) / 2 : max(ta, prevTa);

    // Profitability (4)
    final b1 = ni > 0;
    final b2 = avgTa > 0 && ni / avgTa > 0;
    final b3 = cfo > 0;
    final b4 = cfo > ni; // accruals quality

    // Leverage (3)
    final lev = ta > 0 ? tl / ta : 0.0;
    final prevLev = prevTa > 0 ? prevTl / prevTa : 0.0;
    final b5 = lev < prevLev;
    final cr = cl > 0 ? ca / cl : 0.0;
    final prevCr = prevCl > 0 ? prevCa / prevCl : 0.0;
    final b6 = cr > prevCr;
    final b7 = eq <= prevEq * 1.05; // no significant dilution

    // Efficiency (2)
    final gm = rev > 0 ? gp / rev : 0.0;
    final prevGm = prevRev > 0 ? prevGp / prevRev : 0.0;
    final b8 = gm > prevGm;
    final at = avgTa > 0 ? rev / avgTa : 0.0;
    final prevAt = prevTa > 0 ? prevRev / prevTa : 0.0;
    final b9 = at > prevAt;

    return PiotroskiScore(
      totalScore: [b1, b2, b3, b4, b5, b6, b7, b8, b9].where((x) => x).length,
      positiveNetIncome: b1,
      positiveROA: b2,
      positiveCFO: b3,
      cfoGreaterThanNetIncome: b4,
      lowerLeverage: b5,
      higherCurrentRatio: b6,
      noNewShares: b7,
      higherGrossMargin: b8,
      higherAssetTurnover: b9,
    );
  }

  // ── Altman Z-Score shared components ────────────────────────────────────

  static ({double x1, double x2, double x3, double x4, double x5})? _zComponents({
    required List<FinancialStatement> incomeStatements,
    required List<FinancialStatement> balanceSheets,
    required double marketCapBillion,
  }) {
    if (incomeStatements.isEmpty || balanceSheets.isEmpty) return null;
    final ta = _latest(balanceSheets, 'Tổng tài sản');
    if (ta <= 0) return null;

    final ca = _latest(balanceSheets, 'Tài sản ngắn hạn');
    final cl = _latest(balanceSheets, 'Nợ ngắn hạn');
    final tl = _latest(balanceSheets, 'Nợ phải trả');
    final eq = _latest(balanceSheets, 'Vốn chủ sở hữu');
    final rev = _ttm(incomeStatements, 'Doanh thu thuần');
    final ebit = _ttm(incomeStatements, 'Lợi nhuận từ HĐKD');
    final mktCap = marketCapBillion * 1e9;

    return (
      x1: (ca - cl) / ta,
      x2: eq / ta, // Retained Earnings ≈ Equity (VAS simplified)
      x3: ebit / ta,
      x4: tl > 0 ? mktCap / tl : 10.0,
      x5: rev / ta,
    );
  }

  /// Original Altman Z-Score (manufacturing firms).
  /// Z = 1.2·X1 + 1.4·X2 + 3.3·X3 + 0.6·X4 + 1.0·X5
  static AltmanZScore? altmanZOriginal({
    required List<FinancialStatement> incomeStatements,
    required List<FinancialStatement> balanceSheets,
    required double marketCapBillion,
  }) {
    final c = _zComponents(
      incomeStatements: incomeStatements,
      balanceSheets: balanceSheets,
      marketCapBillion: marketCapBillion,
    );
    if (c == null) return null;

    final z = 1.2 * c.x1 + 1.4 * c.x2 + 3.3 * c.x3 + 0.6 * c.x4 + 1.0 * c.x5;
    final zone = z > 2.99 ? 'safe' : (z > 1.81 ? 'grey' : 'distress');

    return AltmanZScore(
      zScore: z, zone: zone, model: 'original',
      x1: c.x1, x2: c.x2, x3: c.x3, x4: c.x4, x5: c.x5,
    );
  }

  /// Altman Z''-Score for Emerging Markets (no X5 — removes asset-intensity bias).
  /// Z'' = 3.25 + 6.56·X1 + 3.26·X2 + 6.72·X3 + 1.05·X4
  static AltmanZScore? altmanZEm({
    required List<FinancialStatement> incomeStatements,
    required List<FinancialStatement> balanceSheets,
    required double marketCapBillion,
  }) {
    final c = _zComponents(
      incomeStatements: incomeStatements,
      balanceSheets: balanceSheets,
      marketCapBillion: marketCapBillion,
    );
    if (c == null) return null;

    final z = 3.25 + 6.56 * c.x1 + 3.26 * c.x2 + 6.72 * c.x3 + 1.05 * c.x4;
    final zone = z > 2.60 ? 'safe' : (z > 1.10 ? 'grey' : 'distress');

    return AltmanZScore(
      zScore: z, zone: zone, model: 'em',
      x1: c.x1, x2: c.x2, x3: c.x3, x4: c.x4, x5: 0,
    );
  }

  // ── DuPont Analysis ─────────────────────────────────────────────────────

  static List<DuPontAnalysis> dupont({
    required List<FinancialStatement> incomeStatements,
    required List<FinancialStatement> balanceSheets,
  }) {
    final results = <DuPontAnalysis>[];
    final n = min(incomeStatements.length, balanceSheets.length);

    for (var i = 0; i < n; i++) {
      final ni = incomeStatements[i].items['Lợi nhuận sau thuế'] ?? 0;
      final rev = incomeStatements[i].items['Doanh thu thuần'] ?? 0;
      final ta = balanceSheets[i].items['Tổng tài sản'] ?? 0;
      final eq = balanceSheets[i].items['Vốn chủ sở hữu'] ?? 0;

      if (rev <= 0 || ta <= 0 || eq <= 0) continue;

      final nm = ni / rev * 100;
      final at = rev / ta;
      final em = ta / eq;

      results.add(DuPontAnalysis(
        period: incomeStatements[i].period,
        roe: nm / 100 * at * em * 100,
        netMargin: nm,
        assetTurnover: at,
        equityMultiplier: em,
      ));
    }
    return results;
  }

  // ── Growth Metrics ──────────────────────────────────────────────────────

  static List<GrowthMetrics> growth({
    required List<FinancialStatement> incomeStatements,
  }) {
    final results = <GrowthMetrics>[];

    for (var i = 0; i < incomeStatements.length; i++) {
      final rev = incomeStatements[i].items['Doanh thu thuần'] ?? 0;
      final ni = incomeStatements[i].items['Lợi nhuận sau thuế'] ?? 0;

      double? rQoQ, rYoY, nQoQ, nYoY;

      if (i + 1 < incomeStatements.length) {
        final pr = incomeStatements[i + 1].items['Doanh thu thuần'] ?? 0;
        final pn = incomeStatements[i + 1].items['Lợi nhuận sau thuế'] ?? 0;
        if (pr != 0) rQoQ = (rev - pr) / pr.abs() * 100;
        if (pn != 0) nQoQ = (ni - pn) / pn.abs() * 100;
      }
      if (i + 4 < incomeStatements.length) {
        final pr = incomeStatements[i + 4].items['Doanh thu thuần'] ?? 0;
        final pn = incomeStatements[i + 4].items['Lợi nhuận sau thuế'] ?? 0;
        if (pr != 0) rYoY = (rev - pr) / pr.abs() * 100;
        if (pn != 0) nYoY = (ni - pn) / pn.abs() * 100;
      }

      results.add(GrowthMetrics(
        period: incomeStatements[i].period,
        revenue: rev,
        netIncome: ni,
        revenueGrowthQoQ: rQoQ,
        revenueGrowthYoY: rYoY,
        netIncomeGrowthQoQ: nQoQ,
        netIncomeGrowthYoY: nYoY,
      ));
    }
    return results;
  }

  // ── Valuation ───────────────────────────────────────────────────────────

  /// [eps] and [bookValuePerShare] in đồng.
  /// [marketCapBillion] in tỷ đồng.
  /// [outstandingSharesMillion] in triệu cổ phiếu.
  static ValuationResult valuation({
    required double currentPrice,
    required double eps,
    required double bookValuePerShare,
    required List<GrowthMetrics> growth,
    required List<FinancialStatement> incomeStatements,
    required List<FinancialStatement> cashFlows,
    required List<FinancialStatement> balanceSheets,
    required double marketCapBillion,
    required double outstandingSharesMillion,
    double wacc = 0.12,
    double terminalGrowthRate = 0.03,
  }) {
    // ── Graham Number ────────────────────────────────────────────────
    double? grahamNum, grahamUp;
    if (eps > 0 && bookValuePerShare > 0) {
      grahamNum = sqrt(22.5 * eps * bookValuePerShare);
      grahamUp = (grahamNum - currentPrice) / currentPrice * 100;
    }

    // ── PEG ──────────────────────────────────────────────────────────
    double? peg, earningsGr;
    final yoyList = growth
        .where((g) => g.netIncomeGrowthYoY != null)
        .map((g) => g.netIncomeGrowthYoY!)
        .toList();
    if (yoyList.isNotEmpty) {
      earningsGr = yoyList.reduce((a, b) => a + b) / yoyList.length;
      if (earningsGr > 0 && eps > 0) {
        peg = (currentPrice / eps) / earningsGr;
      }
    }

    // ── Free Cash Flow ────────────────────────────────────────────────
    final cfo = _ttm(cashFlows, 'Lưu chuyển tiền từ HĐKD');
    final capex = _ttm(cashFlows, 'Lưu chuyển tiền từ HĐĐT').abs();
    final fcf = cfo - capex;

    double? fcfYield;
    if (marketCapBillion > 0) {
      fcfYield = fcf / (marketCapBillion * 1e9) * 100;
    }

    // ── DCF (2-stage FCFF) ────────────────────────────────────────────
    double? dcfValue, dcfUp;
    if (fcf > 0 && wacc > terminalGrowthRate) {
      final gr = earningsGr != null && earningsGr > 0
          ? min(earningsGr / 100, 0.25) // cap at 25%
          : 0.08;
      var totalPV = 0.0;
      var projFcf = fcf;
      for (var y = 1; y <= 5; y++) {
        projFcf *= (1 + gr);
        totalPV += projFcf / pow(1 + wacc, y);
      }
      final tv = projFcf * (1 + terminalGrowthRate) / (wacc - terminalGrowthRate);
      totalPV += tv / pow(1 + wacc, 5);

      if (outstandingSharesMillion > 0) {
        dcfValue = totalPV / (outstandingSharesMillion * 1e6);
        dcfUp = (dcfValue - currentPrice) / currentPrice * 100;
      }
    }

    // ── EV/EBITDA ─────────────────────────────────────────────────────
    final ebit = _ttm(incomeStatements, 'Lợi nhuận từ HĐKD');
    final ni = _ttm(incomeStatements, 'Lợi nhuận sau thuế');
    // D&A proxy: positive difference between CFO and NI (non-cash addback)
    final daProxy = (cfo - ni).clamp(0, double.infinity);
    final ebitda = ebit + daProxy;

    final totalDebt = _latest(balanceSheets, 'Nợ phải trả');
    final cash = _latest(balanceSheets, 'Tiền và tương đương tiền');
    final ev = marketCapBillion * 1e9 + totalDebt - cash;

    double? evEbitda;
    if (ebitda > 0) evEbitda = ev / ebitda;

    return ValuationResult(
      currentPrice: currentPrice,
      grahamNumber: grahamNum,
      grahamUpside: grahamUp,
      pegRatio: peg,
      earningsGrowthRate: earningsGr,
      dcfValue: dcfValue,
      dcfUpside: dcfUp,
      evEbitda: evEbitda,
      ebitdaBillion: ebitda / 1e9,
      enterpriseValueBillion: ev / 1e9,
      fcfYield: fcfYield,
      freeCashFlowBillion: fcf / 1e9,
    );
  }

  // ── Risk Metrics ────────────────────────────────────────────────────────

  static RiskMetrics? riskMetrics({
    required List<double> stockCloses,
    required List<double> indexCloses,
    double riskFreeRate = 0.045,
  }) {
    if (stockCloses.length < 20 || indexCloses.length < 20) return null;

    final n = min(stockCloses.length, indexCloses.length);
    final sr = <double>[], ir = <double>[];

    for (var i = 1; i < n; i++) {
      if (stockCloses[i - 1] > 0 && indexCloses[i - 1] > 0) {
        sr.add((stockCloses[i] - stockCloses[i - 1]) / stockCloses[i - 1]);
        ir.add((indexCloses[i] - indexCloses[i - 1]) / indexCloses[i - 1]);
      }
    }
    if (sr.length < 10) return null;

    final meanR = sr.reduce((a, b) => a + b) / sr.length;
    final meanI = ir.reduce((a, b) => a + b) / ir.length;

    var variance = 0.0, cov = 0.0, iVar = 0.0;
    for (var i = 0; i < sr.length; i++) {
      variance += pow(sr[i] - meanR, 2);
      cov += (sr[i] - meanR) * (ir[i] - meanI);
      iVar += pow(ir[i] - meanI, 2);
    }
    variance /= sr.length;
    cov /= sr.length;
    iVar /= sr.length;

    final annualVol = sqrt(variance) * sqrt(252) * 100;
    final beta = iVar > 0 ? cov / iVar : 1.0;

    var maxDD = 0.0, peak = stockCloses.first;
    for (final c in stockCloses) {
      if (c > peak) peak = c;
      final dd = (peak - c) / peak;
      if (dd > maxDD) maxDD = dd;
    }

    final sharpe = annualVol > 0
        ? (meanR * 252 - riskFreeRate) / (annualVol / 100)
        : 0.0;

    return RiskMetrics(
      volatility: annualVol,
      beta: beta,
      maxDrawdown: maxDD * 100,
      sharpeRatio: sharpe,
    );
  }
}
