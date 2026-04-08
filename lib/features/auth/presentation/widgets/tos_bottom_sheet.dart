import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class TosBottomSheet extends ConsumerStatefulWidget {
  const TosBottomSheet({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const TosBottomSheet(),
    );
    return result ?? false;
  }

  @override
  ConsumerState<TosBottomSheet> createState() => _TosBottomSheetState();
}

class _TosBottomSheetState extends ConsumerState<TosBottomSheet> {
  bool _loading = false;

  Future<void> _accept() async {
    setState(() => _loading = true);
    try {
      await ref.read(authServiceProvider).acceptTos();
      if (mounted) Navigator.of(context).pop(true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24, 12, 24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.shield_outlined, color: cs.primary),
              const SizedBox(width: 10),
              Text('Điều khoản sử dụng', style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'FTrade cung cấp thông tin thị trường và phân tích AI mang tính chất tham khảo. '
              'Nội dung không phải tư vấn đầu tư tài chính và không nên được sử dụng làm cơ sở '
              'duy nhất để đưa ra quyết định mua/bán chứng khoán.\n\n'
              'Nhà đầu tư tự chịu trách nhiệm về các quyết định đầu tư của mình. '
              'FTrade không chịu trách nhiệm về bất kỳ tổn thất nào phát sinh từ việc '
              'sử dụng thông tin trên ứng dụng.',
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant, height: 1.6),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _loading ? null : _accept,
              child: _loading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Tôi đồng ý và tiếp tục'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _loading ? null : () => Navigator.of(context).pop(false),
              child: const Text('Hủy'),
            ),
          ),
        ],
      ),
    );
  }
}
