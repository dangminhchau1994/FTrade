import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AiSummaryHeroCard extends StatelessWidget {
  final List<String> bullets;
  final String title;
  final DateTime createdAt;
  final bool isFallback;
  final String? fallbackReason;

  const AiSummaryHeroCard({
    super.key,
    required this.bullets,
    required this.title,
    required this.createdAt,
    this.isFallback = false,
    this.fallbackReason,
  });

  static Widget loading() => Shimmer.fromColors(
        baseColor: const Color(0xFF1E293B),
        highlightColor: const Color(0xFF334155),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 160,
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final h = _formatTime(createdAt);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1D4ED8), Color(0xFF1E293B)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha:0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('✦ AI Tóm tắt', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white70, letterSpacing: 0.5)),
            const Spacer(),
            Text(h, style: const TextStyle(fontSize: 11, color: Colors.white54)),
            if (isFallback) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFEAB308).withValues(alpha:0.2), borderRadius: BorderRadius.circular(4)),
                child: const Text('Bản tin cũ', style: TextStyle(fontSize: 10, color: Color(0xFFEAB308), fontWeight: FontWeight.w600)),
              ),
            ],
          ]),
          const SizedBox(height: 8),
          Text(title, style: tt.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...bullets.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(width: 5, height: 5, margin: const EdgeInsets.only(top: 5, right: 8), decoration: const BoxDecoration(color: Color(0xFF3B82F6), shape: BoxShape.circle)),
                  Expanded(child: Text(b, style: const TextStyle(fontSize: 13, color: Colors.white, height: 1.5))),
                ]),
              )),
          if (isFallback && fallbackReason != null) ...[
            const SizedBox(height: 8),
            Text(fallbackReason!, style: const TextStyle(fontSize: 11, color: Colors.white54)),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final mo = dt.month.toString().padLeft(2, '0');
    return '$h:$m · $d/$mo';
  }
}
