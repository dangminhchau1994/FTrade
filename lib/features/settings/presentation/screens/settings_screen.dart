import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/notification_service.dart';
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
