import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/models/morning_brief.dart';

class SectorCard extends StatefulWidget {
  final SectorAnalysis sector;
  final bool isLocked;
  final bool? initialFeedback;
  final void Function(String sectorId, bool isAccurate)? onFeedback;

  const SectorCard({
    super.key,
    required this.sector,
    this.isLocked = false,
    this.initialFeedback,
    this.onFeedback,
  });

  static Widget loading() => Shimmer.fromColors(
        baseColor: const Color(0xFF1E293B),
        highlightColor: const Color(0xFF334155),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 64,
          decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
        ),
      );

  @override
  State<SectorCard> createState() => _SectorCardState();
}

class _SectorCardState extends State<SectorCard> {
  bool _expanded = false;
  bool? _feedbackValue;

  @override
  void initState() {
    super.initState();
    _feedbackValue = widget.initialFeedback;
  }

  @override
  void didUpdateWidget(covariant SectorCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialFeedback != null && _feedbackValue == null) {
      _feedbackValue = widget.initialFeedback;
    }
  }

  String get _impactEmoji {
    return switch (widget.sector.impact) {
      SectorImpact.positive => '▲',
      SectorImpact.negative => '▼',
      SectorImpact.neutral => '●',
    };
  }

  Color get _impactColor {
    return switch (widget.sector.impact) {
      SectorImpact.positive => const Color(0xFF22C55E),
      SectorImpact.negative => const Color(0xFFEF4444),
      SectorImpact.neutral => const Color(0xFFEAB308),
    };
  }

  String get _sectorIcon {
    return switch (widget.sector.sectorId) {
      'banking' => '🏦',
      'real_estate' => '🏗️',
      'technology' => '💻',
      'energy' => '⚡',
      'consumer' => '🛒',
      'steel_materials' => '🏭',
      'agriculture' => '🌾',
      _ => '📊',
    };
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _expanded ? const Color(0xFF3B82F6) : cs.outlineVariant),
      ),
      child: widget.isLocked ? _buildLocked(context) : _buildUnlocked(context, cs, tt),
    );
  }

  Widget _buildLocked(BuildContext context) {
    return Stack(
      children: [
        // Blurred content
        Opacity(
          opacity: 0.15,
          child: _buildHeader(Theme.of(context).colorScheme, Theme.of(context).textTheme),
        ),
        // Overlay
        Container(
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 16, color: Color(0xFF94A3B8)),
              const SizedBox(width: 8),
              const Text('Premium', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
              const SizedBox(width: 16),
              FilledButton.tonal(
                onPressed: () => context.push('/paywall'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Nâng cấp', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUnlocked(BuildContext context, ColorScheme cs, TextTheme tt) {
    return Column(
      children: [
        _buildHeader(cs, tt),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: _buildBody(cs, tt),
        ),
      ],
    );
  }

  Widget _buildHeader(ColorScheme cs, TextTheme tt) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Text(_sectorIcon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.sector.sectorName, style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  Text(widget.sector.impactSummary, style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: _impactColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
              child: Text('$_impactEmoji ${widget.sector.impactSummary.split(' ').first}',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _impactColor)),
            ),
            const SizedBox(width: 8),
            AnimatedRotation(
              turns: _expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.keyboard_arrow_down, size: 18, color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(ColorScheme cs, TextTheme tt) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(widget.sector.analysis, style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant, height: 1.6)),
          const SizedBox(height: 12),
          // Stock chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.sector.stocks.map((s) => _StockChip(stock: s)).toList(),
          ),
          const SizedBox(height: 12),
          // Disclaimer
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border(left: BorderSide(color: cs.outline, width: 2)),
            ),
            child: Text(widget.sector.disclaimer, style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant, height: 1.5)),
          ),
          const SizedBox(height: 10),
          // Feedback row
          if (_feedbackValue == null)
            Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() => _feedbackValue = true);
                    widget.onFeedback?.call(widget.sector.sectorId, true);
                  },
                  icon: const Icon(Icons.check, size: 14),
                  label: const Text('Chính xác', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() => _feedbackValue = false);
                    widget.onFeedback?.call(widget.sector.sectorId, false);
                  },
                  icon: const Icon(Icons.close, size: 14),
                  label: const Text('Không đúng', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                ),
              ),
            ])
          else
            Center(
              child: Text(
                _feedbackValue! ? '✓ Cảm ơn phản hồi!' : '✗ Đã ghi nhận',
                style: TextStyle(fontSize: 12, color: _feedbackValue! ? const Color(0xFF22C55E) : const Color(0xFF94A3B8)),
              ),
            ),
        ],
      ),
    );
  }
}

class _StockChip extends StatelessWidget {
  final StockMention stock;
  const _StockChip({required this.stock});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: stock.reason,
      child: GestureDetector(
        onTap: () => context.push('/stock/${stock.symbol}'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          child: Text(stock.symbol, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
