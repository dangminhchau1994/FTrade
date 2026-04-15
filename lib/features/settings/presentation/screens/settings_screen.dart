import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/mqtt_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../market/presentation/providers/market_data_controller.dart';
import '../../../watchlist/data/services/contextual_alert_monitor.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: ListView(
        children: [
          const _SettingsSection(title: 'Giao diện'),
          SwitchListTile(
            title: const Text('Chế độ tối'),
            subtitle: const Text('Sử dụng giao diện tối'),
            value: isDark,
            onChanged: (_) => ref.read(themeModeProvider.notifier).toggle(),
            secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
          ),
          const Divider(),
          const _SettingsSection(title: 'Thông báo'),
          SwitchListTile(
            title: const Text('Cảnh báo giá'),
            subtitle: const Text('Nhận thông báo khi giá đạt mục tiêu'),
            value: false,
            onChanged: (value) {},
            secondary: const Icon(Icons.notifications),
          ),
          SwitchListTile(
            title: const Text('Tin tức quan trọng'),
            subtitle: const Text('Thông báo tin tức liên quan đến watchlist'),
            value: true,
            onChanged: (value) {},
            secondary: const Icon(Icons.newspaper),
          ),
          const Divider(),
          const _SettingsSection(title: 'Dữ liệu'),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Nguồn dữ liệu'),
            subtitle: const Text('VietStock'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text('Sàn giao dịch'),
            subtitle: const Text('VNDirect'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),
          const _SettingsSection(title: 'Developer'),
          _MqttStatusTile(),
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text('Test local notification'),
            subtitle: const Text('Kiểm tra notification hoạt động'),
            onTap: () async {
              await NotificationService.showContextualAlert(
                id: 'test_${DateTime.now().millisecondsSinceEpoch}',
                title: '🔔 Test thành công',
                body: 'Notification hoạt động bình thường!',
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã gửi test notification')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.manage_search),
            title: const Text('Scan sự kiện watchlist ngay'),
            subtitle: const Text('Chạy Contextual Alert monitor thủ công'),
            onTap: () async {
              await ref.read(contextualAlertMonitorProvider).check();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã scan xong — kiểm tra notification')),
                );
              }
            },
          ),
          const Divider(),
          const _SettingsSection(title: 'Khác'),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Xóa cache'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa cache')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Phiên bản'),
            subtitle: const Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}

class _MqttStatusTile extends ConsumerStatefulWidget {
  @override
  ConsumerState<_MqttStatusTile> createState() => _MqttStatusTileState();
}

class _MqttStatusTileState extends ConsumerState<_MqttStatusTile> {
  Timer? _refreshTimer;
  int _msgCount = 0;
  DateTime? _lastMsg;

  @override
  void initState() {
    super.initState();
    // Poll message count every 2 seconds (count is a simple int, not a stream)
    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      final ds = ref.read(marketRealtimeDatasourceProvider);
      if (mounted) {
        setState(() {
          _msgCount = ds.mqttMessageCount;
          _lastMsg = ds.mqttLastMessage;
        });
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusAsync = ref.watch(marketConnectionStatusProvider);
    final (label, color, icon) = statusAsync.when(
      data: (s) => switch (s) {
        MqttConnectionStatus.connected    => ('Đã kết nối', Colors.green, Icons.wifi),
        MqttConnectionStatus.connecting   => ('Đang kết nối...', Colors.orange, Icons.wifi_find),
        MqttConnectionStatus.disconnected => ('Mất kết nối', Colors.red, Icons.wifi_off),
      },
      loading: () => ('Chờ...', Colors.grey, Icons.wifi_find),
      error: (_, __) => ('Lỗi', Colors.red, Icons.error_outline),
    );

    final lastTime = _lastMsg == null
        ? 'chưa nhận message'
        : 'last: ${_lastMsg!.hour.toString().padLeft(2,'0')}:${_lastMsg!.minute.toString().padLeft(2,'0')}:${_lastMsg!.second.toString().padLeft(2,'0')}';

    return ListTile(
      leading: Icon(icon, color: color),
      title: const Text('MQTT Realtime'),
      subtitle: Text(
        '$label · $_msgCount msgs · $lastTime',
        style: TextStyle(color: color, fontSize: 12),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.refresh, size: 20),
        tooltip: 'Reconnect',
        onPressed: () {
          ref.read(marketDataControllerProvider.notifier).disconnect()
              .then((_) => ref.read(marketDataControllerProvider.notifier).connect());
        },
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;

  const _SettingsSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
