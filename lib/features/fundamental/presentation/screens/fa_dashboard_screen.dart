import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/format_utils.dart';
import '../../../market/presentation/providers/market_providers.dart';
import '../../domain/entities/fa_analysis.dart';
import '../providers/fundamental_providers.dart';

class FaDashboardScreen extends ConsumerWidget {
  final String symbol;

  const FaDashboardScreen({super.key, required this.symbol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(stockDetailProvider(symbol));

    return Scaffold(
      appBar: AppBar(title: Text('Phân tích FA — $symbol')),
      body: detailAsync.when(
        data: (stock) {
          final marketCapBillion = (stock.marketCap ?? 0) / 1e9;
          final outstandingSharesMillion =
              (stock.price > 0 && stock.marketCap != null)
                  ? (stock.marketCap! / stock.price) / 1e6
                  : 0.0;
          final params = (
            symbol: symbol,
            currentPrice: stock.price,
            eps: stock.eps ?? 0.0,
            marketCapBillion: marketCapBillion,
            outstandingSharesMillion: outstandingSharesMillion,
          );
          final faAsync = ref.watch(faAnalysisProvider(params));
          return faAsync.when(
            data: (fa) => _FaBody(fa: fa),
            loading: () => const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Đang tính toán...', style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
            error: (e, _) => _ErrorView(message: e.toString()),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(message: e.toString()),
      ),
    );
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────

class _FaBody extends StatelessWidget {
  final FaAnalysis fa;
  const _FaBody({required this.fa});

  @override
  Widget build(BuildContext context) {
    final hasAny = fa.piotroski != null ||
        fa.altmanZEm != null ||
        fa.valuation != null ||
        (fa.dupont?.isNotEmpty ?? false) ||
        (fa.growth?.isNotEmpty ?? false) ||
        fa.risk != null;

    if (!hasAny) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Không đủ dữ liệu tài chính để phân tích.\nVui lòng thử lại sau.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (fa.piotroski != null) ...[
          _PiotroskiCard(score: fa.piotroski!),
          const SizedBox(height: 12),
        ],
        if (fa.altmanZEm != null) ...[
          _AltmanCard(z: fa.altmanZEm!),
          const SizedBox(height: 12),
        ],
        if (fa.valuation != null) ...[
          _ValuationCard(v: fa.valuation!),
          const SizedBox(height: 12),
        ],
        if (fa.dupont != null && fa.dupont!.isNotEmpty) ...[
          _DuPontCard(rows: fa.dupont!),
          const SizedBox(height: 12),
        ],
        if (fa.growth != null && fa.growth!.isNotEmpty) ...[
          _GrowthCard(rows: fa.growth!),
          const SizedBox(height: 12),
        ],
        if (fa.risk != null) ...[
          _RiskCard(risk: fa.risk!),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

Widget _faCard(BuildContext context, Widget child) {
  final cs = Theme.of(context).colorScheme;
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: cs.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: cs.outlineVariant),
    ),
    child: child,
  );
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Widget? badge;
  const _SectionTitle({required this.title, this.badge});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: cs.primary,
              letterSpacing: 0.2,
            ),
          ),
        ),
        if (badge != null) badge!,
      ],
    );
  }
}

Widget _zoneBadge(BuildContext context, String label, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

// ── Piotroski ─────────────────────────────────────────────────────────────────

class _PiotroskiCard extends StatelessWidget {
  final PiotroskiScore score;
  const _PiotroskiCard({required this.score});

  @override
  Widget build(BuildContext context) {
    final s = score.totalScore;
    final color = s >= 7
        ? const Color(0xFF22C55E)
        : s >= 4
            ? const Color(0xFFF59E0B)
            : const Color(0xFFEF4444);
    final label = s >= 7
        ? 'Nền tảng mạnh'
        : s >= 4
            ? 'Trung bình'
            : 'Nền tảng yếu';

    return _faCard(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: 'Piotroski F-Score',
            badge: _zoneBadge(context, '$s/9 · $label', color),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: s / 9,
              backgroundColor: Theme.of(context).colorScheme.outlineVariant,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 14),
          _PiotroskiGroup(
            title: 'Lợi nhuận (4 điểm)',
            items: [
              ('Lợi nhuận ròng dương', score.positiveNetIncome),
              ('ROA dương', score.positiveROA),
              ('Dòng tiền hoạt động dương', score.positiveCFO),
              ('Dòng tiền > Lợi nhuận ròng', score.cfoGreaterThanNetIncome),
            ],
          ),
          const SizedBox(height: 10),
          _PiotroskiGroup(
            title: 'Đòn bẩy & Thanh khoản (3 điểm)',
            items: [
              ('Tỷ lệ nợ giảm', score.lowerLeverage),
              ('Tỷ số thanh khoản tăng', score.higherCurrentRatio),
              ('Không phát hành thêm cổ phần', score.noNewShares),
            ],
          ),
          const SizedBox(height: 10),
          _PiotroskiGroup(
            title: 'Hiệu quả hoạt động (2 điểm)',
            items: [
              ('Biên lợi nhuận gộp cải thiện', score.higherGrossMargin),
              ('Vòng quay tài sản tăng', score.higherAssetTurnover),
            ],
          ),
        ],
      ),
    );
  }
}

class _PiotroskiGroup extends StatelessWidget {
  final String title;
  final List<(String, bool)> items;
  const _PiotroskiGroup({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final passed = items.where((e) => e.$2).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: cs.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            '$passed/${items.length}',
            style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
          ),
        ]),
        const SizedBox(height: 4),
        ...items.map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(children: [
              Icon(
                e.$2 ? Icons.check_circle_outline : Icons.radio_button_unchecked,
                size: 14,
                color: e.$2
                    ? const Color(0xFF22C55E)
                    : cs.outlineVariant,
              ),
              const SizedBox(width: 6),
              Text(
                e.$1,
                style: TextStyle(
                  fontSize: 12,
                  color: e.$2 ? cs.onSurface : cs.onSurfaceVariant,
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

// ── Altman Z-Score ────────────────────────────────────────────────────────────

class _AltmanCard extends StatelessWidget {
  final AltmanZScore z;
  const _AltmanCard({required this.z});

  @override
  Widget build(BuildContext context) {
    final color = z.zone == 'safe'
        ? const Color(0xFF22C55E)
        : z.zone == 'grey'
            ? const Color(0xFFF59E0B)
            : const Color(0xFFEF4444);
    final zoneLabel = z.zone == 'safe'
        ? 'An toàn'
        : z.zone == 'grey'
            ? 'Cảnh báo'
            : 'Rủi ro phá sản';

    return _faCard(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: "Altman Z''-Score (EM)",
            badge: _zoneBadge(
                context, '${z.zScore.toStringAsFixed(2)} · $zoneLabel', color),
          ),
          const SizedBox(height: 8),
          Text(
            'An toàn > 2.60   Cảnh báo 1.10–2.60   Rủi ro < 1.10',
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          _AltmanRow('X1  Vốn lưu động / Tổng tài sản', z.x1),
          _AltmanRow('X2  Lợi nhuận giữ lại / Tổng tài sản', z.x2),
          _AltmanRow('X3  EBIT / Tổng tài sản', z.x3),
          _AltmanRow('X4  Vốn hóa / Tổng nợ', z.x4),
        ],
      ),
    );
  }
}

class _AltmanRow extends StatelessWidget {
  final String label;
  final double value;
  const _AltmanRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label,
                style:
                    TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
          ),
          Text(
            value.toStringAsFixed(3),
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// ── Valuation ─────────────────────────────────────────────────────────────────

class _ValuationCard extends StatelessWidget {
  final ValuationResult v;
  const _ValuationCard({required this.v});

  @override
  Widget build(BuildContext context) {
    return _faCard(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: 'Định giá'),
          const SizedBox(height: 12),
          _ValRow(
            label: 'Graham Number',
            value:
                v.grahamNumber != null ? FormatUtils.price(v.grahamNumber!) : null,
            upside: v.grahamUpside,
          ),
          _ValRow(
            label: 'DCF (2-stage FCFF)',
            value: v.dcfValue != null ? FormatUtils.price(v.dcfValue!) : null,
            upside: v.dcfUpside,
          ),
          _ValRow(
            label: 'PEG Ratio',
            value: v.pegRatio != null
                ? v.pegRatio!.toStringAsFixed(2)
                : null,
            note: v.pegRatio != null
                ? (v.pegRatio! < 1.0
                    ? 'Đang bị định giá thấp'
                    : v.pegRatio! > 2.0
                        ? 'Đang bị định giá cao'
                        : null)
                : null,
          ),
          _ValRow(
            label: 'EV / EBITDA',
            value: v.evEbitda != null
                ? v.evEbitda!.toStringAsFixed(1)
                : null,
          ),
          _ValRow(
            label: 'FCF Yield',
            value: v.fcfYield != null
                ? '${v.fcfYield!.toStringAsFixed(1)}%'
                : null,
          ),
        ],
      ),
    );
  }
}

class _ValRow extends StatelessWidget {
  final String label;
  final String? value;
  final double? upside;
  final String? note;
  const _ValRow({required this.label, this.value, this.upside, this.note});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
          if (value == null)
            Text('N/A',
                style: TextStyle(
                    fontSize: 13, color: cs.outlineVariant))
          else
            Row(children: [
              Text(value!,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600)),
              if (upside != null) ...[
                const SizedBox(width: 6),
                _UpsideBadge(upside: upside!),
              ],
              if (note != null) ...[
                const SizedBox(width: 6),
                Text(note!,
                    style: TextStyle(
                        fontSize: 11,
                        color: cs.onSurfaceVariant)),
              ],
            ]),
        ],
      ),
    );
  }
}

class _UpsideBadge extends StatelessWidget {
  final double upside;
  const _UpsideBadge({required this.upside});

  @override
  Widget build(BuildContext context) {
    final isUp = upside >= 0;
    final color =
        isUp ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${isUp ? '+' : ''}${upside.toStringAsFixed(1)}%',
        style: TextStyle(
            fontSize: 11, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ── DuPont ────────────────────────────────────────────────────────────────────

class _DuPontCard extends StatelessWidget {
  final List<DuPontAnalysis> rows;
  const _DuPontCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final display = rows.take(6).toList();

    return _faCard(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: 'Phân tích DuPont — Phân rã ROE'),
          const SizedBox(height: 12),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: FlexColumnWidth(1.4),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1.1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: cs.outlineVariant, width: 0.5),
                  ),
                ),
                children: [
                  _TH('Kỳ'),
                  _TH('ROE'),
                  _TH('Biên LN'),
                  _TH('V/q TS'),
                  _TH('Đòn bẩy'),
                ],
              ),
              ...display.map(
                (r) => TableRow(children: [
                  _TD(r.period),
                  _TD(
                    '${(r.roe * 100).toStringAsFixed(1)}%',
                    color: r.roe >= 0.15
                        ? const Color(0xFF22C55E)
                        : r.roe < 0
                            ? const Color(0xFFEF4444)
                            : null,
                  ),
                  _TD('${(r.netMargin * 100).toStringAsFixed(1)}%'),
                  _TD(r.assetTurnover.toStringAsFixed(2)),
                  _TD(r.equityMultiplier.toStringAsFixed(2)),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Growth ────────────────────────────────────────────────────────────────────

class _GrowthCard extends StatelessWidget {
  final List<GrowthMetrics> rows;
  const _GrowthCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final display = rows.take(6).toList();

    return _faCard(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: 'Tăng trưởng doanh thu & lợi nhuận'),
          const SizedBox(height: 12),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: FlexColumnWidth(1.3),
              1: FlexColumnWidth(1.4),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: cs.outlineVariant, width: 0.5),
                  ),
                ),
                children: [
                  _TH('Kỳ'),
                  _TH('Doanh thu'),
                  _TH('YoY DT'),
                  _TH('YoY LN'),
                ],
              ),
              ...display.map(
                (r) => TableRow(children: [
                  _TD(r.period),
                  _TD(_formatRevenue(r.revenue)),
                  _TD(
                    _fmtGrowth(r.revenueGrowthYoY),
                    color: _growthColor(r.revenueGrowthYoY),
                  ),
                  _TD(
                    _fmtGrowth(r.netIncomeGrowthYoY),
                    color: _growthColor(r.netIncomeGrowthYoY),
                  ),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatRevenue(double v) {
    if (v.abs() >= 1e12) return '${(v / 1e12).toStringAsFixed(1)}N tỷ';
    if (v.abs() >= 1e9) return '${(v / 1e9).toStringAsFixed(1)} tỷ';
    if (v.abs() >= 1e6) return '${(v / 1e6).toStringAsFixed(0)}tr';
    return v.toStringAsFixed(0);
  }

  String _fmtGrowth(double? g) {
    if (g == null) return '–';
    return '${g >= 0 ? '+' : ''}${g.toStringAsFixed(1)}%';
  }

  Color? _growthColor(double? g) {
    if (g == null) return null;
    return g >= 0 ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
  }
}

// ── Risk ──────────────────────────────────────────────────────────────────────

class _RiskCard extends StatelessWidget {
  final RiskMetrics risk;
  const _RiskCard({required this.risk});

  @override
  Widget build(BuildContext context) {
    return _faCard(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: 'Rủi ro thị trường'),
          const SizedBox(height: 12),
          _RiskRow(
            'Biến động (annualized)',
            '${risk.volatility.toStringAsFixed(1)}%',
            hint: risk.volatility > 40
                ? 'Biến động cao'
                : risk.volatility > 20
                    ? 'Trung bình'
                    : 'Ổn định',
          ),
          _RiskRow(
            'Beta so với VN-Index',
            risk.beta.toStringAsFixed(2),
            hint: risk.beta > 1.2
                ? 'Rủi ro cao hơn thị trường'
                : risk.beta < 0.8
                    ? 'Ít biến động hơn thị trường'
                    : null,
          ),
          _RiskRow(
            'Max Drawdown',
            '${risk.maxDrawdown.toStringAsFixed(1)}%',
          ),
          _RiskRow(
            'Sharpe Ratio',
            risk.sharpeRatio.toStringAsFixed(2),
            hint: risk.sharpeRatio > 1
                ? 'Tốt'
                : risk.sharpeRatio < 0
                    ? 'Kém'
                    : null,
          ),
        ],
      ),
    );
  }
}

class _RiskRow extends StatelessWidget {
  final String label;
  final String value;
  final String? hint;
  const _RiskRow(this.label, this.value, {this.hint});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 13, color: cs.onSurfaceVariant)),
          ),
          Row(children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600)),
            if (hint != null) ...[
              const SizedBox(width: 6),
              Text(hint!,
                  style: TextStyle(
                      fontSize: 11, color: cs.onSurfaceVariant)),
            ],
          ]),
        ],
      ),
    );
  }
}

// ── Table helpers ─────────────────────────────────────────────────────────────

Widget _TH(String t) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        t,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
    );

Widget _TD(String t, {Color? color}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        t,
        style: TextStyle(fontSize: 12, color: color),
        textAlign: TextAlign.center,
      ),
    );

// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: cs.error),
            const SizedBox(height: 12),
            Text('Không tải được dữ liệu FA',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
