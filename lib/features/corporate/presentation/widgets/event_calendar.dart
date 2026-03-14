import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/corporate_event.dart';
import '../providers/corporate_providers.dart';

class EventCalendar extends ConsumerWidget {
  const EventCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(upcomingEventsProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(upcomingEventsProvider),
      child: events.when(
        data: (data) {
          final sorted = List<CorporateEvent>.from(data)
            ..sort((a, b) => a.eventDate.compareTo(b.eventDate));

          // Group by month
          final grouped = <String, List<CorporateEvent>>{};
          for (final event in sorted) {
            final key = DateFormat('MM/yyyy').format(event.eventDate);
            grouped.putIfAbsent(key, () => []).add(event);
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: grouped.length,
            itemBuilder: (context, index) {
              final month = grouped.keys.elementAt(index);
              final monthEvents = grouped[month]!;
              return _MonthSection(month: month, events: monthEvents);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
      ),
    );
  }
}

class _MonthSection extends StatelessWidget {
  final String month;
  final List<CorporateEvent> events;

  const _MonthSection({required this.month, required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            'Tháng $month',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...events.map((e) => _EventTile(event: e)),
      ],
    );
  }
}

class _EventTile extends StatelessWidget {
  final CorporateEvent event;

  const _EventTile({required this.event});

  IconData _icon() {
    switch (event.type) {
      case CorporateEventType.earnings:
        return Icons.assessment;
      case CorporateEventType.agm:
        return Icons.account_balance;
      case CorporateEventType.dividend:
        return Icons.payments;
      case CorporateEventType.rightsIssue:
        return Icons.receipt_long;
      case CorporateEventType.other:
        return Icons.event;
    }
  }

  Color _color() {
    switch (event.type) {
      case CorporateEventType.earnings:
        return Colors.blue;
      case CorporateEventType.agm:
        return Colors.orange;
      case CorporateEventType.dividend:
        return Colors.green;
      case CorporateEventType.rightsIssue:
        return Colors.purple;
      case CorporateEventType.other:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    return ListTile(
      onTap: () => context.push('/stock/${event.symbol}'),
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(_icon(), size: 18, color: color),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              event.symbol,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              event.title,
              style: const TextStyle(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      subtitle: Text(
        DateFormat('dd/MM/yyyy').format(event.eventDate),
        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
      ),
      dense: true,
    );
  }
}
