import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../core/services/iap_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/data/models/app_user.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  ProductDetails? _product;
  bool _loading = true;
  bool _purchasing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProduct();
    IapService.premiumStream.listen((_) {
      if (mounted) context.pop();
    });
  }

  Future<void> _loadProduct() async {
    final product = await IapService.loadProduct();
    if (mounted) setState(() { _product = product; _loading = false; });
  }

  Future<void> _buy() async {
    if (_product == null || _purchasing) return;
    setState(() { _purchasing = true; _error = null; });
    final ok = await IapService.buyPremium(_product!);
    if (!ok && mounted) {
      setState(() {
        _purchasing = false;
        _error = IapService.lastError ?? 'Không thể khởi động thanh toán. Thử lại sau.';
      });
    }
  }

  Future<void> _restore() async {
    setState(() { _purchasing = true; _error = null; });
    await IapService.restorePurchases();
    if (mounted) setState(() => _purchasing = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final user = ref.watch(appUserProvider).valueOrNull;
    final isPremium = user?.tier == UserTier.premium;

    if (isPremium) {
      return Scaffold(
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.workspace_premium, size: 64, color: Color(0xFFF59E0B)),
            const SizedBox(height: 16),
            Text('Bạn đã là Premium!', style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            FilledButton(onPressed: () => context.pop(), child: const Text('Quay lại')),
          ]),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white70),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Icon + title
              const Center(
                child: Icon(Icons.workspace_premium, size: 72, color: Color(0xFFF59E0B)),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text('FTrade Premium',
                    style: tt.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text('Mở khóa toàn bộ phân tích AI',
                    style: tt.bodyMedium?.copyWith(color: const Color(0xFF94A3B8))),
              ),
              const SizedBox(height: 32),
              // Feature list
              ..._features.map((f) => _FeatureRow(icon: f.$1, text: f.$2)),
              const Spacer(),
              // Error
              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_error!, style: const TextStyle(color: Color(0xFFEF4444), fontSize: 13)),
                ),
                const SizedBox(height: 12),
              ],
              // Subscribe button
              FilledButton(
                onPressed: _loading || _purchasing ? null : _buy,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _purchasing
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                    : Text(
                        _loading ? 'Đang tải...' : (_product?.price ?? 'Đăng ký Premium'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
              const SizedBox(height: 12),
              // Restore
              TextButton(
                onPressed: _purchasing ? null : _restore,
                child: Text('Khôi phục giao dịch',
                    style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13)),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text('Gia hạn tự động · Hủy bất kỳ lúc nào',
                    style: tt.bodySmall?.copyWith(color: const Color(0xFF475569))),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

const _features = [
  (Icons.analytics_outlined, 'Xem toàn bộ 7 nhóm ngành mỗi sáng'),
  (Icons.trending_up, 'Phân tích tác động chi tiết từng sector'),
  (Icons.star_outline, 'Danh sách mã đáng chú ý theo sector'),
  (Icons.notifications_outlined, 'Nhận thông báo khi bản tin sẵn sàng'),
];

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Icon(icon, color: const Color(0xFFF59E0B), size: 22),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14))),
      ]),
    );
  }
}
