import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/widgets/tos_bottom_sheet.dart';
import '../../../watchlist/presentation/providers/watchlist_providers.dart';
import '../providers/morning_brief_provider.dart';
import '../widgets/ai_summary_hero_card.dart';
import '../widgets/sector_card.dart';

class MorningBriefScreen extends ConsumerStatefulWidget {
  const MorningBriefScreen({super.key});

  @override
  ConsumerState<MorningBriefScreen> createState() => _MorningBriefScreenState();
}

class _MorningBriefScreenState extends ConsumerState<MorningBriefScreen> {
  bool _tosChecked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_tosChecked) {
      _tosChecked = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkTos());
    }
  }

  Future<void> _checkTos() async {
    final user = ref.read(appUserProvider).valueOrNull;
    if (user == null || user.tosAccepted) return;
    if (!mounted) return;
    final accepted = await TosBottomSheet.show(context);
    if (!accepted && mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final briefAsync = ref.watch(morningBriefProvider);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(morningBriefProvider.future),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // App bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bản tin sáng', style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                          Text(_todayLabel(), style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                        ],
                      ),
                      const Spacer(),
                      briefAsync.when(
                        data: (b) => b != null
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.4)),
                                ),
                                child: const Row(children: [
                                  Text('✦ AI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF3B82F6))),
                                ]),
                              )
                            : const SizedBox.shrink(),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              briefAsync.when(
                loading: () => SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 8),
                    AiSummaryHeroCard.loading(),
                    const SizedBox(height: 16),
                    ...List.generate(3, (_) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SectorCard.loading(),
                    )),
                  ]),
                ),
                error: (err, _) => SliverFillRemaining(
                  child: _ErrorState(onRetry: () => ref.refresh(morningBriefProvider.future)),
                ),
                data: (brief) {
                  if (brief == null) {
                    return SliverFillRemaining(
                      child: _EmptyState(onRetry: () => ref.refresh(morningBriefProvider.future)),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 8),
                      AiSummaryHeroCard(
                        title: brief.date,
                        bullets: brief.summary,
                        createdAt: brief.createdAt,
                        isFallback: brief.isFallback,
                        fallbackReason: brief.fallbackReason,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                        child: Text('${brief.sectors.length} nhóm ngành đáng chú ý',
                            style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant, letterSpacing: 0.5, fontWeight: FontWeight.w600)),
                      ),
                      ...brief.sectors.asMap().entries.map((e) {
                        final feedbackMap = ref.watch(feedbackProvider(brief.date));
                        return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: SectorCard(
                              sector: e.value,
                              isLocked: e.key > 0 && !_isPremium(),
                              initialFeedback: feedbackMap[e.value.sectorId],
                              onFeedback: (sectorId, isAccurate) =>
                                  _submitFeedback(brief.date, sectorId, isAccurate),
                            ),
                          );
                      }),
                      _AiWatchlistBanner(brief: brief),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Cập nhật lúc ${_formatTime(brief.createdAt)} · Dữ liệu đến ${brief.date}',
                          style: tt.bodySmall?.copyWith(color: cs.outlineVariant),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isPremium() {
    return ref.read(appUserProvider).valueOrNull?.tier.name == 'premium';
  }

  Future<void> _submitFeedback(String briefDate, String sectorId, bool isAccurate) async {
    ref.read(feedbackProvider(briefDate).notifier).submit(sectorId, isAccurate);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAccurate ? 'Cảm ơn phản hồi!' : 'Đã ghi nhận đánh giá'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  String _todayLabel() {
    final now = DateTime.now();
    const days = ['Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật'];
    return '${days[now.weekday - 1]}, ${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _AiWatchlistBanner extends ConsumerWidget {
  final dynamic brief;
  const _AiWatchlistBanner({required this.brief});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlist = ref.watch(watchlistSymbolsProvider);
    final notifier = ref.read(watchlistSymbolsProvider.notifier);

    // Collect all unique symbols from all sectors
    final allSymbols = <String>{};
    for (final sector in brief.sectors) {
      for (final stock in sector.stocks) {
        allSymbols.add(stock.symbol as String);
      }
    }
    final newSymbols = allSymbols.where((s) => !watchlist.contains(s)).toList();

    if (allSymbols.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
        ),
        child: Row(children: [
          const Icon(Icons.auto_awesome, size: 16, color: Color(0xFFF59E0B)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              newSymbols.isEmpty
                  ? 'Đã theo dõi tất cả ${allSymbols.length} mã AI gợi ý ✓'
                  : 'AI gợi ý ${allSymbols.length} mã hôm nay',
              style: const TextStyle(fontSize: 13, color: Color(0xFFF59E0B)),
            ),
          ),
          if (newSymbols.isNotEmpty)
            TextButton(
              onPressed: () {
                for (final s in newSymbols) { notifier.add(s); }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Đã thêm ${newSymbols.length} mã vào Watchlist ⭐'),
                  duration: const Duration(seconds: 2),
                ));
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFF59E0B),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text('Thêm tất cả (${newSymbols.length})', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
        ]),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.warning_amber_outlined, size: 40, color: Color(0xFF94A3B8)),
        const SizedBox(height: 12),
        const Text('Không tải được bản tin', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        const SizedBox(height: 16),
        FilledButton.tonal(onPressed: onRetry, child: const Text('Thử lại')),
      ]),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onRetry;
  const _EmptyState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.wb_sunny_outlined, size: 48, color: Color(0xFF3B82F6)),
        const SizedBox(height: 12),
        const Text('Bản tin sáng sẽ sẵn sàng lúc 7h30', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        const Text('Quay lại sau nhé!', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
        const SizedBox(height: 16),
        TextButton(onPressed: onRetry, child: const Text('Kiểm tra lại')),
      ]),
    );
  }
}
