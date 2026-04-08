import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider<bool>((ref) {
  return Connectivity()
      .onConnectivityChanged
      .map((results) => !results.contains(ConnectivityResult.none));
});

class ConnectivityBanner extends ConsumerWidget {
  final Widget child;
  const ConnectivityBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(connectivityProvider).valueOrNull ?? true;

    return Column(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: isOnline
              ? const SizedBox.shrink()
              : Material(
                  color: Colors.transparent,
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFEAB308),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.wifi_off, size: 16, color: Colors.black87),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Đang offline — dữ liệu có thể không cập nhật',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.black87, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
